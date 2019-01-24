#include "ports.S"

#include "printregs.h"

.global memcpy, memfill, memprint

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

/*
 * Transfer via UART specified amount of memory
 * starting from specified address to examine it
 * Input:	r0 - Starting address of memory
 *		r1 - Count of bytes to transfer
 * Output: TODO What result a function should return?
 */
memprint:

	save

	mov r2, #0x0	@ Compare count of bytes with zero
	cmp r1, r2
	beq 4f

	mov r4, r0	@ Save r0

	ldr r0, =MEMPRINT	@ Send type of transmission
	bl uart_send4

	mov r0, r1	@ Send count of bytes
	bl uart_send4

	mov r0, r4	@ Send start address
	bl uart_send4

	lsr r2, r1, #0x2	@ Evaluate count of batches of 4 bytes

	mov r3, #0x0

2:	@ Loop for sending batches of 4 bytes
	cmp r2, r3
	beq 3f

	ldr r0, [r4]!	@ Load 4 bytes from memory
	bl uart_send4	@ Send 4 bytes

	mov r0, #0x1
	sub r2, r0	@ Decrement count of batches

	b 2b

	mov r3, #0x2	@ Evaluate elapsed count of bytes
	and r2, r3

	mov r0, #0x0

	ldr r3, [r4]	@ Load elapsed bytes

3: @ Loop for sending elapsed bytes(0 - 3) by 1 byte
	cmp r2, r0
	beq 4f

	mov r1, #0xFF	@ Extract byte form register
	and r0, r3, r1
	bl uart_send	@ Send byte

	lsr r3, r3, #0x8	@ Shift register by 8 bits right

	mov r1, #0x1	@ Decrement count of elapsed bytes
	sub r2, r1

	b 3b

4:
	restore
	mov pc, lr

/*
 * TODO Implement
 */
memfill:

	mov pc, lr