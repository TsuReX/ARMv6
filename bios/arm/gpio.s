.text
.global set_gpio_val, get_gpio_val, set_gpio_mode

/*
 * Set value for specified number GPIO
 * Input:	r0 - GPIO number
 *			r1 - Value (0 or 1)
 * Return:
 */
set_gpio_val:

	@ TODO Implement
	@ Calculate a register offset and gpio bits offset into a register
	@ Read, clear (val AND mask), write (val OR mode_val

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
