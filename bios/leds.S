#include "ports.S"

.global gpio_test

.text

/*
 *
 */
gpio_test:

	str lr, [sp], #-0x4
	
	bl blink_led
	
	ldr lr, [sp, #0x4]!
	mov pc, lr

/*
 *
 */
blink_led:
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

	
	ldr r0, =5000000 @ 5M waiting cycles

	bl gpio_16_0
	bl delay
	bl gpio_16_1
	
	bl delay
	bl gpio_24_0
	bl delay
	bl gpio_24_1
	
	bl delay
	bl gpio_25_0
	bl delay
	bl gpio_25_1
	bl delay
	
	bl gpio_16_0
	bl gpio_24_0
	bl gpio_25_0
	
	ldr lr, [sp, #0x4]!
	mov pc, lr

	//*****************************/

	bl gpio_16_sw
	bl delay
	bl gpio_24_sw
	bl delay
	bl gpio_25_sw

	//****************************/

	ldr lr, [sp, #0x4]!
	mov pc, lr

gpio_16_1:
	
	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str lr, [sp], #-0x4
	
	mov r0, #GPIO_16	@ Specify GPIO number
	mov r1, #0x1		@ Specify GPIO value
	bl set_gpio_val		@ Set value to GPIO
	
	ldr lr, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!
	mov pc, lr

gpio_16_0:
	
	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str lr, [sp], #-0x4
	
	mov r0, #GPIO_16	@ Specify GPIO number
	mov r1, #0x0		@ Specify GPIO value
	bl set_gpio_val		@ Set value to GPIO
	
	ldr lr, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!
	
	mov pc, lr

gpio_16_sw:
	@ TODO
	mov pc, lr

gpio_24_1:
	
	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str lr, [sp], #-0x4
	
	mov r0, #GPIO_24
	mov r1, #0x1
	bl set_gpio_val
	
	ldr lr, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!
	mov pc, lr

gpio_24_0:
	
	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str lr, [sp], #-0x4
	
	mov r0, #GPIO_24
	mov r1, #0x0
	bl set_gpio_val
	
	ldr lr, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!
	mov pc, lr

gpio_24_sw:
	@ TODO
	mov pc, lr

gpio_25_1:
	
	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str lr, [sp], #-0x4
	
	mov r0, #GPIO_25
	mov r1, #0x1
	bl set_gpio_val
	
	ldr lr, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!
	mov pc, lr

gpio_25_0:
	
	str r0, [sp], #-0x4
	str r1, [sp], #-0x4
	str lr, [sp], #-0x4
	
	mov r0, #GPIO_25
	mov r1, #0x0
	bl set_gpio_val
	
	ldr lr, [sp, #0x4]!
	ldr r1, [sp, #0x4]!
	ldr r0, [sp, #0x4]!
	mov pc, lr

gpio_25_sw:
	@ TODO
	mov pc, lr
