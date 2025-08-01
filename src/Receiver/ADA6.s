//=====================================================================
//项目：F401-WS2812b-ADA6
//文件：/src/Controller/ADA6.s
//SPDX标识：SPDX-License-Identifier: LGPL-3.0-only
//版权所有：Copyright (C) 2025 张烁
//		芯星-X++开发团队（https://gitee.com/CoreStarXpp）
//协议：完整文本见/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//灯光效果驱动
//*********************************************************************

//---------------------------------------------------------------------
//Start
//平台：STM32F401RCT6 PLL=84MHz
//编译器：arm-none-eabi

.syntax unified
.cpu cortex-m4				//指定Cortex-M4内核
.thumb					//指定Thumb语法
.global ADA6				//声明全局ADA6

.text

ADA6:
//预准备
	PUSH {R0, R14}			//保存R0（USART1基址）和R14（RL返回地址）
	MOVW R1, #0x2000
	MOVT R1, #0x2000			//灯带颜色信息存放区（可修改）
	MOV R4, #0x027C			//高频常量数据（减轻体积）
	MOV R6, #0x0140			//高频常量数据（减轻体积）
	MOV R7, #0x013C			//高频常量数据（减轻体积）
	MOVW R8, #:lower16:Rest_ws0+1
	MOVT R8, #:upper16:Rest_ws0	//回流地址
	MOV R3, #0x0140			//动态流地址（对应灯珠号*4）

//仅标注重要部分，核心逻辑见相关资料

Rest_ws0:
	SUB R3, R3, #0x04			//动态回流地址要比颜色数据中址大（或小）4，否则第一灯位被掠过，若将指令移至循环末尾则最后一灯位被掠过
	BL Clean			//清除等待颜色信息存放区
	MOV R2, R3
	STR R0, [R1, R2]
Rest_ws_a0:
	CMP R2, R7
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a0
	SUB R2, R4, R3
	STR R0, [R1, R2]
Rest_ws_b0:
	CMP R2, R6
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b0
	CMP R3, #0x00
	ITTT EQ
	MOVWEQ R8, #:lower16:Rest_ws1+1
	MOVTEQ R8, #:upper16:Rest_ws1	//更新回流地址
	MOVEQ R3, R6			//更新动态流地址
	B WS_Wait				//跳转准备区

Rest_ws1:
	SUB R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
Rest_ws_a1:
	CMN R2, #0x04
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a1
	SUB R2, R4, R3
	STR R0, [R1, R2]
Rest_ws_b1:
	CMP R2, #0x0280
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b1
	CMP R3, #0x00
	ITTT EQ
	MOVWEQ R8, #:lower16:Rest_ws2+1
	MOVTEQ R8, #:upper16:Rest_ws2
	MOVEQ R3, R6
	B WS_Wait

Rest_ws2:
	SUB R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
	ADD R5, R2, #0x1C
	CMP R5, R6
	IT GT
	MOVGT R5, R6
Rest_ws_a2:
	CMP R2, R5
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a2
	SUB R2, R4, R3
	STR R0, [R1, R2]
	SUB R5, R2, #0x1C
	CMP R5, R7
	IT LT
	MOVLT R5, R7
Rest_ws_b2:
	CMP R2, R5
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b2
	CMP R3, #0x00
	ITTT EQ
	MOVWEQ R8, #:lower16:Rest_ws3+1
	MOVTEQ R8, #:upper16:Rest_ws3
	MVNEQ R3, #0x03
	B WS_Wait

Rest_ws3:
	ADD R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
	ADD R5, R2, #0x1C
	CMP R5, R6
	IT GT
	MOVGT R5, R6
Rest_ws_a3:
	CMP R2, R5
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a3
	SUB R2, R4, R3
	STR R0, [R1, R2]
	SUB R5,R2,#28
	CMP R5, R7
	IT LT
	MOVLT R5, R7
Rest_ws_b3:
	CMP R2, R5
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b3
	CMP R3, R7
	ITTT EQ
	MOVWEQ R8, #:lower16:Rest_ws4+1
	MOVTEQ R8, #:upper16:Rest_ws4
	MOVEQ R3, R6
	B WS_Wait

Rest_ws4:
	SUB R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
Rest_ws_a4:
	CMP R2,R7
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a4
	SUB R2, R4, R3
	STR R0, [R1, R2]
Rest_ws_b4:
	CMP R2, R6
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b4
	CMP R3, #0x00
	ITTT EQ
	MOVWEQ R8, #:lower16:LowWait+1
	MOVTEQ R8, #:upper16:LowWait
	MOVEQ R3, R6
	B WS_Wait

LowWait:
	MOV R2, #0x200000
	BL Deep				//小延迟
	MOVT R0, #0x05
	MOV R2, #0x00
