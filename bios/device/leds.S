#include "ports.S"

.global term_blink

.equ 	DELAY, 5000000

.macro gpio_mode num mode
	mov r0, #\num		@ Specify GPIO number
	mov r1, #\mode		@ Specify GPIO mode
	bl set_gpio_mode	@ Set mode to GPIO
.endm

.macro gpio num val

	mov r0, #\num		@ Specify GPIO number
	mov r1, #\val		@ Specify GPIO value
	bl set_gpio_val		@ Set value to GPIO

.endm @ gpio

.macro led num val

	mov r0, #\num
	mov r1, #\val
	bl set_gpio_val	

.endm @ led

.macro blink_led num delay

	ldr r0, =\delay
	bl delay

	led \num, LED_ON

	ldr r0, =\delay
	bl delay

	led \num, LED_OFF
	
.endm @ led

.text

/*
 *
 */
term_blink:

	str lr, [sp], #-0x4

	gpio_mode LED_0, GPIO_OUT
	gpio_mode LED_1, GPIO_OUT
	gpio_mode LED_2, GPIO_OUT
	gpio_mode LED_3, GPIO_OUT
	gpio_mode LED_4, GPIO_OUT
	gpio_mode LED_5, GPIO_OUT
	gpio_mode LED_6, GPIO_OUT
	gpio_mode LED_7, GPIO_OUT

	led LED_0, LED_OFF
	led LED_2, LED_OFF
	led LED_3, LED_OFF
	led LED_4, LED_OFF
	led LED_5, LED_OFF
	led LED_6, LED_OFF
	led LED_7, LED_OFF

1:
	blink_led LED_0, DELAY
	blink_led LED_1, DELAY
	blink_led LED_2, DELAY
	blink_led LED_3, DELAY
	blink_led LED_4, DELAY
	blink_led LED_5, DELAY
	blink_led LED_6, DELAY
	blink_led LED_7, DELAY

	b 1b
