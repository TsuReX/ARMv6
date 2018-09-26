.global delay

.text

/*
 * Make specified count of empty cycles
 * Input: r0 - count of waiting cylcles
 * Output:
 */
delay:
	cmp r0, #0x0
	beq exit
loop:
	sub r0,r0, #0x1
	bne loop
exit:
	mov pc, lr
