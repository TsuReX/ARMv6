#include "ports.S"

.global gpio_get, gpio_set, gpio_inv, gpio_set_mode

.text

/*
 * Set value for specified number GPIO
 * Input:	r0 - GPIO number
 *		r1 - Value (0 or 1) to be set
 * Return:	r0 - Error number (TODO)
 */
gpio_set:

	stmdb sp!, {r2-r6, lr}
	sub sp, sp, #0x4

	mov r3, r1			@
	mov r1, #0x20			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne 1f				@ go exit in case of error occurence

	@ r0 - free; r1 - integer part;
	@ r2 - remaider; r3 - value to set;

	ldr r0, =GPIO_BASE		@
	add r4, r0, #GPIO_GPSET0	@ GPIO_SET_BASE
	add r5, r0, #GPIO_GPCLR0	@ GPIO_CLEAR_BASE

	@ r0 - free;

	mov r0, #0x4			@ bytes per register
	umlal r4, r6, r1, r0		@ [r6:r4] = [r5:r4] + r1 * r0; r4 contains SET reg address 
	umlal r5, r6, r1, r0		@ [r6:r5] = [r6:r5] + r1 * r0; r5 contains CLEAR reg address

	@ r0, r1, - free;
	@ r2, r3, r4, - used

	mov r0, #0x1
	mov r0, r0, lsl r2		@ r0 = 1 << r2  mask to clear gpio bit
	mov r1, r3, lsl r2		@ r1 = r3 << r2 value to set

	str r0, [r5]			@ clear bit
	str r1, [r4]			@ set bit

	mov r0, #0x0			@ error code is OK

	1:				@ exit
	add sp, sp, #0x4
	ldmia sp!, {r2-r6, lr}
	mov pc, lr

/*
 * Invert value for specified number GPIO
 * Input:	r0 - GPIO number
 * Return:	r0 - Error number (TODO)
 */
gpio_inv:

	stmdb sp!, {r2-r6, lr}
	sub sp, sp, #0x4

@	mov r3, r1			@
	mov r1, #0x20			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne 1f				@ go exit in case of error occurence

	@ r0 - free; r1 - integer part;
	@ r2 - remaider; r3 - value to set;

	ldr r0, =GPIO_BASE		@
	add r4, r0, #GPIO_GPSET0	@ GPIO_SET_BASE
	add r5, r0, #GPIO_GPCLR0	@ GPIO_CLEAR_BASE

	@ r0 - free;

	mov r0, #0x4			@ bytes per register
	umlal r4, r6, r1, r0		@ [r6:r4] = [r5:r4] + r1 * r0; r4 contains SET reg address 
	umlal r5, r6, r1, r0		@ [r6:r5] = [r6:r5] + r1 * r0; r5 contains CLEAR reg address

	@ r0, r1, - free;
	@ r2, r3, r4, - used

	mov r0, #0x1
	mov r0, r0, lsl r2		@ r0 = 1 << r2  mask to clear gpio bit

	ldr r3, [r4]			@ load last set value
	eor r1, r3, r0			@ invert value
	str r0, [r5]			@ clear bit
	str r1, [r4]			@ set bit

	mov r0, #0x0			@ error code is OK

	1:				@ exit
	add sp, sp, #0x4
	ldmia sp!, {r2-r6, lr}
	mov pc, lr

/*
 * Get value for specified number GPIO
 * Input:	r0 - GPIO number
 * Return:	r0 - Error number (TODO)
 * 		r1 - Value (0 or 1)
 */
gpio_get:

	stmdb sp!, {r2-r4, lr}
	sub sp, sp, #0x4

	mov r1, #0x20			@ r1 is gpios count per register
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

	ldr r0, [r3]			@ load gpio values
	mov r1, r0, lsr r2		@ r1 = r0 >> r2  shift read value of gpio
	and r1, r1, #0x1		@ mask read value
	mov r0, #0x0			@ error code is OK

	1:				@ exit
	add sp, sp, #0x4
	ldmia sp!, {r2-r4, lr}
	mov pc, lr

/*
 * Set alternate function for specified number GPIO
 * Input:	r0 - GPIO number
 *		r1 - Function's number to be set
 * Return:	r0 - Error number (TODO)
 */
gpio_set_mode:

	stmdb sp!, {r2-r5, lr}
	sub sp, sp, #0x4

	mov r3, r1			@ save value of mode to r4
	mov r1, #0x0A			@ r1 is gpios count per register
	bl uidiv_1			@ r1 = r0 div r1; r2 = r0 mod r1; r0 = error
	cmp r0, #0x0			@ check error
	bne 1f				@ go exit in case of error occurence

	@ r0 - free; r1 - integer part;
	@ r2 - remaider; r3 - value to set;

	ldr r0, =GPIO_BASE		@
	add r4, r0, #GPIO_GPFSEL0	@ GPIO_FUNC_BASE

	@ r0 - free;

	mov r0, #0x4			@ bytes per register
	umlal r4, r5, r1, r0		@ [r5:r4] = [r5:r4] + r1 * r0; r3 contains FUNC reg address

	@ r0, r1, - free;
	@ r2, r3, r4, - used

	mov r0, #0x3			@
	mul r2, r2, r0			@ 3 bits per each gpio
	mov r1, r3, lsl r2		@ r1 = r3 << r2 value to set
	mov r5, #0x7			@ 0b111 mask value
	mov r5, r5, lsl r2		@ r5 = r5 << r2 clear value

	ldr r0, [r4]			@ read value
	bic r0, r5			@ clear bits
	orr r0, r0, r1			@ set bits
	str r0, [r4]			@ write new value

	mov r0, #0x0			@ error code is OK

	1:				@ exit
	add sp, sp, #0x4
	ldmia sp!, {r2-r5, lr}
	mov pc, lr
