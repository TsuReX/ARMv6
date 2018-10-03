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
	sub sp, sp, #0x18
	stm sp, {r2-r7, lr}

	mov r7, r1			@
	mov r1, #0x20			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne exit			@ go exit in case of error occurence
	ldr r3, =GPIO_BASE		@
	add r4, r3, #GPIO_GPCLR1	@ GPIO_CLEAR_BASE
	add r3, r3, #GPIO_GPSET1	@ GPIO_SET_BASE
	mov r5, #0x4			@ bytes per register
	umlal r3, r0, r1, r5		@ [r6:r3] = [r6:r3] + r1 * r7; r3 contains SET reg address 
	umlal r4, r0, r1, r5		@ [r6:r3] = [r6:r3] + r1 * r7; r3 contains CLEAR reg address
	@ r0, r1, r5, r6,
	add r0, r0, r9, lsl r2		@ r0 = r9 << r2 
	str r0, [r4]			@ clear bit
	str r0, [r3]			@ set bit
	
	exit:
	@ Restore frame check !!!
	ldm sp, {r2-r7, lr}!
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
