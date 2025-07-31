.syntax unified
.cpu cortex-m3
.thumb
.global _start

.text

_start:
	MOVW R0, #0x3C00
	MOVT R0, #0x4002
	MOV R1, #0x3
	STR R1, [R0]

	MOVW R0, #0x3800
	MOVT R0, #0x4002
	LDR R1, [R0]
	ORR R1, R1, #0x10000
	STR R1, [R0]

WaitHSIReady:
	LDR R1, [R0]
	TST R1, #0x20000
	BEQ WaitHSIReady

	LDR R1, [R0, #0x04]
	MOVW R3, #0x7FFF
	MOVT R3, #0x3
	BIC R1, R1, R3
	ORR R1, R1, #0x19
	ORR R1, R1, #0x5400
	ORR R1, R1, #0x410000
	STR R1, [R0, #0x04]

	LDR R1, [R0]
	ORR R1, #0x1000000
	STR R1, [R0]

WaitPLLReady:
	LDR R1, [R0]
	TST R1, #0x2000000
	BEQ WaitPLLReady

	LDR R1, [R0, #0x08]
	MOVW R3, #0xFCF3
	MOVT R3, #0x1F
	BIC R1, R3
	MOVW R3, #0x1002
	MOVT R3, #0x19
	ORR R1, R3
	STR R1, [R0, #0x08]

WaitSwitch:
	LDR R1 ,[R0 ,#0x08]
	AND R1 ,#0x0C
	CMP R1 ,#0x08
	BNE WaitSwitch

	MOVW r0,#0x3800
	MOVT r0,#0x4002
	ldr r1,[r0,#0x30]
	orr r1,#0x1
	str r1,[r0,#0x30]
	ldr r1,[r0,#0x44]
	orr r1,#0x10
	str r1,[r0,#0x44]

	MOVW r0,#0x0
	MOVT r0,#0x4002
	ldr r1,[r0]
	orr r1,#0x5
	orr r1,#0x280000
	str r1,[r0]
	ldr r1,[r0,#0x8]
	orr r1,#0xF
	orr r1,#0x3C0000
	str r1,[r0,#0x8]

	ldr r1,[r0,#0x24]
	orr r1,#0x770
	str r1,[r0,#0x24]

	MOVW R0,#0x1000
	MOVT R0,#0x4001
	mov R1,#0
	str r1,[r0,#0xc]
	mov r1,#0x219c
	str r1,[r0,#0x8]
	mov r1,#0
	str r1,[r0,#0xc]
	mov r1,#0x200c
	str r1,[r0,#0xc]
loop:
	ldr r1,[r0]
	ands r1,#0x20
	beq loop
	ldr r1,[r0,#0x4]
	cmp r1,#0xff
	bne loop
loop0:
	ldr r1,[r0]
	ands r1,#0x20
	beq loop0
	ldr r1,[r0,#0x4]
	cmp r1,#0x01
	bne loop
loop1:
	ldr r1,[r0]
	ands r1,#0x20
	beq loop1
	ldr r1,[r0,#0x4]
	cmp r1,#0x01
	bne loop
loop2:
	ldr r1,[r0]
	ands r1,#0x20
	beq loop2
	ldr r1,[r0,#0x4]
	cmp r1,#0
	bne loop
	bl ADA6
	b loop
