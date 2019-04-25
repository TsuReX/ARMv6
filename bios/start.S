#include "ports.S"
#include "basemacro.S"

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

.endm @ setup_stacks

.macro print_regs

	bl print_cpsr
	bl print_spsr
	bl print_scr
	bl print_tcmsr
	bl print_midr
	bl print_ctr

.endm @ print_regs

.macro setup_exc

	@ Setup exceptions vector to 0x0
	mov r0, #0x0
	bl place_exc_vector

	ldr r0, =undef_handler
	bl setup_undef_handler

	ldr r0, =svc_smc_handler
	bl setup_svc_smc_handler

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

.text

/*
 * Entry point
 */
entry:

@1	@ The system is now in Supervisor mode
	setup_stacks
	@ The system now is in System mode - working mode

#ifdef CHECKING
	bl check
#endif

	@ Print registers
	print_regs

	@ Setup default exceptions' handlers
	setup_exc

1:
	b 1b
	@ Check timer

	bl enable_irq
	bl enable_timer_irq
	bl setup_timer
	ldr r0, =0xFFFF
	bl set_timer_value
	bl enable_timer

2:
	b 2b
	/* !!!!!!!!!!!!  */
	ccall stub_func /* Important to be confident that project can be built with .S and .c files */
