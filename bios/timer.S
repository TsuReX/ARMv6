#include "ports.S"

.global enable_timer_irq, disable_timer_irq

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
