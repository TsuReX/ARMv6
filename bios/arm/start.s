.global entry
.text
/*
 * Entry point
 */
entry:

    // System is now in Svc mode
    
    // Setup Sys mode
    @	<---

	@ TODO Use CPS instruction to change mode
	mrs r0, cpsr
    and r0, #0xFFFFFFE0
    orr r0, #0x1F    
    @	--->
    msr cpsr, r0
    
    @ TODO Check GPIO manipulation functions
    @ TODO Check UART manipulation functions

    bl setup_stack

    bl print_scr		@ TODO Check
    bl setup_gpio		@ TODO Remove
    bl setup_irq_vector	@ TODO Check
    bl enable_irq		@ TODO Check
    @bl enable_timer_irq	@ TODO Check
    @bl enable_timer		@ TODO Check

    bl blink_led
    
    b .

//******************************************************************//


/*
 * Print Secure Configurationa Register
 * Input:
 * Return:
 */
print_scr:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	@ Read Secure Configurationa Register
    mcr p15, 0, r1, c1, c1, 0

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
	mov r0, r1, lsr #0x8
	bl uart_send
	cmp r0, #0x0
	bne 1f

	@ Send [31:24]
	mov r0, r1, lsr #0x8
	bl uart_send
	cmp r0, #0x0
	bne 1f

	1: @ Error occured during transfer
	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

    mov pc, lr

/*
 * TODO
 * Input:
 * Return:
 */
setup_gpio:
    ldr r0, =0x20200000
    ldr r1, =0x40000
    str r1, [r0, #0x4]
    ldr r1, =0x9000
    str r1, [r0, #0x8]
    mov pc, lr

/*
 * TODO
 * Input:
 * Return:
 */
setup_stack:

    mrs r0, cpsr
    and r0, #0xFFFFFFE0

	@ TODO Setup stacks for all modes
    // Setup IRQ mode
    add r1, r0, #0x12
    msr cpsr, r1
    ldr sp, =__irq_stack
    
    // Setup Sys mode
    add r1, r0, #0x1F
    msr cpsr, r1
    ldr sp, =__usr_stack

    mov pc, lr

/*
 * TODO
 * Input:
 * Return:
 */
enable_timer:
	@	in <--- out
    ldr r0, =0x202B0400
    @	in <--- out
    ldr r1, =0xF4240
    @	out ---> in
    str r1, [r0]	@ Load 1.000.000 into the counter register
    ldr r0, =0x202B0408
    ldr r1, [r0]
    mov r2, #0xA2
    orr r1, r2
    @	out ---> in
    str r1, [r0]	@ Set Timer enable, Timer interrupt enable, 23-bit counter set
    mov pc, lr

