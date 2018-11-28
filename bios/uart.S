#include "ports.S"

.global setup_uart, uart_recv, uart_send, uart_test

.text

/*	Configure UART controller and enable it
 *	Input:
 *	Return:
**/
setup_uart:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4
	str r2, [r13], #-0x4

	@ GPIO alt function 0(0b100) for 14 and 15 
	
	ldr r0, =GPIO_BASE		@ GPIO base address
	ldr r1, =((GPIO_ALT0 << 15) | (GPIO_ALT0 << 12))	@ GPIO_ALT0 mode for 14 and 15 pins
	
	ldr r2, [r0, #GPIO_GPFSEL1]	@ GPIO function select 1
	orr r2, r2, r1			@ Change state only for 14 and 15 GPIOs
	str r2, [r0, #GPIO_GPFSEL1]	@ Enable function 0 for GPIO 14 and 15
	
	@ Setup UART on 14(TX) and 15(RX) GPIOs
	
	ldr r0, =UART_BASE 		@

	mov r1, #0x0
	str r1, [r0, #UART_CR]		@ Disable UART

	mov r1, #0x1
	str r1, [r0, #UART_IBRD]	@ Integer divisor 1

	mov r1, #0x28
	str r1, [r0, #UART_FBRD]	@ Fraction divisor 40

	ldr r1, =0x7FF
	str r1, [r0, #UART_ICR]		@ Clear pending interrupts

	mov r1, #0x70			@ Set 1 into 4,5,6 bits
	str r1, [r0, #UART_LCRH]	@ Setup FIFO enabled and 8bit data length
	
	ldr r1, =0x7F2			@ Set 1 into 1,4-10 bits
	str r1, [r0, #UART_IMSC]	@ Mask all interrupts

	ldr r1, =0x301			@ Set 1 into 0,8,9 bits
	str r1, [r0, #UART_CR]		@ Enable UART, transmitter and receiver

	ldr r2, [r13, #0x4]!
	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

/*	Receive byte via UART
 *	Input:
 *	Return:	r0 - error code
 *		r1 - data
**/
uart_recv:

	str r2, [r13], #-0x4

	ldr r1, =UART_BASE		@ 
	mov r2, #0x64			@ 100 attempts to transfer data
	mov r0, #0x1			@ Set return ERROR (timeout)

	1:	@ Wait while recv FIFO is empty
	@ TODO What about little delay here????
	ldr r0, [r1, #UART_FR]		@ Read recv FIFO empty flag
	and r0, r0, #0x10		@ Extract flag (bit 5)
	cmp r0, #0x0			@ Check flag

	@ Data was received
	moveq r0, #0x0			@ Set return OK
	@ !!!!!!!!
	ldreq r1, [r1]			@ Load data from FIFO into r1
	beq 2f				@ Go to exit

	@ Data wasn't received
	sub r2, r2, #0x1		@ Decrement and check remaining receive attemts count
	bne 1b				@ Make one more attempt to transfer

	2:
	ldr r2, [r13, #0x4]!

	mov pc, lr

/*	Send byte via UART
 *	Input:	r0 - data (byte)
 *	Return:	r0 - error code
**/
uart_send:

	str r1, [r13], #-0x4
	str r2, [r13], #-0x4

	ldr r1, =UART_BASE		@ UART base address
	str r0, [r1]			@ Store data into FIFO from r0
	mov r2, #0x64			@ 100 attempts to transfer data

	1:	@ Wait while trans FIFO is full
	ldr r0, [r1, #0x18]		@ Read trans FIFO full flag
	@ TODO What about little delay here????
	and r0, r0, #0x20		@ Extract flag
	cmp r0, #0x0			@ Check flag

	@ Data was transfered
	moveq r0, #0x0			@ Set return OK
	beq 2f				@ Go to exit

	@ Data wasn't transfered
	sub r2, r2, #0x1		@ Decrement and check remaining transfer attemts count
	moveq r0, #0x1			@ Set return ERROR (timeout)
	bne 1b				@ Make one more attempt to transfer

	2:
	ldr r2, [r13, #0x4]!
	ldr r1, [r13, #0x4]!

	mov pc, lr

/*	Send word via UART
 *	Input:	r0 - data (word)
 *	Return:	r0 - error code
**/
uart_send4:

	str r1, [r13], #-0x4		@ UART_BASE address
	str r2, [r13], #-0x4		@ Counter of retries
	str r3, [r13], #-0x4		@ Counter of bytes to send
	str r4, [r13], #-0x4		@ Byte to send / FIFO flags

	ldr r1, =UART_BASE		@ UART base address
	mov r3, #0x4			@ Count of bytes to send

	1:	@ Send 4 bytes of word
	and r4, r0, #0xFF		@ Get just first byte
	str r4, [r1]			@ Store data into FIFO from r0
	mov r2, #0x64			@ 100 attempts to transfer data
	2:	@ Wait while trans FIFO is full
	ldr r4, [r1, #0x18]		@ Read trans FIFO full flag
	@ TODO What about little delay here????
	and r4, r4, #0x20		@ Extract flag
	cmp r4, #0x0			@ Check flag
	bne 3f				@ Goto data wasn't transfered

	@ Data was transfered
	sub r3, #0x1			@ Next iteration
	mov r0, r0, lsr #0x8		@ Get next byte
	cmp r3, #0x0
	@ All 4 bytes was sent
	moveq r0, #0x0			@ Set return OK
	beq 4f				@ Go to exit
	@ Not all bytes was sent
	bne 1b				@ Send next byte

	@ Data wasn't transfered
	3:
	sub r2, r2, #0x1		@ Decrement and check remaining transfer attemts count
	bne 2b				@ Make one more attempt to transfer
	mov r0, #0x1			@ Set return ERROR (timeout)

	4:
	ldr r4, [r13, #0x4]!
	ldr r3, [r13, #0x4]!
	ldr r2, [r13, #0x4]!
	ldr r1, [r13, #0x4]!

	mov pc, lr

/*
 * Send 0xDEADBEEF value via UART
 * Input:
 * Return:
 */
uart_test:

	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str lr, [sp], #-0x4
/*
	@ Read Secure Configurationa Register
	ldr r1, =0xABCDEF79

	@ Send [7:0]
	mov r0, r1
	bl uart_send
	cmp r0, #0x0
	bne 1f

	@ Send [15:8]
	mov r0, r1, lsr #0x8
	bl uart_send
	cmp r0, #0x0
	bne 1f

	@ Send [23:16]
	mov r0, r1, lsr #0x10
	bl uart_send
	cmp r0, #0x0
	bne 1f

	@ Send [31:24]
	mov r0, r1, lsr #0x18
	bl uart_send
	cmp r0, #0x0
	bne 1f
*/
	ldr r0, =0xABCDEF79
	bl uart_send4

	1: @ Error occured during transfer
	ldr lr, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!

	mov pc, lr
