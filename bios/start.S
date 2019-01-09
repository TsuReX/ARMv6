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

@1	@ The system is now in Supervisor mode
	
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
@2	@ Check UART manipulation functions
	bl uart_test

@3	@ Print Coprocessor registers
	bl print_scr
	bl print_tcmsr
	bl print_midr
	bl print_ctr
	

@4	@ Check GPIO manipulation functions
	@ bl gpio_test

@5	@ Setup exceptions vector to 0x0
	mov r0, #0x0
	bl place_exc_vector

@6	@ Check timer
	ldr r0, =uart_test
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
@7
1:
	bl uart_test
	b 1b
	/* !!!!!!!!!!!!  */
	b stub_func /* Important to be confident that project can be built with .S and .c files */

