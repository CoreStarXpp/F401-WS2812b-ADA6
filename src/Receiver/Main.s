//=====================================================================
//项目：F401-WS2812b-ADA6
//文件：/src/Controller/Main.s
//SPDX标识：SPDX-License-Identifier: LGPL-3.0-only
//版权所有：Copyright (C) 2025 张烁
//		芯星-X++开发团队（https://gitee.com/CoreStarXpp）
//协议：完整文本见/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//初始化外设，并等待数据0xff010100，驱动灯带
//*********************************************************************

//---------------------------------------------------------------------
//Start
//平台：STM32F401RCT6 HSI=16MHz HSE=25Mhz PLL=84MHz
//	XY-MB035A 9600bps 已配置自动连接
//	WS2812b 5V 160灯
//编译器：arm-none-eabi
//使用寄存器：R0、R1、R2

.syntax unified
.cpu cortex-m4				// 指定Cortex-M4内核
.thumb					// 指定Thumb语法
.global _start				// 声明全局_start

.text

_start:

//配置Flash等待周期为3
	MOVW R0, #0x3C00
	MOVT R0, #0x4002		// Flash interface register基址
	MOV R1, #0x3			// 三个等待周期
	STR R1, [R0]			// 写入Flash_ACR

//配置RCC
	MOVW R0, #0x3800
	MOVT R0, #0x4002		//RCC基址
	LDR R1, [R0]			//读取RCC_CR
	ORR R1, R1, #0x10000		//置位HSE ON位，开启HSE
	STR R1, [R0]			//写入RCC_CR

WaitHSEReady:				//等待HSE工作
	LDR R1, [R0]			//读取RCC_CR
	TST R1, #0x20000		//测试HSERDY位
	BEQ WaitHSEReady		//不匹配则继续等待

	LDR R1, [R0, #0x04]		//读取RCC_PLLCFGR
	MOVW R2, #0x7FFF
	MOVT R2, #0x3			//PLLM、PLLN、PLLP
	BIC R1, R1, R2			//清除PLLM、PLLN、PLLP
	ORR R1, R1, #0x19
	ORR R1, R1, #0x5400
	ORR R1, R1, #0x410000		//PLLM=25，PLLN=336，PLLP=1（对应4）|PLL=HSE*（PLLN/PLLM）/PLLP=25*（336/25）/4=84MHz
	STR R1, [R0, #0x04]		//写入RCC_PLLCFGR
	LDR R1, [R0]			//读取RCC_CR
	ORR R1, #0x1000000		//置位PLLON，开启PLL
	STR R1, [R0]			//写入RCC_CR

WaitPLLReady:				//等待PLL稳定
	LDR R1, [R0]			//读取RCC_CR
	TST R1, #0x2000000		//测试PLLRDY位
	BEQ WaitPLLReady		//不匹配则继续等待

	LDR R1, [R0, #0x08]		//读取RCC_CFGR
	MOVW R2, #0xFCF3
	MOVT R2, #0x1F			//SW、HPRE、PPRE1、PPRE2、RTCPRE
	BIC R1, R2			//清除SW、HPRE、PPRE1、PPRE2、RTCPRE
	MOVW R2, #0x1002
	MOVT R2, #0x19			//SW=0b10（PLL时钟），HPRE=0（AHB=84MHz），PPRE1=0b100（APB1=42MHZ Max），PPRE2=0（APB2=84MHz），RTCPRE=0b11001（RTC=HSE/25=1MHz 必须）
	ORR R1, R2			//同上
	STR R1, [R0, #0x08]		//写入RCC_CFGR

WaitSwitch:				//等待切换完成
	LDR R1 ,[R0 ,#0x08]		//读取RCC_CFGR
	AND R1 ,#0x0C			//提取2，3位
	CMP R1 ,#0x08			//检测SWS与0b10
	BNE WaitSwitch			//不匹配则继续等待


//配置RCC
	MOVW R0, #0x3800
	MOVT R0, #0x4002		//RCC基址
	LDR R1, [R0, #0x30]		//读取RCC_AHB1ENR
	ORR R1, #0x01			//置0位（GPIOAEN）开启GPIOA
	STR R1, [R0, #0x30]		//写入RCC_AHB1ENR
	LDR R1, [R0, #0x44]		//读取RCC_APB2ENR
	ORR R1, #0x10			//置4位（USART1EN）开启USART1
	STR R1, [R0, #0x44]		//写入RCC_APB2ENR

//配置GPIOA
	MOVW R0, #0x00
	MOVT R0, #0x4002		//GPIOA基址
	LDR R1, [R0]			//读取GPIOA_MODER
	ORR R1, #0x01			//配置PA0为推挽输出
	ORR R1, #0x280000		//配置PA9、PA10为复用功能
	STR R1, [R0]			//写入GPIOA_MODER
	LDR R1, [R0, #0x08]		//读取GPIOA_OSPEEDR
	ORR R1, #0x03			//配置PA0为超高速模式
	ORR R1, #0x3C0000		//配置PA9、PA10为超高速模式
	STR R1, [R0, #0x08]		//写入GPIOA_OSPEEDR
	LDR R1, [R0, #0x24]		//读取GPIOA_AFRH
	ORR R1, #0x0770			//配置PA9、PA10为AF7（USART）
	STR R1, [R0, #0x24]		//写入GPIOA_AFRH

//配置USART1
	MOVW R0, #0x1000
	MOVT R0, #0x4001		//USART1基址
	MOV R1, #0x00			//清除USART_CR1（关闭USART1）
	STR R1, [R0, #0x0C]		//写入USART_CR1
	MOV R1 ,#0x219C			//84MHz->9600bps
	STR R1, [R0, #0x08]		//写入USART_BRR
	MOV R1, #0x00			//再次清除USART_CR1（关闭USART）
	STR R1, [R0, #0x0C]		//写入USART_CR1
	MOV R1, #0x200C			//置位RE、TE、UE（接收器启用，发送器启用，USART1启用）
	STR R1, [R0, #0x0c]		//写入USART_CR1

//等待接收数据
loop:
	LDR R1, [R0]			//读取USART_SR
	ANDS R1, #0x20			//测试RXNE位（接收数据标识）
	BEQ loop			//不匹配则继续等待
	LDR R1, [R0, #0x04]		//读取USART_DR
	CMP R1, #0xFF			//测试数据是否是0xFF
	BNE loop			//不匹配则重新等待

loop0:
	LDR R1, [R0]
	ANDS R1, #0x20
	BEQ loop0
	LDR R1, [R0, #0x04]
	CMP R1, #0x01			//测试数据是否是0x01
	BNE loop

loop1:
	LDR R1, [R0]
	ANDS R1, #0x20
	BEQ loop1
	LDR R1, [R0, #0x04]
	CMP R1, #0x01			//测试数据是否是0x01
	BNE loop

loop2:
	LDR R1, [R0]
	ANDS R1, #0x20
	BEQ loop2
	LDR R1, [R0, #0x04]
	CMP R1, #0x00			//测试数据是否是0x00
	BNE loop

	BL ADA6				//调用灯光控制程序
	B loop				//完成后开启新等待

//WARN!!! 测试数据不匹配后一定要开启新循环，否则类似数据0xFF8701888401CD00也会触发!!!

//End
//---------------------------------------------------------------------
