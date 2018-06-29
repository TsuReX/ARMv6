.global entry
.text
entry:
    // System is now in Svc mode
    
    // Setup Sys mode
    mrs r0, cpsr
    and r0, #0xFFFFFFE0
    add r0, #0x1F    
    msr cpsr, r0

    bl setup_stack
    
    bl setup_irq

    bl enable_irq
    
    bl setup_gpio

    bl enable_timer_irq

    bl enable_timer
    
    b .


enable_irq:
    mrs r0, cpsr
    ldr r1, =0xFFFFFF7F
    and r0, r1
    msr cpsr, r0
    mov pc, lr

switch_led:
    ldr r0, =0x7E200010
    ldr r1, [r0] 
    mov r2, #0x10000
    eor r1, r2
    str r1, [r0]
    mov pc, lr


setup_gpio:
    //Select GPIO 16 as output     
    mov r0, #0x1
    mov r0, r0, lsl #0x12 @ mov r0, 0x40000
    //GPFSEL1
    //ldr r1, =0xFFFFFFC
    ldr r1, =0x7E200004
    str r0, [r1]
    
    mov pc, lr
    
    mov r0, r0, lsr #0x2
    //GPSET0
    //ldr r1, =0x10000000
    ldr r1, =0x7E200010
    str r0, [r1]
    
    //GPCLR1
    //ldr r1, =0x8
    ldr r1, =0x7E200028
    str r0, [r1]
    
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
    ldr r0, =0x7E0B0400
    ldr r1, =0xF4240
    str r1, [r0]	@ Load 1.000.000 into the counter register
    ldr r0, =0x7E0B0408
    ldr r1, [r0]
    mov r2, #0xA2
    orr r1, r2
    str r1, [r0]	@ Set Timer enable, Timer interrupt enable, 23-bit counter set
    mov pc, lr

enable_timer_irq:
    ldr r0, =0x7E0B0218
    ldr r1, [r0]
    orr r1, #0x1
    str r1, [r0]
    mov pc, lr

disable_timer_irq:
    ldr r0, =0x7E0B0218
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
    bl switch_led
    subs pc, lr, #0x4


ivt_start:
.rept 6
    ldr pc, [pc, #0x18]
.endr
    ldr pc, =irq_handler

.rept 9
    ldr pc, =err_handler
.endr
