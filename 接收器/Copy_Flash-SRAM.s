.syntax unified
.cpu cortex-m3
.thumb
.global _start

.text

.word 0x20010000
.word _start+1

_start:
	MOV R0, #0x08000000
	MOV R1, #0x20000000
	MOV R2, #0x100
	ADD R0, R0, R2
	MOV R2, #0x500
	ADD R2, R0, R2
CopyF2S:
	LDR R3, [R0], #4
	STR R3, [R1], #4
	CMP R0, R2
	BNE CopyF2S
	MOV LR, #0x20000000
	ADD LR,LR,#1
	BX LR
