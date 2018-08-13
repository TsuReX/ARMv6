.global entry
.text
entry:

    // System is now in Svc mode
    
    // Setup Sys mode
    mrs r0, cpsr
    and r0, #0xFFFFFFE0
    orr r0, #0x1F    
    msr cpsr, r0
    
    bl setup_stack
    bl read_ns_bit
    bl setup_gpio
    bl setup_irq_vector
    bl enable_irq
    @bl enable_timer_irq
    @bl enable_timer

    bl blink_led
    
    b .

//******************************************************************//


@ Read Non-secure bit from the coprocessor register
@ Return r0
read_ns_bit:
    mcr p15, 0, r0, c1, c1, 0
    mov pc, lr


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

	@ TODO Setup FIQ, SVC stacks
    // Setup IRQ mode
    add r1, r0, #0x12
    msr cpsr, r1
    ldr sp, =__irq_stack
    
    // Setup Sys mode
    add r1, r0, #0x1F
    msr cpsr, r1
    ldr sp, =__usr_stack

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

