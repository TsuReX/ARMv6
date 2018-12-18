#include "ports.S"

.global get_sys_timer_value

.text

/*
 * Return 64bit value of system timer
 * Input:
 * Output: 	r0 - lower 32bit of value
 * 		r1 - higher 32bit of value
 */
get_sys_timer_value:

	str r2, [sp], #0x4

	ldr r2, =SYS_TIMER_BASE
	ldr r0, [r2, #SYS_TIMER_CLO]
	ldr r1, [r2, #SYS_TIMER_CHI]

	ldr r2, [sp, #-0x4]!
	mov pc, lr
