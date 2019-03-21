#include "basemacro.S"
#include "ports.S"

.equ MAGIC,		0xDEADBEAF

.global print_pend_exc, place_exc_vector
.global enable_irq, disable_irq, enable_fiq, disable_fiq
.global setup_undef_handler, setup_svc_smc_handler, setup_pabt_handler, setup_dabt_handler, setup_irq_handler, setup_fiq_handler
.global _func_ptrs_begin, _func_ptrs_end @ For debug

.data

_func_ptrs_begin:	@ For debug
undef_handler_fcn:	.word  MAGIC	@ Pointer to handler function for UNDEF interrupt
svc_smc_handler_fcn:	.word  MAGIC
pabt_handler_fcn:	.word  MAGIC
dabt_handler_fcn:	.word  MAGIC
irq_handler_fcn:	.word  MAGIC
fiq_handler_fcn:	.word  MAGIC
_func_ptrs_end:	@ For debug

.text

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
 * Setup handler for undefined instruction exception
 * Input: r0 - address of handler function
 * Return:
 */
setup_undef_handler:

	save

	ldr r1, =undef_handler_fcn
	str r0, [r1]

	restore
	mov pc, lr

/*
 * Setup handler for supervisor call and secure monitor call exceptions
 * Input: r0 - address of handler function
 * Return:
 */
setup_svc_smc_handler:

	save

	ldr r1, =svc_smc_handler_fcn
	str r0, [r1]

	restore
	mov pc, lr

/*
 * Setup handler for prefetch abort exception
 * Input: r0 - address of handler function
 * Return:
 */

setup_pabt_handler:

	save

	ldr r1, =pabt_handler_fcn
	str r0, [r1]

	restore
	mov pc, lr

/*
 * Setup handler for data abort exception
 * Input: r0 - address of handler function
 * Return:
 */
setup_dabt_handler:

	save

	ldr r1, =dabt_handler_fcn
	str r0, [r1]

	restore
	mov pc, lr

/*
 * Setup handler for IRQ exception
 * Input: r0 - address of handler function
 * Return:
 */
setup_irq_handler:

	save

	ldr r1, =irq_handler_fcn
	str r0, [r1]

	restore
	mov pc, lr

/*
 * Setup handler for FIQ exception
 * Input: r0 - address of handler function
 * Return:
 */
setup_fiq_handler:

	save

	ldr r1, =fiq_handler_fcn
	str r0, [r1]

	restore
	mov pc, lr

/*
 * Reset handler. The function is an entry point in programm after CPU was reset
 */
reset_exc:
	@ TODO What address CPU jumps during exit ???
	@ I think that here should be jump to entry point
	b .

/*
 * Undefined instruction exception default handler
 */
undef_exc:

	save

	bl print_undef
	bl print_cpsr
	bl print_spsr

	ldr r0, =undef_handler_fcn
	ldr r1, =MAGIC
	cmp r0, r1
	blne undef_handler_fcn
	bl print_halt
	b .

	restore
	movs pc, r14
	@subs pc, r14, #0x4 @ See ARMv6 ARM A2.6.3 Undefined Instruction exception

/*
 * Default handler for software interrupt (SVC) and
 * for secure monitor call (SMC)
 */
svc_smc_exc:

	save

	bl print_svc_smc
	bl print_cpsr
	bl print_spsr

	ldr r0, =svc_smc_handler_fcn
	ldr r1, =MAGIC
	cmp r0, r1
	blne svc_smc_handler_fcn
	bl print_halt
	b .

	restore
	movs pc, r14

/*
 * Prefetch abort default handler
 */
pabt_exc:

	save

	bl print_pabt
	bl print_cpsr
	bl print_spsr

	ldr r0, =pabt_handler_fcn
	ldr r1, =MAGIC
	cmp r0, r1
	blne pabt_handler_fcn
	bl print_halt
	b .

	restore
	subs pc, r14, #0x4

/*
 * Data abort default handler
 */
dabt_exc:

	save

	bl print_dabt
	bl print_cpsr
	bl print_spsr

	ldr r0, =dabt_handler_fcn
	ldr r1, =MAGIC
	cmp r0, r1
	blne dabt_handler_fcn
	bl print_halt
	b .

	restore
	subs pc, r14, #0x8

	@subs pc, r14, #0x4	@ Use this exit way in case 
						@ when interrupted instruction isn't needed to be reexecuted

/*
 * Interrupt default handler
 */
irq_exc:

	save

	bl print_irq
	bl print_cpsr
	bl print_spsr

	ldr r0, =irq_handler_fcn	@ Get address of pointer
	ldr r0, [r0]				@ Resolve pointer to get address of function
	ldr r1, =MAGIC				@ Get magic value of empty pointer
	cmp r0, r1					@ Compare the address of function and the magic value
	mov lr, pc			@ Save return address
	bxne r0				@ Call funcion if address of funtion is valid
	bl print_halt
	b .

	restore
	subs pc, r14, #0x4

/*
 * Fast interrupt default handler
 */
fiq_exc:

	fiq_save

	bl print_fiq
	bl print_cpsr
	bl print_spsr

	ldr r0, =fiq_handler_fcn
	ldr r1, =MAGIC
	cmp r0, r1
	blne fiq_handler_fcn
	bl print_halt
	b .

	fiq_restore
	subs pc, r14, #0x4

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
