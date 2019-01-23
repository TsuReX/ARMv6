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

.macro setup_stacks
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
#ifdef RASPBERRY_PI1
	cps #MON_MODE
	ldr sp, = __mon_stack	@ Secure Monitor
#endif
	cps #SYS_MODE
	ldr sp, = __sys_stack	@ System
.endm

.macro do_checking
	@ Check UART manipulation functions
	bl uart_test

	@ Check GPIO manipulation functions
	@ bl gpio_test
.endm

.macro print_regs
	bl print_scr
	bl print_tcmsr
	bl print_midr
	bl print_ctr
.endm
.text

.macro setup_exc
	@ Setup exceptions vector to 0x0
	mov r0, #0x0
	bl place_exc_vector

	ldr r0, =undef_handler
	bl setup_undef_handler

	ldr r0, =svc_cmc_handler
	bl setup_svc_cmc_handler

	ldr r0, =pabt_handler
	bl setup_pabt_handler

	ldr r0, =dabt_handler
	bl setup_dabt_handler

	ldr r0, =irq_handler
	bl setup_irq_handler

	ldr r0, =fiq_handler
	bl setup_fiq_handler

	@ TODO Enable exceptions
	bl enable_irq @ TODO What does it do?
.endm
/*
 * Entry point
 */
entry:

@1	@ The system is now in Supervisor mode
	setup_stacks
	@ The system now is in System mode - working mode
	do_checking
	@Print registers
	print_regs




@6	@ Check timer

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
@7
1:
	bl uart_test
	b 1b
	/* !!!!!!!!!!!!  */
	b stub_func /* Important to be confident that project can be built with .S and .c files */

