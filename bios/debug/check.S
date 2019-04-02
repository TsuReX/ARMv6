#include "basemacro.S"

.global check
 
.equ 	src1, 0
.equ 	dst1, 1281
.equ 	src2, 2049
.equ 	dst2, 2080

.equ 	count1, 1027
.equ 	count2, 7

.equ 	filler, 0xFFFF0000
.equ 	count, 256

.data

arg_array_src:
s4:		.word 0x00010002, 0x00020003
s5:		.word 0x00030004, 0x00040005
s6:		.word 0x00050006, 0x00060007
s7:		.word 0x00070008, 0x00080009

arg_array_dst:
d4:		.word 0x88888888, 0x77777777
d5:		.word 0x66666666, 0x55555555
d6:		.word 0x44444444, 0x33333333
d7:		.word 0x22222222, 0x11111111

arg_array_res:
res4:	.word 0x00010002, 0x00020003
res5:	.word 0x00030004, 0x00000000
res6:	.word 0x00050006, 0x00060007
res7:	.word 0x00070008, 0x00000000

.org 1024

memtest_region_begin:
		.word	0x01020304

		.rept   4094
		.word	0xEEEEEEEE
		.endr

		.word	0x50607080
memtest_region_end:

@ End .data

.text

check_ccall:

	save

	@ Stack alignment case 1

	ccall_prologue #28

	@ Form first register arguments

	ldr r0, =arg_array_src
	ldr r1, =arg_array_dst
	ldr r2, =0x87654321
	ldr r3, =0x789ABCDE

	@ Form remaining stack arguments

	ldrd r4, [r0, #0x00]	@ Load into r7-r8 4th argument
	strd r4, [sp, #0x00]	@ Save 4th argument

	ldr r4, [r0, #0x08]		@ Load into r7-r8 5th argument
	str r4, [sp, #0x08]		@ Save 5th argument

	ldrd r4, [r0, #0x10]	@ Load into r7-r8 6th argument
	strd r4, [sp, #0x10]	@ Save 6th argument

	ldr r4, [r0, #0x18]		@ Load into r7-r8 7th argument
	str r4, [sp, #0x18]		@ Save 7th argument

	ccall c_test_1

	ccall_epilogue

	add r0, r1
	ldr r1, =0xFFFFFFFF
	cmp r0, r1
	bne failed1	

	@ ***********************************************

	@ Stack alignment case 1

	sub sp, #0x4

	ccall_prologue #0

	ldr r0, =arg_array_src
	ldr r1, =arg_array_dst
	ldr r2, =arg_array_res
	mov r3, #0x8

	ccall c_test_2

	ccall_epilogue

	ldr r1, =0xBABADEDA
	cmp r0, r1
	bne failed2

	b ok

failed1:
	b failed1

failed2:
	b failed2

ok:
	add sp, #0x4
	restore
	mov pc, lr
	
@ check_ccall

check_irq_vec:

	save

	mov r0, #0x0
	mov r1, #0x10
	bl memprint

	ldr r0, =_func_ptrs_begin
	ldr r1, =_func_ptrs_end
	sub r1, r1, r0
	bl memprint

	restore
	mov pc, lr

@ check_irq_vec

check_memcpy:

	save
@***************************************
@ Prepare memory area

	ccall_prologue #0

	ldr r0, =memtest_region_begin
	ldr r1, =filler
	ldr r2, =count

	ccall memfillinc
	ccall_epilogue

@***************************************
@ Copying case 1

	ldr r0, =memtest_region_begin
	ldr r2, =src2
	add r0, r2

	mov r1, r0
	ldr r2, =dst1
	add r1, r2

	ldr r2, =count1
	bl memcpy

@***************************************
@ Copying case 2

	ldr r0, =memtest_region_begin
	ldr r2, =src2
	add r0, r2

	mov r1, r0
	ldr r2, =dst2
	add r1, r2

	ldr r2, =count2
	bl memcpy

	restore
	mov pc, lr

@ check_memcpy

do_checking:

	save

	@ Check ccall macro
	bl check_ccall

	bl check_memcpy

	@ Check UART manipulation functions
	bl uart_test

	@ Check GPIO manipulation functions
	@ bl gpio_test

	restore
	mov pc, lr

@do_checking

check:
	save
	
	bl do_checking
	
	restore
	mov pc, lr
