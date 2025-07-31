//=====================================================================
//项目：F401-WS2812b-ADA6
//文件：/src/Controller/Main.s
//SPDX标识：SPDX-License-Identifier: LGPL-3.0-only
//版权所有：Copyright (C) 2025 张烁
//		芯星-X++开发团队（https://gitee.com/CoreStarXpp）
//协议：完整文本见/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//初始化外设，并等待触发，发送0xff010100
//*********************************************************************

//---------------------------------------------------------------------
//Start
//平台：STM32F401RCT6 HSI=16MHz
//	XY-MB035A 9600bps 已配置自动连接
//编译器：arm-none-eabi

.syntax unified
.cpu cortex-m4				//指定Cortex-M4内核
.thumb					//指定Thumb语法
.global _start				//声明全局_start

.text

_start:

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
	ORR R1, #0x280000		//配置PA9、PA10为复用功能
	STR R1, [R0]			//写入GPIOA_MODER
	LDR R1, [R0, #0x08]		//读取GPIOA_OSPEEDR
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
	MOV R1, #0x0683			//16MHz->9600bps
	STR R1, [R0, #0x08]		//写入USART_BRR
	MOV R1, #0x00			//再次清除USART_CR1（关闭USART）
	STR R1, [R0, #0x0C]		//写入USART_CR1
	MOV R1, #0x200C			//置位RE、TE、UE（接收器启用，发送器启用，USART1启用）
	STR R1, [R0, #0x0c]		//写入USART_CR1

//GPIOA基址
	MOVW R2, #0x00
	MOVT R2, #0x4002

//等待PA0高电平
loop:
	LDR R1, [R2, #0x10]		//读取GPIOA_IDR
	TST R1, #0x01			//测试0位（PA0）高电平
	BEQ loop			//不匹配则继续等待
loop0:
	LDR R1, [R2, #0x10]		//读取GPIOA_IDR
	TST R1, #0x01			//测试0位（PA0）低电平
	BNE loop0			//不匹配则继续等待

//发送数据
WaitTXE0:
	LDR R1, [R0]			//读取USART_SR
	TST R1, #0x80			//测试TXE位为1（DR寄存器为空）
	BEQ WaitTXE0			//不匹配则继续等待
	MOV R1, #0xFF			//数据0xFF
	STR R1, [R0, #0x04]		//写入USART_DR
WaitTC0:
	LDR R1, [R0]			//读取USART_SR
	TST R1, #0x40			//测试TC位为1（数据发送完成）
	BEQ WaitTC0			//不匹配则继续等待
WaitTXE1:
	LDR R1, [R0]
	TST R1, #0x80
	BEQ WaitTXE1
	MOV R1, #0x01			//数据0x01
	STR R1, [R0, #0x04]
WaitTC1:
	LDR R1, [R0]
	TST R1, #0x40
	BEQ WaitTC1
WaitTXE2:
	LDR R1, [R0]
	TST R1, #0x80
	BEQ WaitTXE2
	MOV R1, #0x01			//数据0x01
	STR R1, [R0, #0x04]
WaitTC2:
	LDR R1, [R0]
	TST R1, #0x40
	BEQ WaitTC2
WaitTXE3:
	LDR R1, [R0]
	TST R1, #0x80
	BEQ WaitTXE3
	MOV R1, #0x00			//数据0x00
	STR R1, [R0, #0x04]
WaitTC3:
	LDR R1, [R0]
	TST R1, #0x40
	BEQ WaitTC3
	B loop				//新循环

//End
//---------------------------------------------------------------------
