#include "printregs.h"

.global print_cpsr, print_spsr
.global print_scr, print_ttbr0, print_ttbr1, print_ttbcr, print_midr
.global print_dacr, print_nsacr, print_tcmsr, print_itcmr, print_dtcmr
.global print_tlbtr, print_ctr, print_cidr
.global print_halt, print_undef, print_svc_smc, print_pabt, print_dabt, print_irq, print_fiq

.text

/******************************************************/

print_halt:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =HALT
	bl uart_send4
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

print_undef:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =UNDEF
	bl uart_send4
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

print_svc_smc:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =SVMC
	bl uart_send4
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

print_pabt:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =PABT
	bl uart_send4
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

print_dabt:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =DABT
	bl uart_send4
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

print_irq:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =IRQ
	bl uart_send4
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

print_fiq:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =FIQ
	bl uart_send4
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/******************************************************/

/* Print Current Program Status Register
 * Input:
 * Return:
 */
print_cpsr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, cpsr
	ldr r0, =CPSR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Saved Program Status Register
 * Input:
 * Return:
 */
print_spsr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrs r1, spsr
	ldr r0, =SPSR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Secure Configuration Register
 * Input:
 * Return:
 */
print_scr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4
	
	mrc p15, 0, r1, c1, c1, 0
	ldr r0, =SCR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Translation Table Base 0 Register
 * Input:
 * Return:
 */
print_ttbr0:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c2, c0, 0
	ldr r0, =TTBR0
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Translation Table Base 1 Register
 * Input:
 * Return:
 */
print_ttbr1:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c2, c0, 1
	ldr r0, =TTBR1
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Translation Table Base Control Register
 * Input:
 * Return:
 */
print_ttbcr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c2, c0, 2
	ldr r0, =TTBCR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Main ID Register
 * Input:
 * Return:
 */
print_midr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c0, c0, 0
	ldr r0, =MIDR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Domain Access Control Register
 * Input:
 * Return:
 */
print_dacr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c3, c0, 0
	ldr r0, =DACR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Non-Secure Access Control Register
 * Input:
 * Return:
 */
print_nsacr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c1, c1, 2
	ldr r0, =NSACR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print TCM Status Register
 * Input:
 * Return:
 */
print_tcmsr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4
	
	mrc p15, 0, r0, c0, c0, 2
	ldr r0, =TCMSR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Instruction TCM Register
 * Input:
 * Return:
 */
print_itcmr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c9, c1, 1
	ldr r0, =ITCMR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Data TCM Register
 * Input:
 * Return:
 */
print_dtcmr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c9, c1, 0
	ldr r0, =DTCMR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print TLB Type Register
 * Input:
 * Return:
 */
print_tlbtr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c0, c0, 3
	ldr r0, =TLBTR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Cache Type Register
 * Input:
 * Return:
 */
print_ctr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c0, c0, 1
	ldr r0, =CTR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

/* Print Context ID Register
 * Input:
 * Return:
 */
print_cidr:

	stmdb sp!, {r0, lr}
	sub sp, sp, #0x4

	mrc p15, 0, r0, c13, c0, 1
	ldr r0, =CIDR
	bl uart_send4
	mov r0, r1
	bl uart_send4

	add sp, sp, #0x4
	ldmia sp!, {r0, lr}
	mov pc, lr

