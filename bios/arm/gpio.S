#include "ports.S"

.global set_gpio_val, get_gpio_val, set_gpio_mode

.text

/*
 * Set value for specified number GPIO
 * Input:	r0 - GPIO number
 *		r1 - Value (0 or 1) to be set
 * Return:	r0 - Error number (TODO)
 */
set_gpio_val:

	@ TODO Check

	@ Save frame check!!!
	sub sp, sp, #0x10		@ 0x10 = 16 bytes = 4 register * 4 bytes per each register
	stm sp, {r2-r5, lr}		@ Why 4 registers? r2, r3, r4, r5,  lr(r14) are 5
					@ Rigth! But sp(r13) points free word in memory already
					@ And it needs to make offset from current free word
					@ for another 4 registers.
	sub sp, sp, #0x4		@ Now sp(r13) points to last written word in memory
					@ It needs to be moved one word (4 bytes)
					@ in lower addresses direction.

	mov r3, r1			@
	mov r1, #0x14			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne 1f				@ go exit in case of error occurence
	
	@ r0 - free; r1 - integer part;
	@ r2 - remaider; r3 - value to set;

	ldr r0, =GPIO_BASE		@
	add r4, r0, #GPIO_GPSET0	@ GPIO_SET_BASE
	add r3, r0, #GPIO_GPCLR0	@ GPIO_CLEAR_BASE
	
	@ r0 - free;
	
	mov r0, #0x4			@ bytes per register
	umlal r4, r5, r1, r0		@ [r5:r4] = [r5:r4] + r1 * r0; r4 contains SET reg address 
	umlal r3, r5, r1, r0		@ [r5:r3] = [r5:r3] + r1 * r0; r5 contains CLEAR reg address
	
	@ r0, r1, - free;
	@ r2, r3, r4, - used
	
	mov r0, #0x1
	mov r0, r0, lsl r2		@ r0 = 1 << r2  mask to clear gpio bit
	mov r1, r3, lsl r2		@ r1 = r3 << r2 value to set

	str r0, [r4]			@ clear bit
	str r1, [r5]			@ set bit
	
	1:				@ exit
	@ Restore frame check !!!
	ldm sp!, {r2-r5, lr}		@ It needs to change sp(r13) value 
					@ to point free word in memory.
					@ After loading these registers
					@ it points to non free word.
	sub sp, sp, #0x4		@ It needs to be moved sp(r13) one word(4 bytes)
					@ in lower addresses direction.
	mov pc, lr

/*
 * Get value for specified number GPIO
 * Input:	r0 - GPIO number
 * Return:	r0 - Error number (TODO)
 * 		r1 - Value (0 or 1)
 */
get_gpio_val:

	@ TODO Check

	stmdb sp!, {r2-r4, lr}		@ sp = sp - 4 * 5, then store registers
	sub sp, sp, #0x4		@ move sp onto free word

	mov r1, #0x14			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne 1f				@ go exit in case of error occurence
	
	@ r0 - free; r1 - integer part;
	@ r2 - remaider;

	ldr r0, =GPIO_BASE		@
	add r3, r0, #GPIO_GPLEV0	@ GPIO_READ_BASE
	
	@ r0 - free;
	
	mov r0, #0x4			@ bytes per register
	umlal r3, r4, r1, r0		@ [r4:r3] = [r4:r3] + r1 * r0; r3 contains READ reg address
	
	@ r0, r1, - free;
	@ r2, r3 - used
	
	ldr r0, [r3]

	mov r1, r0, lsr r2		@ r0 = r0 >> r2  shift read value of gpio
	and r1, r1, #0x1		@ mask read value
	
	1:
	add sp, sp, #0x4		@ move sp onto the first used word
	ldmia sp!, {r2-r4, lr}		@ load data from mem to regs, sp = sp + 4 * 5
	mov pc, lr

/*
 * Set alternate function for specified number GPIO
 * Input:	r0 - GPIO number
 *		r1 - Function's number to be set
 * Return:	r0 - Error number (TODO)
 */
set_gpio_mode:

	@ TODO Check

	@ Save frame check!!!
	sub sp, sp, #0x10		@ 0x10 = 16 bytes = 4 register * 4 bytes per each register
	stm sp, {r2-r5, lr}		@ Why 4 registers? r2, r3, r4, r5,  lr(r14) are 5
					@ Rigth! But sp(r13) points free word in memory already
					@ And it needs to make offset from current free word
					@ for another 4 registers.
	sub sp, sp, #0x4		@ Now sp(r13) points to last written word in memory
					@ It needs to be moved one word (4 bytes)
					@ in lower addresses direction.

	mov r4, r1			@
	mov r1, #0x0A			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne 1f				@ go exit in case of error occurence
	
	@ r0 - free; r1 - integer part;
	@ r2 - remaider; r3 - value to set;

	ldr r0, =GPIO_BASE		@
	add r3, r0, #GPIO_GPFSEL0	@ GPIO_FUNC_BASE
	
	@ r0 - free;
	
	mov r0, #0x4			@ bytes per register
	umlal r3, r5, r1, r0		@ [r5:r3] = [r5:r3] + r1 * r0; r3 contains FUNC reg address
	
	@ r0, r1, - free;
	@ r2, r3, r4, - used
	
	mov r1, r4, lsl r2		@ r1 = r4 << r2 value to set
	mov r4, #0x7			@ 0b111 mask value
	mov r4, r4, lsl r2		@ 

	ldr r0, [r3]			@ read value
	bic r0, r4			@ clear bits
	orr r0, r0, r1			@ set bits
	str r0, [r3]			@ write new value
	
	1:				@ exit
	@ Restore frame check !!!
	ldm sp!, {r2-r5, lr}		@ It needs to change sp(r13) value 
					@ to point free word in memory.
					@ After loading these registers
					@ it points to non free word.
	sub sp, sp, #0x4		@ It needs to be moved sp(r13) one word(4 bytes)
					@ in lower addresses direction.
	mov pc, lr
