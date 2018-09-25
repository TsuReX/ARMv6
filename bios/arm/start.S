.include "ports.S"

.global entry

.text

/*
 * Entry point
 */
entry:

	@ The system is now in Supervisor mode
	
	@ Setup stacks pointer for all Operating modes
	@cps #SVC_MODE		@ Its unnecessary operation
	ldr sp, = __svc_stack	@ Supervisor
	cps #FIQ_MODE		@ Change processor state
	ldr sp, = __fiq_stack	@ FIQ
	cps #IRQ_MODE
	ldr sp, = __irq_stack	@ IRQ
	cps #ABT_MODE
	ldr sp, = __abt_stack	@ Abort
	cps #UND_MODE
	ldr sp, = __und_stack	@ Undefined
	cps #MON_MODE
	ldr sp, = __mon_stack	@ Secure Monitor
	cps #SYS_MODE
	ldr sp, = __sys_stack	@ System
	
	@ The system now is in System mode - working mode

	@ TODO Check GPIO manipulation functions
	@ Set GPIO mode
	mov r0, #GPIO_1		@ Specify GPIO number
	mov r1, #GPIO_IN	@ Specify GPIO mode
	bl set_gpio_mode	@ Set mode to GPIO

	@ Set GPIO value
	mov r0, #GPIO_1		@ Specify GPIO number
	mov r1, #0x1		@ Specify GPIO value
	bl set_gpio_val		@ Set value to GPIO
	
	@ TODO Check UART manipulation functions


	bl print_scr		@ TODO Check
	bl setup_gpio		@ TODO Remove
	bl setup_irq_vector	@ TODO Check
	bl enable_irq		@ TODO Check
	@bl enable_timer_irq	@ TODO Check
	@bl enable_timer	@ TODO Check

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

