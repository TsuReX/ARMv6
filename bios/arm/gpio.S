#include "ports.S"

.global set_gpio_val, get_gpio_val, set_gpio_mode

.text

/*
 * Set value for specified number GPIO
 * Input:	r0 - GPIO number
 *		r1 - Value (0 or 1)
 * Return:
 */
set_gpio_val:

	@ TODO Implement
	@ Calculate a register offset and gpio bits offset into a register
	@ Read, clear (val AND mask), write (val OR mode_val

	@ Save frame check!!!
	sub sp, sp, #0x14		@ 0x14 = 20 bytes = 5 register * 4 bytes per each register
	stm sp, {r2-r6, lr}		@ Why 6 registers? r2, r3, r4, r5, r6,  lr(r14) are 6
					@ Rigth! But sp(r13) points free word in memory already
					@ And it needs to make offset from current free word
					@ for another 6 registers.
	sub sp, sp, #0x4		@ Now sp(r13) points to last written word in memory
					@ It needs to be moved one word (4 bytes)
					@ in lower addresses direction.

	mov r3, r1			@
	mov r1, #0x20			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne exit			@ go exit in case of error occurence
	
	@ r0 - free; r1 - integer part;
	@ r2 - remaider; r3 - value to set;

	ldr r0, =GPIO_BASE		@
	add r4, r0, #GPIO_GPCLR1	@ GPIO_CLEAR_BASE
	add r3, r0, #GPIO_GPSET1	@ GPIO_SET_BASE
	
	@ r0 - free;
	
	mov r0, #0x4			@ bytes per register
	umlal r4, r5, r1, r0		@ [r5:r4] = [r5:r4] + r1 * r0; r4 contains SET reg address 
	umlal r5, r6, r1, r0		@ [r6:r5] = [r6:r5] + r1 * r0; r5 contains CLEAR reg address
	
	@ r0, r1, - free;
	@ r2, r3, r4, r5 - used
	
	mov r0, #0x1
	mov r0, r0, lsl r2		@ r0 = 1 << r2  mask to clear gpio bit
	mov r1, r3, lsl r2		@ r1 = r3 << r2 value to set

	str r0, [r4]			@ clear bit
	str r1, [r5]			@ set bit
	
	exit:
	@ Restore frame check !!!
	ldm sp!, {r2-r6, lr}		@ It needs to change sp(r13) value 
					@ to point free word in memory.
					@ After loading these registers
					@ it points to non free word.
	sub sp, sp, #0x4		@ It needs to be moved sp(r13) one word(4 bytes)
					@ in lower addresses direction.
	mov pc, lr

/*
 * Get value for specified number GPIO
 * Input:	r0 - GPIO number
 * Return:	r0 - error number
 * 			r1 - Value (0 or 1)
 */
get_gpio_val:

	@ TODO Implement
	@ Calculate a register offset and gpio bits offset into a register
	@ Read, mask (val AND mask)

	mov pc, lr

/*
 * Set alternate function for specified number GPIO
 * Input:	r0 - GPIO number
 *			r1 - Function to be set
 * Return:
 */
set_gpio_mode:

	@ TODO Implement
	@ Calculate a register offset and gpio bits offset into a register
	@ Calculate function bit mask by function number
	@ Read, clear (val AND mask), write (val OR mode_val)

	mov pc, lr
