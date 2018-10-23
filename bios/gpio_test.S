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

	ldr r2, =5000000	@ 5M waiting cycles

	loop:			@@ Begin loop
	
	mov r0, #GPIO_27
	bl get_gpio_val		@ Load GPIO_27 val into r1, r0 is error code
	@mov r0, #0x1
	@cmp r0, r1
	cmp r1, #0x1		@ Check control gpio value
	mov r0, r2
	bl delay
	beq loop		@@ End loop

	@ 1. Delay
	mov r0, r2
	bl delay

	@ 2. Set all GPIOs into low
	mov r1, #0x0

	mov r0, #GPIO_16
	bl set_gpio_val

	mov r0, #GPIO_24
	bl set_gpio_val

	mov r0, #GPIO_25
	bl set_gpio_val

	@ 3. Delay
	mov r0, r2
	bl delay

	@ 4. Set all GPIOs into high
	@ Toggle value but not switch on
	mov r0, #GPIO_16
	bl inv_gpio_val

	mov r0, #GPIO_24
	bl inv_gpio_val

	mov r0, #GPIO_25
	bl inv_gpio_val

	@ 5. Delay
	mov r0, r2
	bl delay

	@ 6. Set all GPIOs into low
	mov r1, #0x0

	mov r0, #GPIO_16
	bl set_gpio_val

	mov r0, #GPIO_24
	bl set_gpio_val

	mov r0, #GPIO_25
	bl set_gpio_val

	ldr lr, [sp, #0x4]!
	mov pc, lr