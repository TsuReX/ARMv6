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

	stmdb sp!, {r3-r12}
	sub sp, sp, #0x4

	mov r4, #0x5
	mov r3, r2, lsr r4	@ Count of 32 bytes blocks

1: @ Copy by 32 bytes
	cmp r3, #0x0
	beq 2f
	ldmia r0!, {r5-r12}
	stmia r1!, {r5-r12}
	sub r3, r3, #0x1
	b 1b

	and r2, r2, #0x1F	@ Elapsed count of bytes
	mov r4, #0x2
	mov r3, r2, lsr r4	@ Count of 4 bytes blocks

2: @ Copy by 4 bytes
	cmp r3, #0x0 
	beq 3f
	ldr r5, [r0], #0x4
	str r5, [r0], #0x4
	sub r3, r3, #0x1
	b 2b

	and r3, r2, #0x3	@ Elapsed count of bytes

3: @ Copy by 1 byte
	cmp r3, #0x0
	beq 4f
	ldrb r5, [r0], #0x1
	strb r5, [r0], #0x1
	sub r3, r3, #0x1
	b 3b

4:
	sub r0, r1, r2		@ Return destination address

	add sp, sp, #0x4
	ldmia sp!, {r3-r12}
	mov pc, lr
