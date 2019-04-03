#include "basemacro.S"

.global memfill

#ifdef MEMCPY_ASM
.global memcpy
#endif //MEMCPY_ASM

.text

/* 
 * Copy data from source to destination address
 * Input:
 *			r0 - Destinatiation address
 *			r1 - The begining address of word of being copied field
 *			r2 - Count of bytes to copy
 * Return:	r0 - The destination address
 */
memcpy:

	stmdb sp!, {r3-r12}
	sub sp, sp, #0x4

	mov r4, #0x5
	mov r3, r2, lsr r4	@ Count of 32 bytes blocks

1: @ Copy by 32 bytes
	cmp r3, #0x0
	beq copyby4
	ldmia r1!, {r5-r12}
	stmia r0!, {r5-r12}
	sub r3, r3, #0x1
	b 1b

copyby4: @ Copy by 4 bytes
	and r2, r2, #0x1F	@ Elapsed count of bytes
	mov r4, #0x2
	mov r3, r2, lsr r4	@ Count of 4 bytes blocks

2:	@ Copy by 4 bytes loop
	cmp r3, #0x0 
	beq 3f
	ldr r5, [r1], #0x4
	str r5, [r0], #0x4
	sub r3, r3, #0x1
	b 2b

copyby1: @ Copy by 1 byte
	and r3, r2, #0x3	@ Elapsed count of bytes

3:	@ Copy by 1 byte loop
	cmp r3, #0x0
	beq 4f
	ldrb r5, [r1], #0x1
	strb r5, [r0], #0x1
	sub r3, r3, #0x1
	b 3b

4:
	sub r0, r1, r2		@ Return destination address

	add sp, sp, #0x4
	ldmia sp!, {r3-r12}
	mov pc, lr

/*
 * TODO Implement
 */
memfill:

	mov pc, lr
