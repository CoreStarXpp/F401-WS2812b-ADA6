//=====================================================================
//��Ŀ��F401-WS2812b-ADA6
//�ļ���/src/Controller/ADA6.s
//SPDX��ʶ��SPDX-License-Identifier: LGPL-3.0-only
//��Ȩ���У�Copyright (C) 2025 ��˸
//		о��-X++�����Ŷӣ�https://gitee.com/CoreStarXpp��
//Э�飺�����ı���/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//�ƹ�Ч������
//*********************************************************************

//---------------------------------------------------------------------
//Start
//ƽ̨��STM32F401RCT6 PLL=84MHz
//��������arm-none-eabi

.syntax unified
.cpu cortex-m4				//ָ��Cortex-M4�ں�
.thumb					//ָ��Thumb�﷨
.global ADA6				//����ȫ��ADA6

.text

ADA6:
//Ԥ׼��
	PUSH {R0, R14}			//����R0��USART1��ַ����R14��RL���ص�ַ��
	MOVW R1, #0x2000
	MOVT R1, #0x2000			//�ƴ���ɫ��Ϣ����������޸ģ�
	MOV R4, #0x027C			//��Ƶ�������ݣ����������
	MOV R6, #0x0140			//��Ƶ�������ݣ����������
	MOV R7, #0x013C			//��Ƶ�������ݣ����������
	MOVW R8, #:lower16:Rest_ws0+1
	MOVT R8, #:upper16:Rest_ws0	//������ַ
	MOV R3, #0x0140			//��̬����ַ����Ӧ�����*4��

//����ע��Ҫ���֣������߼����������

Rest_ws0:
	SUB R3, R3, #0x04			//��̬������ַҪ����ɫ������ַ�󣨻�С��4�������һ��λ���ӹ�������ָ������ѭ��ĩβ�����һ��λ���ӹ�
	BL Clean			//����ȴ���ɫ��Ϣ�����
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
	MOVTEQ R8, #:upper16:Rest_ws1	//���»�����ַ
	MOVEQ R3, R6			//���¶�̬����ַ
	B WS_Wait				//��ת׼����

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
	BL Deep				//С�ӳ�
	MOVT R0, #0x05
	MOV R2, #0x00
LowWait_a:
	STR R0, [R1, R2]
	ADD R2, R2, #0x04
	CMP R2, #0x0280
	BNE LowWait_a			//������ɫ
	MOVW R8, #:lower16:HighWait+1
	MOVT R8, #:upper16:HighWait
	B WS_Wait

HighWait:
	MOV R2, #0x02800000
	BL Deep				//���ӳ�
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
	BL Clean			//���������
	POP {R0, R14}			//�ָ�R0��R14
	MOV R8, LR			//�ƽ�R14��R8
	BL WS_Wait
	
//׼����
WS_Wait:
	PUSH {R0-R9}			//����ؼ�����
	MOV R5, R1			//�ƽ��ƴ���ɫ��Ϣ����ַ
	MOVW R2, #0x0014
	MOVT R2, #0x4002		//GPIOA_ODR��ַ��ע�⣬��GPIOA��ַ!!!��
	MOV R1, #0x01			//��Ҫ����λ��PA0��Ӧ1<0b1>��PA1��Ӧ2<0b10>��PA3��Ӧ4<0b100>�������ö����ͬʱ���ƶ�ƴ�������ǰ����GPIO�ڣ��ұ�����ͬһGPIO��GPIOA��B�Ȳ���ͬʱ���ƣ�
	MOV R6, #0xA0			//�ƴ���������
	BL WS2812b			//��ת��������
	POP {R0-R9}			//�ָ��ؼ�����
	BX R8				//��ת������ַ

//���������
Clean:
	MOV R0, #0x00
	MOV R2, R0			//�����ɫ0x00�����ڣ�����ʼ��Ե�ַ0x00
Clean_a:
	STR R0, [R1, R2]
	ADD R2, R2, #0x04
	CMP R2, #0x0280
	BNE Clean_a
	MOV R0, #0xFF00			//������ɫ��GRB��->����ɫ
	BX LR

//��ʱ����
Deep:
	SUBS R2, R2, #0x01
	NOP
	BNE Deep
	BX LR

//End
//---------------------------------------------------------------------
