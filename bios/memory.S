#include "ports.S"

.text

/* 
 * Copy data from source to destination address
 * Input:	r0 - The begining address of word of being copied field
 *		r1 - Destinatiation address
 *		r2 - Count of bytes to copy
 * Return:	r0 - The destination address
 */
memcpy:

	stmia sp!, {r3-r12}

	mov r4, #0x1F
	mov r3, r2, lsr r4
1:
	mov r4, #0x0
	cmp r3, r4
	beq 2f
	ldmia r0!, {r5-r12}
	stmia r1!, {r5-r12}
	mov r4, #0x1
	sub r3, r3, r4
	b 1b
	mov r4, #0x1F
	mov r3, r2, r4
2:
	mov r4, #0x0
	cmp r3, r4
	beq 3f
	ldr r5, [r0], #0x4
	str r5, [r0], #0x4
	mov r4, #0x1
	sub r3, r3, r4
	b 2b
3: 
	mov r0, r2

	ldmdb sp!, {r3-r12}
	mov pc, lr
