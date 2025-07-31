.syntax unified						// ��׼ARM�﷨
.cpu cortex-m3						// ָ��Cortex-m3�ں�
.thumb							// Thumbģʽ
.global WS2812b						// ����ȫ�ֱ�����_start����ʼ

.text							// ����ο�ʼ

// �������
WS2812b:
// ���ݷ��ص�ַ
	push {r14}
	LDR R0, [R2]									// ��ȡGPIO_ODR
	BIC R0, R0, R1									// �˿���0
	STR R0, [R2]									// д��GPIO_ODR
	LDR R3, [R5], #4								// ��ȡRGBֵ
	SUBS R6, R6, #1									// ����ʣ�����
	MOV R7, #0x12000								// ����Reset�ȴ�����
	
// ѭ���������
Start:
	MOV R4, #0x00800000								// ѭ������λ
	TST R3, R4										// ���RGBֵ
	NOP												// �ȴ���־
	BNE Core_1										// RGBֵ=1��ת��=0�Թ�
// Core0 ��λ�ź� 0.35us�ߵ�ƽ+0.8us�͵�ƽ
Core_0:
	LDR R0, [R2]									// ��ȡGPIO_ODR�Ĵ���
	ORR R0, R0, R1									// ���Ŀ��λ
	STR R0, [R2]									// д��GPIO_ODR�Ĵ���
	MOV R0, #3										// ��ʱ����
	BL WaitCore										// ��ת����ʱ����
	LDR R0, [R2]									// ��ȡGPIO_ODR�Ĵ���
	BIC R0, R0, R1									// ���Ŀ��λ
	STR R0, [R2]									// д��GPIO_ODR�Ĵ���
	MOV R0, #9										// ��ʱ����
	BL WaitCore										// ��ת����ʱ����
	LSRS R4, R4, #1									// �л����λ
	BEQ Exit										// ������˳�
	TST R3, R4										// ���RGBֵ
	NOP												// �ȴ���־
	BEQ Core_0

// Core1 ��λ�ź� 0.7us�ߵ�ƽ+0.6us�͵�ƽ
Core_1:
	LDR R0, [R2]									// ��ȡGPIO_ODR�Ĵ���
	ORR R0, R0, R1									// ���Ŀ��λ
	STR R0, [R2]									// д��GPIO_ODR�Ĵ���
	MOV R0, #9										// ��ʱ����
	BL WaitCore										// ��ת����ʱ����
	LDR R0, [R2]									// ��ȡGPIO_ODR�Ĵ���
	BIC R0, R0, R1									// ���Ŀ��λ
	STR R0, [R2]									// д��GPIO_ODR�Ĵ���
	MOV R0, #7										// ��ʱ����
	BL WaitCore										// ��ת����ʱ����
	LSRS R4, R4, #1									// �л����λ
	BEQ Exit										// ������˳�
	TST R3, R4										// ���RGBֵ
	NOP												// �ȴ���־
	BEQ Core_0
	B Core_1

// һ��������ɴ������
Exit:
	CMP R6, #0										// ���ʣ���������
	NOP												// �ȴ���־λ
	BNE ColorUpdate_ws 								//��=0�����
	BL Deep1											//=0����ʱˢ��
	pop {r14}
	BX LR											// ����

// ��ɫ���³���
ColorUpdate_ws:
	LDR R3, [R5], #4								// ��ȡRGBֵ
	SUBS R6, R6, #1									// ����ʣ�����
	B Start											// ��ʼ��һ��ѭ��


// Reset��ʱ����
Deep1:
	SUBS R7, R7, #1									// �ݼ�
	NOP												// �ȴ���־
	BNE Deep1										// ��=0����ת
	BX LR											// ����

// Coreʱ�������
WaitCore:
	SUBS R0, R0, #1									// �ݼ�
	NOP												// �ȴ���־
	BNE WaitCore									// ��=0����ת
	BX LR											// ����
