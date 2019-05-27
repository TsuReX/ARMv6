#include <basemacro.S>
#include <assert.S>
#include <gpio_io.inc.S>

.global check
 
.equ 	src1, 0
.equ 	dst1, 1281
.equ 	src2, 9
.equ 	dst2, 2080

.equ 	count1, 1017
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

	@ 28 is incorrect value, 
	@ it must be 32 - 4 arguments aligned by 8 bytes.
	@ But this mistake was made especially 
	@ for testing of stack alignment mechanism before function call.
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
	return
@check_ccall

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

@***************************
@ Copying case 1

	ccall_prologue #0

	ldr r2, =memtest_region_begin
	ldr r0, =dst1
	add r0, r2

	ldr r1, =src1
	add r1, r2

	ldr r2, =count1

	ccall memcpy
	ccall_epilogue

@***************************
@ Copying case 2

	ccall_prologue #0

	ldr r2, =memtest_region_begin
	ldr r0, =dst2
	add r0, r2

	ldr r1, =src2
	add r1, r2

	ldr r2, =count2
	ccall memcpy

	ccall_epilogue

	restore
	return
@check_memcpy

.equ VAL1,		0x1
.equ VAL2,		0x2
.equ VAL3,		0x4
.equ R0, 		r0
.equ CMP_VAL1, 	0x1
.equ CMP_VAL2, 	0x3
.equ CMP_VAL3, 	0x4
.equ EQ_VAL1,	0xA
.equ EQ_VAL2,	0xB
.equ NEQ_VAL,	0xC

do_check_assert:
	save

@ 1	Should display EQ_VAL1 and stop
	ldr r0, =VAL1
	ASSERT_POST R0 CMP_VAL1 EQ_VAL1 NEQ_VAL STOP

@ 2	Should display NEQ_VAL and stop
	ldr r0, =VAL2
	ASSERT_POST R0 CMP_VAL2 EQ_VAL1 NEQ_VAL STOP

@ 3	Should display EQ_VAL2 and not stop
	ldr r0, =VAL2
	ASSERT_POST R0 CMP_VAL3 EQ_VAL2 NEQ_VAL NOSTOP

	DELAY 10000000

	restore
	return
@do_check_assert

do_check_post:
	save
	POST 0x1
	DELAY 10000000

	POST 0x2
	DELAY 10000000

	POST 0x4
	DELAY 10000000

	POST 0x8
	DELAY 10000000

	POST 0x10
	DELAY 10000000

	POST 0x20
	DELAY 10000000

	POST 0x40
	DELAY 10000000

	POST 0x80
	DELAY 10000000

	POST 0xFF
	DELAY 10000000

	restore
	return
@do_check_post

do_checking:
	save

@ 0 Check post
	bl do_check_post

@ 1 Check ASSERT_POST
	bl do_check_assert

@ 2 Check ccall macro
	bl check_ccall

@ 3 Check memcpy
	bl check_memcpy

@ 4 Check UART manipulation functions
	bl uart_test

	restore
	return
@do_checking

check:
	save

	bl do_checking

	restore
	return
@check
