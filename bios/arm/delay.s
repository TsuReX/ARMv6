.text
.global wait_10m
@ Delay 10 miliseconds
wait_10m:
    str r0, [sp], #-0x4
    ldr r0, =10000000
	loop:
    subs r0, #0x1
    bne loop
    ldr r0, [sp, #0x4]!
    mov pc, lr
