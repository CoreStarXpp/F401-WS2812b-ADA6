.syntax unified
.cpu cortex-m3
.thumb
.global _start

.text

_start:

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
	orr r1,#0x4
	orr r1,#0x280000
	str r1,[r0]
	ldr r1,[r0,#0x8]
	orr r1,#0xc
	orr r1,#0x3C0000
	str r1,[r0,#0x8]
	ldr r1,[r0,#0x24]
	orr r1,#0x770
	str r1,[r0,#0x24]

	MOVW R0,#0x1000
	MOVT R0,#0x4001
	mov R1,#0
	str r1,[r0,#0xc]
	mov r1,#0x683
	str r1,[r0,#0x8]
	mov r1,#0
	str r1,[r0,#0xc]
	mov r1,#0x200c
	str r1,[r0,#0xc]
	movw r2,#0x0
	movt r2,#0x4002
loop:
	ldr r1,[r2,#0x10]
	tst r1,#0x1
	beq loop
loop0:
	ldr r1,[r2,#0x10]
	tst r1,#0x1
	bne loop0
WaitTXE0:
	ldr r1,[r0]
	ands r1,#0x80
	beq WaitTXE0
	mov r1,#0xff
	str r1,[r0,#0x4]
WaitTC0:
	ldr r1,[r0]
	ands r1,#0x40
	beq WaitTC0
WaitTXE1:
	ldr r1,[r0]
	ands r1,#0x80
	beq WaitTXE1
	mov r1,#0x01
	str r1,[r0,#0x4]
WaitTC1:
	ldr r1,[r0]
	ands r1,#0x40
	beq WaitTC1
WaitTXE2:
	ldr r1,[r0]
	ands r1,#0x80
	beq WaitTXE2
	mov r1,#0x01
	str r1,[r0,#0x4]
WaitTC2:
	ldr r1,[r0]
	ands r1,#0x40
	beq WaitTC2
WaitTXE3:
	ldr r1,[r0]
	ands r1,#0x80
	beq WaitTXE3
	mov r1,#0x00
	str r1,[r0,#0x4]
WaitTC3:
	ldr r1,[r0]
	ands r1,#0x40
	beq WaitTC3
	b loop 

