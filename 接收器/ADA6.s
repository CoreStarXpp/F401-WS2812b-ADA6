.syntax unified
.cpu cortex-m3
.thumb
.global ADA6

.text

ADA6:
	push {r0,r14}
    movw r1,#0x2000
	movt r1,#0x2000
	mov r4,#0x27c
	mov r6,#0x140
	mov r7,#0x13c
	movw r8,#:lower16:Rest_ws0+1
	movt r8,#:upper16:Rest_ws0
	mov r3,#0x140
Rest_ws0:
	sub r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
ADDEEE0:
	cmp r2,r7
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE0
	sub r2,r4,r3
	str r0,[r1,r2]
SUBEEE0:
	cmp r2,r6
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE0
	cmp r3,#0
	ittt eq
	movweq r8,#:lower16:Rest_ws1+1
	movteq r8,#:upper16:Rest_ws1
	moveq r3,r6
	b WSEEE
	
Rest_ws1:
	sub r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
ADDEEE1:
	cmn r2,#4
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE1
	sub r2,r4,r3
	str r0,[r1,r2]
SUBEEE1:
	cmp r2,#0x280
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE1
	cmp r3,#0
	ittt eq
	movweq r8,#:lower16:Rest_ws2+1
	movteq r8,#:upper16:Rest_ws2
	moveq r3,r6
	b WSEEE

Rest_ws2:
	sub r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
	add R5,R2,#28
	cmp R5,r6
	it gt
	movgt r5,r6
ADDEEE2:
	cmp r2,r5
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE2
	sub r2,r4,r3
	str r0,[r1,r2]
	sub R5,R2,#28
	cmp R5,r7
	it lt
	movlt r5,r7
SUBEEE2:
	cmp r2,r5
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE2
	cmp r3,#0
	ittt eq
	movweq r8,#:lower16:Rest_ws3+1
	movteq r8,#:upper16:Rest_ws3
	mvneq r3,#0x3
	b WSEEE

Rest_ws3:
	add r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
	add R5,R2,#28
	cmp R5,r6
	it gt
	movgt r5,r6
ADDEEE3:
	cmp r2,r5
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE3
	sub r2,r4,r3
	str r0,[r1,r2]
	sub R5,R2,#28
	cmp R5,r7
	it lt
	movlt r5,r7
SUBEEE3:
	cmp r2,r5
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE3
	cmp r3,r7
	ittt eq
	movweq r8,#:lower16:Rest_ws4+1
	movteq r8,#:upper16:Rest_ws4
	moveq r3,r6
	b WSEEE

Rest_ws4:
	sub r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
ADDEEE4:
	cmp r2,r7
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE4
	sub r2,r4,r3
	str r0,[r1,r2]
SUBEEE4:
	cmp r2,r6
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE4
	cmp r3,#0
	ittt eq
	movweq r8,#:lower16:Over+1
	movteq r8,#:upper16:Over
	moveq r3,r6
	b WSEEE

Over:
	mov R2,#0x200000
	bl Deep
	movt R0,#0x5
	mov R2,#0
Over_a:
	str r0,[r1,r2]
	add r2,r2,#4
	cmp r2,#0x280
	bne Over_a
	movw r8,#:lower16:Next+1
	movt r8,#:upper16:Next
	b WSEEE

Next:
	mov r2,#0x2800000
	bl Deep
	movw r8,#:lower16:Rest_ws5+1
	movt r8,#:upper16:Rest_ws5
	mvn R3,#3
	
Rest_ws5:
	add r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
ADDEEE5:
	cmp r2,r6
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE5
	sub r2,r4,r3
	str r0,[r1,r2]
SUBEEE5:
	cmp r2,r7
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE5
	cmp r3,r6
	ittt eq
	movweq r8,#:lower16:Rest_ws6+1
	movteq r8,#:upper16:Rest_ws6
	moveq r3,r6
	b WSEEE

Rest_ws6:
	sub r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
ADDEEE6:
	cmp r2,r7
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE6
	sub r2,r4,r3
	str r0,[r1,r2]
SUBEEE6:
	cmp r2,r6
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE6
	cmp r3,#0
	itttt eq
	movweq r8,#:lower16:Rest_ws7+1
	movteq r8,#:upper16:Rest_ws7
	moveq r3,#0x20
	moveq R9,R3
	b WSEEE
	
Rest_ws7:
	sub r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
	sub R5,R2,#28
	cmp r5,#0
	it lt
	mvnlt r5,#3
ADDEEE7:
	cmp r2,r5
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE7
	mov R2,R9
ADDAAA:
	cmp R2,r6
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDAAA
	
	sub r2,r4,r3
	str r0,[r1,r2]
	add R5,R2,#28
	cmp R5,#0x280
	it gt
	movgt r5,#0x280
SUBEEE7:
	cmp r2,r5
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE7
	sub R2,R4,R9
SUBAAA:
	cmp R2,r7
	ittt ne
	subne R2,r2,#4
	strne R0,[r1,r2]
	bne SUBAAA
	
	cmp r3,#0
	itt eq
	addeq R9,R9,#0x20
	moveq r3,r9
	cmp R9,r6
	ittt eq
	movweq r8,#:lower16:Rest_ws8+1
	movteq r8,#:upper16:Rest_ws8
	moveq R3,r6
	b WSEEE
	
Rest_ws8:
	sub r3,r3,#4
	bl Clean
	mov r2,r3
	str r0,[r1,r2]
	sub R5,R2,#28
	cmp R5,#0
	it lt
	mvnlt r5,#3
ADDEEE8:
	cmp r2,r5
	ittt ne
	subne r2,r2,#4
	strne r0,[r1,r2]
	bne ADDEEE8
	
	sub r2,r4,r3
	str r0,[r1,r2]
	add R5,R2,#28
	cmp R5,#0x280
	it gt
	movgt r5,#0x280
SUBEEE8:
	cmp r2,r5
	ittt ne
	addne r2,r2,#4
	strne r0,[r1,r2]
	bne SUBEEE8
	
	cmp r3,#0
	ittt eq
	movweq r8,#:lower16:WSEEE_0+1
	movteq r8,#:upper16:WSEEE_0
	moveq R3,r6
	b WSEEE

WSEEE_0:
	bl Clean
	pop {r0,r14}
	mov r8,lr
	bl WSEEE
	

WSEEE:
	push {R0-R9}
	MOV R5, R1
	MOVW R2, #0x0014
	MOVT R2, #0x4002
	MOV R1, #0x1
	MOV R6, #0xa0
	BL WS2812b
	pop {R0-R9}
	bx R8

Clean:
	mov R0,#0
	mov R2,R0
Clean_a:
	str r0,[r1,r2]
	add r2,r2,#4
	cmp r2,#0x280
	bne Clean_a
	mov r0,#0xff00
	bx lr
Deep:
	SUBS R2, R2, #1									// 递减
	NOP												// 等待标志
	BNE Deep										// ！=0则跳转
	BX LR											

