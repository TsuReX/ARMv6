#define MAGIC	0xDEADBEAF

.global setup_irq_vector, enable_irq, setup_irq_handler

.data

irq_handler_fcn: .word  MAGIC	@ Pointer to handler function for IRQ interrupt
fiq_handler_fcn: .word  MAGIC	@ Pointer to handler function for FIQ interrupt

.text

/*
 * Enable IRQ in CPSR register
 * Input:
 * Return:
 */
enable_irq:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	mrs r0, cpsr	@ Read a value of state register
	orr r0, #0x80	@ Enable IRQ (1 in 7th bit)
	msr cpsr, r0	@ Store the value into the state register

	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * TODO Description
 * Input:
 * Return:
 */
setup_irq_vector:

	mov r11, #0x00000000
	ldr r10, =ivt_start

	@	out ---> in
	ldm r10!, {r0-r7} @ r0 = r10[0]; ...; r7 = r10[7]; r10 = r10 + 8 * sizeof(rX)
	@	in <--- out
	stm r11!, {r0-r7} @ r11[0] = r0; ...; r11[7] = r7; r11 = r11 + 8 * sizeof(rX)

/*	8 instructions each of which has one word length
	@	out ---> in
	ldm r10, {r0-r7} @ r0 = r10[0]; ...; r7 = r10[7];
	@	in <--- out
	stm r11, {r0-r7} @ r11[0] = r0; ...; r11[7] = r7;
*/
	mov pc, lr

/*
 * TODO Description
 * Input:
 * Return:
 */
setup_irq_handler:

	b .

/*
 * TODO Description
 */
reset_exc:

	b .

/*
 * TODO Description
 */
undef_exc:
	b .
	
	movs pc, r14

/*
 * TODO Description
 */
svc_smc_exc:

	b .
	
	movs pc, r14

/*
 * TODO Description
 */
pabt_exc:

	b .
	
	subs pc, r14, #0x4

/*
 * TODO Description
 */
dabt_exc:

	b .
	
	subs pc, r14, #0x8

/*
 * TODO Description
 */
irq_exc:

	ldr r0, =irq_handler_fcn
	ldr r1, =MAGIC
	cmp r0, r1
	blne irq_handler_fcn
	
	subs pc, r14, #0x4

/*
 * TODO Description
 */
fiq_exc:

	ldr r0, =fiq_handler_fcn
	ldr r1, =MAGIC
	cmp r0, r1
	blne fiq_handler_fcn
	
	subs pc, r14, #0x4

/*
 * TODO Description
 */
smc_exc:

	b .

/*
 * Vector of exceptions
 */
ivt_start:
ldr pc, =reset_exc		@ 0x00
ldr pc, =undef_exc		@ 0x04
ldr pc, =svc_smc_exc	@ 0x08
ldr pc, =pabt_exc		@ 0x0C
ldr pc, =dabt_exc		@ 0x10
.word 0x0F0FF0F0		@ 0x14
ldr pc, =irq_exc		@ 0x18
ldr pc, =fiq_exc		@ 0x1C
