.global delay

.text

/*
 * Make specified count of empty cycles
 * Input: r0 - count of waiting cylcles
 * Output:
 */
delay:
	str r1, [sp], #-0x4

	mov r1, r0
	cmp r1, #0x0
	beq exit
loop:
	sub r1,r1, #0x1
	bne loop

exit:
	ldr r1, [sp, #0x4]!
	mov pc, lr
