//=====================================================================
//��Ŀ��F401-WS2812b-ADA6
//�ļ���/src/Controller/Main.s
//SPDX��ʶ��SPDX-License-Identifier: LGPL-3.0-only
//��Ȩ���У�Copyright (C) 2025 ��˸
//		о��-X++�����Ŷӣ�https://gitee.com/CoreStarXpp��
//Э�飺�����ı���/LICENSES/lgpl-3.0.txt
//=====================================================================

//*********************************************************************
//��ʼ�����裬���ȴ�����0xff010100�������ƴ�
//*********************************************************************

//---------------------------------------------------------------------
//Start
//ƽ̨��STM32F401RCT6 HSI=16MHz HSE=25Mhz PLL=84MHz
//	XY-MB035A 9600bps �������Զ�����
//	WS2812b 5V 160��
//��������arm-none-eabi
//ʹ�üĴ�����R0��R1��R2

.syntax unified
.cpu cortex-m4				// ָ��Cortex-M4�ں�
.thumb					// ָ��Thumb�﷨
.global _start				// ����ȫ��_start

.text

_start:

//����Flash�ȴ�����Ϊ3
	MOVW R0, #0x3C00
	MOVT R0, #0x4002		// Flash interface register��ַ
	MOV R1, #0x3			// �����ȴ�����
	STR R1, [R0]			// д��Flash_ACR

//����RCC
	MOVW R0, #0x3800
	MOVT R0, #0x4002		//RCC��ַ
	LDR R1, [R0]			//��ȡRCC_CR
	ORR R1, R1, #0x10000		//��λHSE ONλ������HSE
	STR R1, [R0]			//д��RCC_CR

WaitHSEReady:				//�ȴ�HSE����
	LDR R1, [R0]			//��ȡRCC_CR
	TST R1, #0x20000		//����HSERDYλ
	BEQ WaitHSEReady		//��ƥ��������ȴ�

	LDR R1, [R0, #0x04]		//��ȡRCC_PLLCFGR
	MOVW R2, #0x7FFF
	MOVT R2, #0x3			//PLLM��PLLN��PLLP
	BIC R1, R1, R2			//���PLLM��PLLN��PLLP
	ORR R1, R1, #0x19
	ORR R1, R1, #0x5400
	ORR R1, R1, #0x410000		//PLLM=25��PLLN=336��PLLP=1����Ӧ4��|PLL=HSE*��PLLN/PLLM��/PLLP=25*��336/25��/4=84MHz
	STR R1, [R0, #0x04]		//д��RCC_PLLCFGR
	LDR R1, [R0]			//��ȡRCC_CR
	ORR R1, #0x1000000		//��λPLLON������PLL
	STR R1, [R0]			//д��RCC_CR

WaitPLLReady:				//�ȴ�PLL�ȶ�
	LDR R1, [R0]			//��ȡRCC_CR
	TST R1, #0x2000000		//����PLLRDYλ
	BEQ WaitPLLReady		//��ƥ��������ȴ�

	LDR R1, [R0, #0x08]		//��ȡRCC_CFGR
	MOVW R2, #0xFCF3
	MOVT R2, #0x1F			//SW��HPRE��PPRE1��PPRE2��RTCPRE
	BIC R1, R2			//���SW��HPRE��PPRE1��PPRE2��RTCPRE
	MOVW R2, #0x1002
	MOVT R2, #0x19			//SW=0b10��PLLʱ�ӣ���HPRE=0��AHB=84MHz����PPRE1=0b100��APB1=42MHZ Max����PPRE2=0��APB2=84MHz����RTCPRE=0b11001��RTC=HSE/25=1MHz ���룩
	ORR R1, R2			//ͬ��
	STR R1, [R0, #0x08]		//д��RCC_CFGR

WaitSwitch:				//�ȴ��л����
	LDR R1 ,[R0 ,#0x08]		//��ȡRCC_CFGR
	AND R1 ,#0x0C			//��ȡ2��3λ
	CMP R1 ,#0x08			//���SWS��0b10
	BNE WaitSwitch			//��ƥ��������ȴ�


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
	ORR R1, #0x01			//����PA0Ϊ�������
	ORR R1, #0x280000		//����PA9��PA10Ϊ���ù���
	STR R1, [R0]			//д��GPIOA_MODER
	LDR R1, [R0, #0x08]		//��ȡGPIOA_OSPEEDR
	ORR R1, #0x03			//����PA0Ϊ������ģʽ
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
	MOV R1 ,#0x219C			//84MHz->9600bps
	STR R1, [R0, #0x08]		//д��USART_BRR
	MOV R1, #0x00			//�ٴ����USART_CR1���ر�USART��
	STR R1, [R0, #0x0C]		//д��USART_CR1
	MOV R1, #0x200C			//��λRE��TE��UE�����������ã����������ã�USART1���ã�
	STR R1, [R0, #0x0c]		//д��USART_CR1

//�ȴ���������
loop:
	LDR R1, [R0]			//��ȡUSART_SR
	ANDS R1, #0x20			//����RXNEλ���������ݱ�ʶ��
	BEQ loop			//��ƥ��������ȴ�
	LDR R1, [R0, #0x04]		//��ȡUSART_DR
	CMP R1, #0xFF			//���������Ƿ���0xFF
	BNE loop			//��ƥ�������µȴ�

loop0:
	LDR R1, [R0]
	ANDS R1, #0x20
	BEQ loop0
	LDR R1, [R0, #0x04]
	CMP R1, #0x01			//���������Ƿ���0x01
	BNE loop

loop1:
	LDR R1, [R0]
	ANDS R1, #0x20
	BEQ loop1
	LDR R1, [R0, #0x04]
	CMP R1, #0x01			//���������Ƿ���0x01
	BNE loop

loop2:
	LDR R1, [R0]
	ANDS R1, #0x20
	BEQ loop2
	LDR R1, [R0, #0x04]
	CMP R1, #0x00			//���������Ƿ���0x00
	BNE loop

	BL ADA6				//���õƹ���Ƴ���
	B loop				//��ɺ����µȴ�

//WARN!!! �������ݲ�ƥ���һ��Ҫ������ѭ����������������0xFF8701888401CD00Ҳ�ᴥ��!!!

//End
//---------------------------------------------------------------------
