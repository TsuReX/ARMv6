#include "ports.S"

.equ MAGIC,		0xDEADBEAF

.global enable_all_exc, disable_all_exc, print_pend_exc, place_exc_vector, enable_irq, disable_irq, enable_fiq, disable_fiq, setup_irq_handler

.data

irq_handler_fcn: .word  MAGIC	@ Pointer to handler function for IRQ interrupt
fiq_handler_fcn: .word  MAGIC	@ Pointer to handler function for FIQ interrupt

.text

/*
 * Enable all interrupts on SoC
 */
enable_all_exc:
	@ TODO
	mov pc, lr

/*
 * Disable all interrupts on SoC
 */
disable_all_exc:
	@ TODO
	mov pc, lr

/*
 * Print pending status of basic interrupts
 */
print_pend_exc:

	save

	ldr r1, =IRQ_BASE + IRQ0_PEND
	ldr r0, [r1]

	restore
	mov pc, lr

/*
 * Enable IRQ in CPSR register
 * Input:
 * Return:
 */
enable_irq:

	str r0, [r13], #-0x4

	mrs r0, cpsr		@ Read a value of state register
	orr r0, #CPSR_IRQ	@ Set 7th bit into 1
	msr cpsr, r0		@ Store the value into the state register

	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Disable IRQ in CPSR register
 * Input:
 * Return:
 */
disable_irq:

	str r0, [r13], #-0x4

	mrs r0, cpsr		@ Read a value of state register
	bic r0, #CPSR_IRQ	@ Clear 7th bit
	msr cpsr, r0		@ Store the value into the state register

	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Enable FIQ in CPSR register
 * Input:
 * Return:
 */
enable_fiq:

	str r0, [r13], #-0x4

	mrs r0, cpsr		@ Read a value of state register
	orr r0, #CPSR_FIQ	@ Set 6th bit into 1
	msr cpsr, r0		@ Store the value into the state register

	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Disable FIQ in CPSR register
 * Input:
 * Return:
 */
disable_fiq:

	str r0, [r13], #-0x4

	mrs r0, cpsr		@ Read a value of state register
	bic r0, #CPSR_FIQ	@ Clear 6th bit
	msr cpsr, r0		@ Store the value into the state register

	ldr r0, [r13, #0x4]!

	mov pc, lr

/*
 * Copy the vector of exceptions to specified address
 * Input: r0 - destination address of exception's vector to copy
 * Return:
 */
place_exc_vector:

	mov r11, r0
	ldr r10, =ivt_begin

	@ 8 instructions each of which has one word length
	ldm r10!, {r0-r7} @ r0 = r10[0]; ...; r7 = r10[7]; r10 = r10 + 8 * sizeof(rX)
	stm r11!, {r0-r7} @ r11[0] = r0; ...; r11[7] = r7; r11 = r11 + 8 * sizeof(rX)

	mov pc, lr

/*
 * Setup handler for IRQ exception
 * Input: r0 - address of handler function
 * Return:
 */
setup_irq_handler:

	ldr r1, =irq_handler_fcn
	str r0, [r1]

	mov pc, lr

/*
 * Setup handler for FIQ exception
 * Input: r0 - address of handler function
 * Return:
 */
setup_fiq_handler:

	ldr r1, =fiq_handler_fcn
	str r0, [r1]

	mov pc, lr

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
 * Low level handler for IRQ exception
 */
irq_exc:

	ldr r0, =irq_handler_fcn	@ Get address of pointer
	ldr r0, [r0]				@ Resolve pointer to get address of function
	ldr r1, =MAGIC				@ Get magic value of empty pointer
	cmp r0, r1					@ Compare the address of function and the magic value
	mov lr, pc			@ Save return address
	bxne r0				@ Call funcion if address of funtion is valid

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
ivt_begin:
ldr pc, =reset_exc		@ 0x00
ldr pc, =undef_exc		@ 0x04
ldr pc, =svc_smc_exc	@ 0x08
ldr pc, =pabt_exc		@ 0x0C
ldr pc, =dabt_exc		@ 0x10
.word 0x0F0FF0F0		@ 0x14
ldr pc, =irq_exc		@ 0x18
ldr pc, =fiq_exc		@ 0x1C
ivt_end:
