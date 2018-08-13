.text
.global setup_irq_vector, enable_irq, enable_timer_irq, disable_timer_irq

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

enable_irq:
    mrs r0, cpsr
    orr r0, #0x80
    msr cpsr, r0
    mov pc, lr

setup_irq_vector:
    mov r11, #0x00000000
    ldr r10, =ivt_start

	@ 		--->
    ldm r10!, {r0-r7}
    @		<---
    stm r11!, {r0-r7}

	@		--->
    ldm r10, {r0-r7}
    @		<---
    stm r11, {r0-r7}
    mov pc, lr

err_handler:
    b .

irq_handler:
    bl switch_leds
    subs pc, lr, #0x4

ivt_start:
.rept 6
    ldr pc, =err_handler
.endr
    ldr pc, =irq_handler
.rept 9
    ldr pc, =err_handler
.endr
