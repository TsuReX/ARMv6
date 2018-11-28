#include "ports.S"

.global gpio_test

.text

/*
 *
 *
 */
gpio_test:
	str lr, [sp], #-0x4
	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str r2, [sp], #-0x4

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

	@ 1. Loop
	loop:			@@ Begin loop

	@ Set value for 24th gpio
	mov r0, #GPIO_22
	bl get_gpio_val

	mov r0, #0x22
	bl uart_send
	mov r0, r1
	bl uart_send

	cmp r1, #0x1
	moveq r1, #0x1
	movne r1, #0x0
	mov r0, #GPIO_24
	bl set_gpio_val

	@ Set value for 25th gpio
	mov r0, #GPIO_23
	bl get_gpio_val

	mov r0, #0x23
	bl uart_send
	mov r0, r1
	bl uart_send

	cmp r1, #0x1
	moveq r1, #0x1
	movne r1, #0x0
	mov r0, #GPIO_25

	bl set_gpio_val

	@ Change value of 16th gpio
	mov r0, #GPIO_16
	bl inv_gpio_val

	mov r0, #GPIO_27
	bl get_gpio_val		@ Load GPIO_27 val into r1, r0 is error code

	mov r0, #0x27
	bl uart_send
	mov r0, r1
	bl uart_send

	@ TODO Debug output r1 via UART

	mov r0, r2
	bl delay

	cmp r1, #0x1		@ Check control gpio value
	bne loop		@@ End loop

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

	ldr r2, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!
	ldr lr, [sp, #0x4]!
	mov pc, lr
