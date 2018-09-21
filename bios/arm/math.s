.text
.global uidiv_1


/*	Make unsigned integer division
 *	Input:	r0 - dividend
 *			r1 - divisor
 *	Return:	r0 - error
 *			r1 - integer part
 *			r2 - remainder
**/
uidiv_1: @ The first version of a devision function

	mul r2, r0, r1		@
	cmp r2, #0x0		@ Are divident and/or divisor zero?
	moveq r0, #0x1		@ Set error flag
	beq 2f			@ Go to exit
	mov r2, #0x0		@
	cmp r0, r1		@ Is dividend less than divisor
	movlt r2, r0		@ Prepare reminder of the result
	movlt r1, #0x0		@ Prepare quotient of the result
	blt 1f			@ Skip the subtraction loop
	loop:
	sub r0, r0, r1		@ Decrement dividend by disisor
	cmp r0, r1		@ Compare dividend and divisor

	@ Dividend is greater or equal to divisor
	addge r2, r2, #0x1	@ Increent quotient of division
	bge loop		@ Go to next iteration

	@ Dividend is less than divisor
	mov r1, r2		@ Prepare quotient of the result
	1:
	mov r2, r0		@ Prepare reminder of the result
	mov r0, #0x0	@ Result is OK

	2:
	mov pc, lr
