#include <ports.S>
#include <basemacro.S>
#include <gpio_rpib.inc.S>

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
#ifdef RASPBERRY_PI1
	cps #MON_MODE
	ldr sp, = __mon_stack	@ Secure Monitor
#endif
	cps #SYS_MODE
	ldr sp, = __sys_stack	@ System
	@ The system now is in System mode - working mode

	@ Setup GPIO ports for RPi-B
	bl gpio_init_rpib

#ifdef CHECKING
	bl check
#endif

	bl term_blink
