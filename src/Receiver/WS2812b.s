//=====================================================================
//项目：F401-WS2812b-ADA6
//文件：/src/Controller/Main.s
//SPDX标识：SPDX-License-Identifier: LGPL-3.0-only
//版权所有：Copyright (C) 2025 张烁
//		芯星-X++开发团队（https://gitee.com/CoreStarXpp）
//协议：完整文本见/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//WS2812b驱动程序
//*********************************************************************

//---------------------------------------------------------------------
//Start
//平台：STM32F401RCT6 PLL=84MHz
//编译器：arm-none-eabi

//WARN!!!请勿删去更新条件标志的指令后的NOP，后果自负！！！

.syntax unified
.cpu cortex-m4				//指定Cortex-M4内核
.thumb					//指定Thumb语法
.global WS2812b				//声明全局WS2812b

.text

WS2812b:

//预准备
	PUSH {R14}			//保存返回地址
	LDR R0, [R2]
	BIC R0, R0, R1
	STR R0, [R2]
	LDR R3, [R5], #0x04
	SUBS R6, R6, #0x01
	MOV R7, #0x012000		// 加载Reset等待周期，实际运行周期数=R7*5（约80us，但灯光效果需要，此处为4388us）（实际取值若没有极致性能要求请取16位或灵活8位数）
	
Start:
	MOV R4, #0x00800000
	TST R3, R4
	NOP
	BNE Core_1

// Core0 低位信号 0.35us高电平+0.8us低电平
Core_0:
	LDR R0, [R2]
	ORR R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x03			//取值方法：R0=（所需周期-13）/5，结果取整
	BL WaitCore
	LDR R0, [R2]
	BIC R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x09			//取值方法：R0=（所需周期-20）/5，结果取整
	BL WaitCore
	LSRS R4, R4, #0x01
	BEQ Exit
	TST R3, R4
	NOP
	BEQ Core_0

// Core1 高位信号 0.7us高电平+0.6us低电平
Core_1:
	LDR R0, [R2]
	ORR R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x09			//取值方法：R0=（所需周期-13）/5，结果取整
	BL WaitCore
	LDR R0, [R2]
	BIC R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x07			//取值方法：R0=（所需周期-20）/5，结果取整
	BL WaitCore
	LSRS R4, R4, #0x01
	BEQ Exit
	TST R3, R4
	NOP
	BEQ Core_0
	B Core_1

Exit:
	CMP R6, #0x00
	NOP
	BNE ColorUpdate_ws
	BL Deep1
	POP {R14}
	BX LR

ColorUpdate_ws:
	LDR R3, [R5], #0x04
	SUBS R6, R6, #0x01
	B Start


Deep1:
	SUBS R7, R7, #0x01
	NOP
	BNE Deep1
	BX LR

WaitCore:
	SUBS R0, R0, #0x01
	NOP
	BNE WaitCore
	BX LR

//End
//---------------------------------------------------------------------
