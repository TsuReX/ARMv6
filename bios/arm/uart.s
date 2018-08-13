.text
.global setup_uart, uart_recv, uart_send
setup_uart:

	ldr r0, =0x20200000
    ldr r1, =0x24000
    ldr r2, [r0, #0x4]
	orr r2, r2, r1
	str	r2, [r0, #0x4] @ Enable function 0 for GPIO 14 and 15

	ldr r0, =0x20201000

	mov r1, #0x0
	str r1, [r0, #0x30] @ Turn off UART

	mov r1, #0x1
	str r1, [r0, #0x24] @ Integer divisor 1

	mov r1, #0x28
	str r1, [r0, #0x28] @ Fraction divisor 40

	mov r1, #0x70
	str r1, [r0, #0x2C] @ Setup FIFO enabled and 8bit data length

	ldr r1, =0x301
	str r1, [r0, #0x30] @ Turn on UART, Transmitter and Receiver

	mov pc, lr

uart_recv:
	ldr r1, =0x20200000

	1:
	ldr r0, [r1, #0x18]
	and r0, r0, #0x10
	bne 1b

	ldr r0, [r1]

	mov pc, lr

uart_send:
	ldr r1, =0x20200000

	str r0, [r1]

	1:
	ldr r0, [r1, #0x18]
	and r0, r0, #0x20
	bne 1b

	mov pc, lr
