.text
.global setup_uart, uart_recv, uart_send
setup_uart:
	@ GPIO alt function 0(0b100) for 14 and 15 
	
	ldr r0, =0x20200000 	@ GPIO base address
	ldr r1, =0x24000 	@ GPIO alt function 0(0b100) for 14 and 15 
	
	ldr r2, [r0, #0x4] 	@ GPIO function select 1
	orr r2, r2, r1 		@ Change state only for 14 and 15 GPIOs
	str r2, [r0, #0x4] 	@ Enable function 0 for GPIO 14 and 15
	
	
	@ Setup UART on 14(TX) and 15(RX) GPIOs
	
	ldr r0, =0x20201000 	@UART base address

	mov r1, #0x0
	str r1, [r0, #0x30] 	@ Disable UART

	mov r1, #0x1
	str r1, [r0, #0x24] 	@ Integer divisor 1

	mov r1, #0x28
	str r1, [r0, #0x28] 	@ Fraction divisor 40

	ldr r1, =0x7FF
	str r1, [r0, #0x44] 	@ Clear pending interrupts

	mov r1, #0x70 		@ Set 1 into 4,5,6 bits
	str r1, [r0, #0x2C] 	@ Setup FIFO enabled and 8bit data length
	
	ldr r1, =0x7F2 		@ Set 1 into 1,4-10 bits
	str r1, [r0, #0x38] 	@ Mask all interrupts

	ldr r1, =0x301 		@ Set 1 into 0,8,9 bits
	str r1, [r0, #0x30] 	@ Enable UART, transmitter and receiver

	mov pc, lr

uart_recv:
	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	ldr r1, =0x20200000

	1:			@ Wait while recv FIFO is empty
	ldr r0, [r1, #0x18]	@ Read recv FIFO empty flag
	and r0, r0, #0x10	@ Check flag
	bne 1b

	ldr r0, [r1]		@ Load data from FIFO into r0

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

uart_send:
	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	ldr r1, =0x20200000

	str r0, [r1]		@ Store data into FIFO from r0

	1:			@ Wait while recv FIFO is empty
	ldr r0, [r1, #0x18]	@ Read trans FIFO full flag
	and r0, r0, #0x20	@ Check flag
	bne 1b

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr
