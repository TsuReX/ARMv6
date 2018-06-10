
.text
.global entry

entry:
    bl setup_stack
    bl setup_irq
    

    mrs r0, cpsr @ check bits of Mode, IRQ enabled

    b .


setup_stack:
    ldr sp, =usr_stack

    mov r0, #0xDF
    msr cpsr, r0
    ldr sp, =sys_stack
    
    mov r0, #0xD2
    msr cpsr, r0
    ldr sp, =irq_stack

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
    .word handler_hang
.endr
