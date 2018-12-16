#include "ports.S"

/* .include "ports.S"
 * This construction shouldn't be used.
 * ports.S is assebmler language source file which contains C preprocessor constructions,
 * the constructions are processed by C-preprocessor and pure assembler language source code file is generated,
 * but .include directive says to assembler to get NOT preprocessed file ports.S with C-preprocessor 
 * constructions what causes assembling error.
 * .include directive should be used for pure assebly language files only!
 */

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
	
	/*
	TODO MON_MODE isn't available in qemu. Check on a real board
	cps #MON_MODE
	ldr sp, = __mon_stack	@ Secure Monitor
	*/
	cps #SYS_MODE
	ldr sp, = __sys_stack	@ System
	
	@ The system now is in System mode - working mode

	
	@ Check UART manipulation functions
	bl uart_test

	@ Check GPIO manipulation functions
	@ bl gpio_test

	@ Setup exceptions vector to 0x0
	mov r0, #0x0
	bl place_exc_vector

	@ Check timer
	ldr r0, =print_scr
	bl setup_irq_handler
	bl enable_irq
	bl enable_timer_irq
	bl setup_timer
	ldr r0, =0xFFFF
	bl set_timer_value
	bl enable_timer

	@bl print_scr		@ TODO Check
	@bl setup_irq_vector	@ TODO Check
	@bl enable_irq		@ TODO Check
	@bl enable_timer_irq	@ TODO Check
	@bl enable_timer	@ TODO Check

	b .
	/* !!!!!!!!!!!!  */
	b stub_func /* Important to be confident that project can be built with .S and .c files */

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