LowWait_a:
	STR R0, [R1, R2]
	ADD R2, R2, #0x04
	CMP R2, #0x0280
	BNE LowWait_a			//更新颜色
	MOVW R8, #:lower16:HighWait+1
	MOVT R8, #:upper16:HighWait
	B WS_Wait

HighWait:
	MOV R2, #0x02800000
	BL Deep				//大延迟
	MOVW R8, #:lower16:Rest_ws5+1
	MOVT R8, #:upper16:Rest_ws5
	MVN R3, #0x03
	
Rest_ws5:
	ADD R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
Rest_ws_a5:
	CMP R2, R6
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a5
	SUB R2, R4, R3
	STR R0, [R1, R2]
Rest_ws_b5:
	CMP R2, R7
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b5
	CMP R3, R6
	ITTT EQ
	MOVWEQ R8, #:lower16:Rest_ws6+1
	MOVTEQ R8, #:upper16:Rest_ws6
	MOVEQ R3, R6
	B WS_Wait

Rest_ws6:
	SUB R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
Rest_ws_a6:
	CMP R2, R7
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a6
	SUB R2, R4, R3
	STR R0, [R1, R2]
Rest_ws_b6:
	CMP R2, R6
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b6
	CMP R3, #0x00
	ITTTT EQ
	MOVWEQ R8, #:lower16:Rest_ws7+1
	MOVTEQ R8, #:upper16:Rest_ws7
	MOVEQ R3, #0x20
	MOVEQ R9, R3
	B WS_Wait
	
Rest_ws7:
	SUB R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
	SUB R5, R2, #0x1C
	CMP R5, #0x00
	IT LT
	MVNLT R5, #0x03
Rest_ws_a7:
	CMP R2, R5
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a7
	MOV R2, R9
Rest_ws_aa7:
	CMP R2, R6
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_aa7
	SUB R2, R4, R3
	STR R0, [R1, R2]
	ADD R5, R2, #0x1C
	CMP R5, #0x0280
	IT GT
	MOVGT R5, #0x0280
Rest_ws_b7:
	CMP R2, R5
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b7
	SUB R2, R4, R9
Rest_ws_bb7:
	CMP R2, R7
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_bb7
	CMP R3, #0x00
	ITT EQ
	ADDEQ R9, R9, #0x20
	MOVEQ R3, R9
	CMP R9, R6
	ITTT EQ
	MOVWEQ R8, #:lower16:Rest_ws8+1
	MOVTEQ R8, #:upper16:Rest_ws8
	MOVEQ R3, R6
	B WS_Wait
	
Rest_ws8:
	SUB R3, R3, #0x04
	BL Clean
	MOV R2, R3
	STR R0, [R1, R2]
	SUB R5, R2, #0x1C
	CMP R5, #0x00
	IT LT
	MVNLT R5, #0x03
Rest_ws_a8:
	CMP R2, R5
	ITTT NE
	SUBNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_a8
	SUB R2, R4, R3
	STR R0, [R1, R2]
	ADD R5, R2, #0x1C
	CMP R5, #0x0280
	IT GT
	MOVGT R5, #0x0280
Rest_ws_b8:
	CMP R2, R5
	ITTT NE
	ADDNE R2, R2, #0x04
	STRNE R0, [R1, R2]
	BNE Rest_ws_b8
	CMP R3, #0x00
	ITTT EQ
	MOVWEQ R8, #:lower16:Finish+1
	MOVTEQ R8, #:upper16:Finish
	MOVEQ R3, R6
	B WS_Wait

Finish:
	BL Clean			//清除数据区
	POP {R0, R14}			//恢复R0，R14
	MOV R8, LR			//移交R14至R8
	BL WS_Wait
	
//准备区
WS_Wait:
	PUSH {R0-R9}			//保存关键数据
	MOV R5, R1			//移交灯带颜色信息区地址
	MOVW R2, #0x0014
	MOVT R2, #0x4002		//GPIOA_ODR地址（注意，非GPIOA基址!!!）
	MOV R1, #0x01			//需要操作位（PA0对应1<0b1>，PA1对应2<0b10>，PA3对应4<0b100>，可配置多个以同时控制多灯带，请提前配置GPIO口，且必须是同一GPIO，GPIOA与B等不能同时控制）
	MOV R6, #0xA0			//灯带灯珠数量
	BL WS2812b			//跳转驱动程序
	POP {R0-R9}			//恢复关键数据
	BX R8				//跳转回流地址

//清除数据区
Clean:
	MOV R0, #0x00
	MOV R2, R0			//填充颜色0x00（纯黑），起始相对地址0x00
Clean_a:
	STR R0, [R1, R2]
	ADD R2, R2, #0x04
	CMP R2, #0x0280
	BNE Clean_a
	MOV R0, #0xFF00			//所需颜色（GRB）->纯红色
	BX LR

//延时程序
Deep:
	SUBS R2, R2, #0x01
	NOP
	BNE Deep
	BX LR

//End
//---------------------------------------------------------------------
