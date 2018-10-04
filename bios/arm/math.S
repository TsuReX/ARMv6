.global uidiv_1

.text

/*	Make unsigned integer division
 *	Input:	r0 - Dividend value
 *		r1 - Divisor value
 *	Return:	r0 - Error value
 *		r1 - Integer part value
 *		r2 - Remainder value
**/
uidiv_1: @ The first version of a devision function

	cmp r1, #0x0		@ Is divisor zero?
	moveq r0, #0x1		@ Set error flag
	beq 2f			@ Go to exit

	cmp r0, #0x0		@ Is dividend zero?
	moveq r1, #0x0		@ Set integer part as zero
	moveq r2, #0x0		@ Set remainder value as zero
	beq 2f			@ Go to exit
	
	cmp r0, r1		@ Is dividend less than divisor
	movlt r2, r0		@ Prepare remainder of the result
	movlt r1, #0x0		@ Prepare quotient of the result
	movlt r0, #0x0		@ OK
	blt 2f			@ Skip the subtraction loop
	
	mov r2, #0x0		@
	
	loop:
	sub r0, r0, r1		@ Decrement dividend by disisor
	cmp r0, r1		@ Compare dividend and divisor
	add r2, r2, #0x1	@ Increent quotient of division
	
	@ Dividend is greater or equal to divisor
	bge loop		@ Go to next iteration

	@ Dividend is less than divisor
	mov r1, r2		@ Prepare quotient of the result
	
	mov r2, r0		@ Prepare reminder of the result
	mov r0, #0x0		@ Result is OK

	2:
	mov pc, lr
