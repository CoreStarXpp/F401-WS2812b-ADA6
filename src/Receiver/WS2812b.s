//=====================================================================
//��Ŀ��F401-WS2812b-ADA6
//�ļ���/src/Controller/Main.s
//SPDX��ʶ��SPDX-License-Identifier: LGPL-3.0-only
//��Ȩ���У�Copyright (C) 2025 ��˸
//		о��-X++�����Ŷӣ�https://gitee.com/CoreStarXpp��
//Э�飺�����ı���/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//WS2812b��������
//*********************************************************************

//---------------------------------------------------------------------
//Start
//ƽ̨��STM32F401RCT6 PLL=84MHz
//��������arm-none-eabi

//WARN!!!����ɾȥ����������־��ָ����NOP������Ը�������

.syntax unified
.cpu cortex-m4				//ָ��Cortex-M4�ں�
.thumb					//ָ��Thumb�﷨
.global WS2812b				//����ȫ��WS2812b

.text

WS2812b:

//Ԥ׼��
	PUSH {R14}			//���淵�ص�ַ
	LDR R0, [R2]
	BIC R0, R0, R1
	STR R0, [R2]
	LDR R3, [R5], #0x04
	SUBS R6, R6, #0x01
	MOV R7, #0x012000		// ����Reset�ȴ����ڣ�ʵ������������=R7*5��Լ80us�����ƹ�Ч����Ҫ���˴�Ϊ4388us����ʵ��ȡֵ��û�м�������Ҫ����ȡ16λ�����8λ����
	
Start:
	MOV R4, #0x00800000
	TST R3, R4
	NOP
	BNE Core_1

// Core0 ��λ�ź� 0.35us�ߵ�ƽ+0.8us�͵�ƽ
Core_0:
	LDR R0, [R2]
	ORR R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x03			//ȡֵ������R0=����������-13��/5�����ȡ��
	BL WaitCore
	LDR R0, [R2]
	BIC R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x09			//ȡֵ������R0=����������-20��/5�����ȡ��
	BL WaitCore
	LSRS R4, R4, #0x01
	BEQ Exit
	TST R3, R4
	NOP
	BEQ Core_0

// Core1 ��λ�ź� 0.7us�ߵ�ƽ+0.6us�͵�ƽ
Core_1:
	LDR R0, [R2]
	ORR R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x09			//ȡֵ������R0=����������-13��/5�����ȡ��
	BL WaitCore
	LDR R0, [R2]
	BIC R0, R0, R1
	STR R0, [R2]
	MOV R0, #0x07			//ȡֵ������R0=����������-20��/5�����ȡ��
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
