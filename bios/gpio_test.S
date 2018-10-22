#include "ports.S"

.global gpio_test

.text

/*
 *
 *
 */
gpio_test:
	str lr, [sp], #-0x4
	
	mov r0, #GPIO_16
	mov r1, #GPIO_OUT
	bl set_gpio_mode

	mov r0, #GPIO_22
	mov r1, #GPIO_IN
	bl set_gpio_mode

	mov r0, #GPIO_23
	mov r1, #GPIO_IN
	bl set_gpio_mode

	mov r0, #GPIO_24
	mov r1, #GPIO_OUT
	bl set_gpio_mode

	mov r0, #GPIO_25
	mov r1, #GPIO_OUT
	bl set_gpio_mode

	mov r0, #GPIO_27
	mov r1, #GPIO_IN
	bl set_gpio_mode

	ldr r0, =5000000 @ 5M waiting cycles

	loop:			@@ Begin loop
	
	mov r0, #GPIO_27
	bl get_gpio_val		@ Load GPIO_27 val into r1, r0 is error code
	@mov r0, #0x1
	@cmp r0, r1
	cmp r1, #0x1		@ Check control gpio value
	beq loop		@@ End loop

	@ 1. Delay

	@ 2. Set all GPIOs into low

	@ 3. Delay

	@ 4. Set all GPIOs into high
	@ Toggle value but not switch on

	@ 5. Delay

	@ 6. Set all GPIOs into low

	ldr lr, [sp, #0x4]!
	mov pc, lr