.global setup_irq_vector, enable_irq, enable_timer_irq, disable_timer_irq

.text

/*
 * Enable one of IRQ source as ARM Timer Interrupt
 * Input:
 * Return:
 */
enable_timer_irq:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	@ Enable IRQ sourse in a Base Interrupt Enable Register
	ldr r0, =0x202B0218 @ BIER addr is 0x202B0000 + 0x218
	ldr r1, [r0]	@ Read a value of the BIER
	orr r1, #0x1	@ Enable ARM Timer IRQ (1 in 0s bit)
	str r1, [r0]	@ Store the value in the BIER

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Disable ARM Timer Interrupt as one of IRQ source
 * Input:
 * Return:
 */
disable_timer_irq:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	@ Disable IRQ sourse in a Base Interrupt Enable Register
    ldr r0, =0x202B0218 @ BIER addr is 0x202B0000 + 0x218
    ldr r1, [r0]		@ Read a value of the BIER
    and r1, #0xFFFFFFFE	@ Disable ARM Timer IRQ (1 in 0s bit)
    str r1, [r0]		@ Store the value in the BIER

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

    mov pc, lr

/*
 * Enable IRQ in CPSR register
 * Input:
 * Return:
 */
enable_irq:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

    mrs r0, cpsr	@ Read a value of state register
    orr r0, #0x80	@ Enable IRQ (1 in 7th bit)
    msr cpsr, r0	@ Store the value into the state register

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

    mov pc, lr

/*
 * TODO Description
 * Input:
 * Return:
 */
setup_irq_vector:

    mov r11, #0x00000000
    ldr r10, =ivt_start

	@	out ---> in
    ldm r10!, {r0-r7} @ r0 = r10[0]; ...; r7 = r10[7]; r10 = r10 + 8 * sizeof(rX)
    @	in <--- out
    stm r11!, {r0-r7} @ r11[0] = r0; ...; r11[7] = r7; r11 = r11 + 8 * sizeof(rX)

	@	out ---> in
    ldm r10, {r0-r7} @ r0 = r10[0]; ...; r7 = r10[7];
    @	in <--- out
    stm r11, {r0-r7} @ r11[0] = r0; ...; r11[7] = r7;
    mov pc, lr

/*
 * TODO Description
 * Input:
 * Return:
 */
err_handler:
    b .

/*
 * TODO Description
 * Input:
 * Return:
 */
irq_handler:

	@ bl gpio_16_sw

	subs pc, lr, #0x4

/*
 * TODO Description
 */
ivt_start:
.rept 6
    ldr pc, =err_handler
.endr
    ldr pc, =irq_handler
.rept 9
    ldr pc, =err_handler
.endr
