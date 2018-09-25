.text
.global blink_led, switch_leds
blink_led:
    str lr, [sp], #-0x4

	bl wait_10m

	bl gpio_16_0
    bl wait_10m
    bl gpio_16_1

    bl wait_10m

    bl gpio_24_0
    bl wait_10m
    bl gpio_24_1

	bl wait_10m

    bl gpio_25_0
	bl wait_10m
    bl gpio_25_1

	bl wait_10m

    bl gpio_16_0
    bl gpio_24_0
    bl gpio_25_0

	//*****************************

	ldr r0, =0x20200000
    ldr r2, =0x10000
    ldr r1, [r0, #0x1C]
    and r1, r2
    cmp r1, r2
    blne gpio_24_1

    b .

    mvn r3, r1
    and r3, r2
    str r3, [r0, #0x1C]
    and r1, r2
    str r1, [r0, #0x28]


    bl gpio_16_sw
	bl wait_10m
    bl gpio_24_sw
	bl wait_10m
    bl gpio_25_sw

	//*****************************

    ldr lr, [sp, #0x4]!
    mov pc, lr

gpio_16_1:
    ldr r0, =0x20200000
    ldr r1, =0x10000
    str r1, [r0, #0x1C]
    mov pc, lr

gpio_16_0:
    ldr r0, =0x20200000
    ldr r1, =0x10000
    str r1, [r0, #0x28]
    mov pc, lr

gpio_16_sw:
    ldr r0, =0x20200000
    ldr r2, =0x10000
    ldr r1, [r0, #0x1C]
    mvn r3, r1
    and r3, r2
    str r3, [r0, #0x1C]
    and r1, r2
    str r1, [r0, #0x28]
    mov pc, lr

gpio_24_1:
    ldr r0, =0x20200000
    ldr r1, =0x1000000
    str r1, [r0, #0x1C]
    mov pc, lr

gpio_24_0:
    ldr r0, =0x20200000
    ldr r1, =0x1000000
    str r1, [r0, #0x28]
    mov pc, lr

gpio_24_sw:
    ldr r0, =0x20200000
    ldr r2, =0x1000000
    ldr r1, [r0, #0x1C]
    mvn r3, r1
    and r3, r2
    str r3, [r0, #0x1C]
    and r1, r2
    str r1, [r0, #0x28]
    mov pc, lr

gpio_25_1:
    ldr r0, =0x20200000
    ldr r1, =0x2000000
    str r1, [r0, #0x1C]
    mov pc, lr

gpio_25_0:
    ldr r0, =0x20200000
    ldr r1, =0x2000000
    str r1, [r0, #0x28]
    mov pc, lr

gpio_25_sw:
    ldr r0, =0x20200000
    ldr r2, =0x2000000
    ldr r1, [r0, #0x1C]
    mvn r3, r1
    and r3, r2
    str r3, [r0, #0x1C]
    and r1, r2
    str r1, [r0, #0x28]
    mov pc, lr

switch_leds:
    str lr, [sp]
    bl gpio_16_sw
    bl gpio_24_sw
    bl gpio_25_sw
    mov pc, lr
    ldr lr, [sp]

//******************************************************************//
