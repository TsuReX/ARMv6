#include "ports.S"

.global term_blink

.equ 	DELAY, 5000000

.macro gpio_16_1

	mov r0, #GPIO_16	@ Specify GPIO number
	mov r1, #0x1		@ Specify GPIO value
	bl set_gpio_val		@ Set value to GPIO

.endm @ gpio_16_1

.macro gpio_16_0

	mov r0, #GPIO_16	@ Specify GPIO number
	mov r1, #0x0		@ Specify GPIO value
	bl set_gpio_val		@ Set value to GPIO

.endm @ gpio_16_0

.macro gpio_24_1

	mov r0, #GPIO_24
	mov r1, #0x1
	bl set_gpio_val

.endm

.macro gpio_24_0

	mov r0, #GPIO_24
	mov r1, #0x0
	bl set_gpio_val

.endm @ gpio_24_0

.macro gpio_25_1

	mov r0, #GPIO_25
	mov r1, #0x1
	bl set_gpio_val

.endm @ gpio_25_1

.macro gpio_25_0

	mov r0, #GPIO_25
	mov r1, #0x0
	bl set_gpio_val

.endm @ gpio_25_0

.text

/*
 *
 */
term_blink:

	str lr, [sp], #-0x4

	@ Set GPIO mode
	mov r0, #GPIO_16	@ Specify GPIO number
	mov r1, #GPIO_OUT	@ Specify GPIO mode
	bl set_gpio_mode	@ Set mode to GPIO

	mov r0, #GPIO_24	@ Specify GPIO number
	mov r1, #GPIO_OUT	@ Specify GPIO mode
	bl set_gpio_mode	@ Set mode to GPIO

	mov r0, #GPIO_25	@ Specify GPIO number
	mov r1, #GPIO_OUT	@ Specify GPIO mode
	bl set_gpio_mode	@ Set mode to GPIO

	ldr r3, =DELAY @ 5M waiting cycles

	gpio_16_0
	gpio_24_0
	gpio_25_0

1:
	mov r0, r3
	bl delay

	gpio_16_1

	mov r0, r3
	bl delay

	gpio_16_0

@ *************

	mov r0, r3
	bl delay

	gpio_24_1

	mov r0, r3
	bl delay

	gpio_24_0

@ *************

	mov r0, r3
	bl delay

	gpio_25_1

	mov r0, r3
	bl delay

	gpio_25_0

	b 1b
