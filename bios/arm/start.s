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
    
    bl test_gpio
    
    b .

test_gpio:
    //Select GPIO 16 as output     
    mov r0, #0x1
    mov r0, r0, lsl #0x12 @ mov r0, 0x40000
    //GPFSEL1
    ldr r1, =0x3E200004
    str r0, [r1]
    
    
    mov r0, r0, lsr #0x2
    //GPSET0
    ldr r1, =0x3E200010
    str r0, [r1]
    
    //GPCLR1
    ldr r1, =0x3E200028
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

    subs pc, lr, #0x4


ivt_start:
.rept 6
    ldr pc, [pc, #0x18]
.endr
    ldr pc, =irq_handler

.rept 9
    ldr pc, =err_handler
.endr
