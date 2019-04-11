#include "basemacro.S"
#include "ports.S"
#include "printreg.h"
#include "printval.S"

.global enable_timer_irq, disable_timer_irq, clear_timer_pend_exc
.global enable_timer, disable_timer, setup_timer, set_timer_value
.global armside_timer_exc_handler

.text

/*
 * TODO Description
 */
armside_timer_exc_handler:

	save

	ldr r0, =TIMER_BASE
	ldr r2, [r0, #TIMER_IRQPEND]
	ldr r3, [r0, #TIMER_MSKIRQ]
	print TIMERIRQPEND, r2
	print TIMERMSKIRQ, r3
	mov r1, #0x1
	str r1, [r0, #TIMER_CLRIRQ]

	restore
	mov pc, lr
 
/*
 * Enable one of IRQ source as ARM Timer Interrupt
 * Input:
 * Return:
 */
enable_timer_irq:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	@ Enable IRQ sourse in a Base Interrupt Enable Register
	ldr r0, =IRQ_BASE		@ 
	mov r1, #IRQ0_ARM_TIMER		@ Enable ARM Timer IRQ (1 in 0s bit)
	str r1, [r0, #IRQ0_EN]		@ Store the value in the BIER

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
	ldr r0, =IRQ_BASE		@ 
	mov r1, #IRQ0_ARM_TIMER		@ Disable ARM Timer IRQ (1 in 0s bit)
	str r1, [r0, #IRQ0_DIS]		@ Store the value in the BIER

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Clear pending exception bit
 * Input:
 * Return:
 */
clear_timer_pend_exc:

	stmdb sp!, {r0, r1}
	sub sp, sp, #0x4

	ldr r0, =TIMER_BASE + TIMER_CLRIRQ
	mov r1, #0x0
	str r1, [r0]

	add sp, sp, #0x4
	ldmia sp!, {r0, r1}
	mov pc, lr

/*
 * Activate previously setup timer
 * Input:
 * Return:
 */
enable_timer:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	ldr r0, =TIMER_BASE		@
	ldr r1, [r0, #TIMER_CTRL]	@ 
	orr r1, #TIMER_CTRL_ENABLE	@ 
	str r1, [r0, #TIMER_CTRL]	@ 

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Deactivate timer
 * Input:
 * Return:
 */
disable_timer:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	ldr r0, =TIMER_BASE		@ 
	ldr r1, [r0, #TIMER_CTRL]	@ 
	bic r1, #TIMER_CTRL_ENABLE	@ 
	str r1, [r0, #TIMER_CTRL]	@

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Setup default timer configuration
 * Input:
 * Return:
 */
setup_timer:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4
	str r2, [r13], #-0x4

	ldr r0, =TIMER_BASE		@
	ldr r2, =TIMER_CTRL_DEFVAL	@
	orr r1, r2			@
	str r1, [r0, #TIMER_CTRL]	@

	ldr r2, [r13, #0x4]!
	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Set new value for timer counter
 * Input: r0 - New value for timer counter. The value must be in range between 1 and 65535
 * Return:
 */
set_timer_value:

	str r1, [r13], #-0x4

	ldr r1, =TIMER_BASE		@
	str r0, [r1, #TIMER_LOAD]	@

	ldr r1, [r13, #0x4]!

	mov pc, lr
