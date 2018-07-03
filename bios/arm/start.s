.global entry
.text
entry:

    // System is now in Svc mode
    
    // Setup Sys mode
    mrs r0, cpsr
    and r0, #0xFFFFFFE0
    orr r0, #0x1F    
    msr cpsr, r0
    
    bl setup_gpio
    
    bl gpio_16_1

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

    

    bl gpio_24_1

    bl gpio_25_1

    
    bl gpio_16_1

    bl gpio_24_0

    bl gpio_25_0


    bl gpio_16_0

    bl gpio_24_1

    bl gpio_25_1

    
    //bl gpio_16_sw

    //bl gpio_24_sw

    //bl gpio_25_sw


    b .

    bl setup_stack
    
    bl setup_irq

    bl enable_irq
    
    bl enable_timer_irq

    bl enable_timer
    
    b .


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

enable_irq:
    mrs r0, cpsr
    orr r0, #0x80
    msr cpsr, r0
    mov pc, lr

switch_leds:
    str lr, [sp]
    bl gpio_16_sw
    bl gpio_24_sw
    bl gpio_25_sw
    mov pc, lr
    ldr lr, [sp]

setup_gpio:
    ldr r0, =0x20200000
    ldr r1, =0x40000
    str r1, [r0, #0x4]
    ldr r1, =0x9000
    str r1, [r0, #0x8]
    mov pc, lr
    
setup_stack:
    mrs r0, cpsr
    and r0, #0xFFFFFFE0

    // Setup IRQ mode
    add r1, r0, #0x12
    msr cpsr, r1
    ldr sp, =irq_stack
    
    // Setup Sys mode
    add r1, r0, #0x1F
    msr cpsr, r1
    ldr sp, =usr_stack

    mov pc, lr

enable_timer:
    ldr r0, =0x202B0400
    ldr r1, =0xF4240
    str r1, [r0]	@ Load 1.000.000 into the counter register
    ldr r0, =0x202B0408
    ldr r1, [r0]
    mov r2, #0xA2
    orr r1, r2
    str r1, [r0]	@ Set Timer enable, Timer interrupt enable, 23-bit counter set
    mov pc, lr

enable_timer_irq:
    ldr r0, =0x202B0218
    ldr r1, [r0]
    orr r1, #0x1
    str r1, [r0]
    mov pc, lr

disable_timer_irq:
    ldr r0, =0x202B0218
    ldr r1, [r0]
    and r1, #0xFFFFFFFE
    str r1, [r0]
    mov pc, lr


setup_irq:
    ldr r11, =0x00000000
    ldr r10, =ivt_start

    ldm r10!, {r0-r7}
    stm r11!, {r0-r7}

    ldm r10, {r0-r7}
    stm r11, {r0-r7}
    mov pc, lr

err_handler:
    b .

irq_handler:
    bl switch_leds
    subs pc, lr, #0x4

//.section .ivt
ivt_start:
.rept 6
    //ldr pc, [pc, #0x18]
    b .
.endr
    ldr pc, =irq_handler

.rept 9
    ldr pc, =err_handler
.endr
