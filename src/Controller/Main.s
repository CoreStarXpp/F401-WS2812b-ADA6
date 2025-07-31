//=====================================================================
//��Ŀ��F401-WS2812b-ADA6
//�ļ���/src/Controller/Main.s
//SPDX��ʶ��SPDX-License-Identifier: LGPL-3.0-only
//��Ȩ���У�Copyright (C) 2025 ��˸
//		о��-X++�����Ŷӣ�https://gitee.com/CoreStarXpp��
//Э�飺�����ı���/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//��ʼ�����裬���ȴ�����������0xff010100
//*********************************************************************

//---------------------------------------------------------------------
//Start
//ƽ̨��STM32F401RCT6 HSI=16MHz
//	XY-MB035A 9600bps �������Զ�����
//��������arm-none-eabi

.syntax unified
.cpu cortex-m4				//ָ��Cortex-M4�ں�
.thumb					//ָ��Thumb�﷨
.global _start				//����ȫ��_start

.text

_start:

//����RCC
	MOVW R0, #0x3800
	MOVT R0, #0x4002		//RCC��ַ
	LDR R1, [R0, #0x30]		//��ȡRCC_AHB1ENR
	ORR R1, #0x01			//��0λ��GPIOAEN������GPIOA
	STR R1, [R0, #0x30]		//д��RCC_AHB1ENR
	LDR R1, [R0, #0x44]		//��ȡRCC_APB2ENR
	ORR R1, #0x10			//��4λ��USART1EN������USART1
	STR R1, [R0, #0x44]		//д��RCC_APB2ENR

//����GPIOA
	MOVW R0, #0x00
	MOVT R0, #0x4002		//GPIOA��ַ
	LDR R1, [R0]			//��ȡGPIOA_MODER
	ORR R1, #0x280000		//����PA9��PA10Ϊ���ù���
	STR R1, [R0]			//д��GPIOA_MODER
	LDR R1, [R0, #0x08]		//��ȡGPIOA_OSPEEDR
	ORR R1, #0x3C0000		//����PA9��PA10Ϊ������ģʽ
	STR R1, [R0, #0x08]		//д��GPIOA_OSPEEDR
	LDR R1, [R0, #0x24]		//��ȡGPIOA_AFRH
	ORR R1, #0x0770			//����PA9��PA10ΪAF7��USART��
	STR R1, [R0, #0x24]		//д��GPIOA_AFRH

//����USART1
	MOVW R0, #0x1000
	MOVT R0, #0x4001		//USART1��ַ
	MOV R1, #0x00			//���USART_CR1���ر�USART1��
	STR R1, [R0, #0x0C]		//д��USART_CR1
	MOV R1, #0x0683			//16MHz->9600bps
	STR R1, [R0, #0x08]		//д��USART_BRR
	MOV R1, #0x00			//�ٴ����USART_CR1���ر�USART��
	STR R1, [R0, #0x0C]		//д��USART_CR1
	MOV R1, #0x200C			//��λRE��TE��UE�����������ã����������ã�USART1���ã�
	STR R1, [R0, #0x0c]		//д��USART_CR1

//GPIOA��ַ
	MOVW R2, #0x00
	MOVT R2, #0x4002

//�ȴ�PA0�ߵ�ƽ
loop:
	LDR R1, [R2, #0x10]		//��ȡGPIOA_IDR
	TST R1, #0x01			//����0λ��PA0���ߵ�ƽ
	BEQ loop			//��ƥ��������ȴ�
loop0:
	LDR R1, [R2, #0x10]		//��ȡGPIOA_IDR
	TST R1, #0x01			//����0λ��PA0���͵�ƽ
	BNE loop0			//��ƥ��������ȴ�

//��������
WaitTXE0:
	LDR R1, [R0]			//��ȡUSART_SR
	TST R1, #0x80			//����TXEλΪ1��DR�Ĵ���Ϊ�գ�
	BEQ WaitTXE0			//��ƥ��������ȴ�
	MOV R1, #0xFF			//����0xFF
	STR R1, [R0, #0x04]		//д��USART_DR
WaitTC0:
	LDR R1, [R0]			//��ȡUSART_SR
	TST R1, #0x40			//����TCλΪ1�����ݷ�����ɣ�
	BEQ WaitTC0			//��ƥ��������ȴ�
WaitTXE1:
	LDR R1, [R0]
	TST R1, #0x80
	BEQ WaitTXE1
	MOV R1, #0x01			//����0x01
	STR R1, [R0, #0x04]
WaitTC1:
	LDR R1, [R0]
	TST R1, #0x40
	BEQ WaitTC1
WaitTXE2:
	LDR R1, [R0]
	TST R1, #0x80
	BEQ WaitTXE2
	MOV R1, #0x01			//����0x01
	STR R1, [R0, #0x04]
WaitTC2:
	LDR R1, [R0]
	TST R1, #0x40
	BEQ WaitTC2
WaitTXE3:
	LDR R1, [R0]
	TST R1, #0x80
	BEQ WaitTXE3
	MOV R1, #0x00			//����0x00
	STR R1, [R0, #0x04]
WaitTC3:
	LDR R1, [R0]
	TST R1, #0x40
	BEQ WaitTC3
	B loop				//��ѭ��

//End
//---------------------------------------------------------------------
