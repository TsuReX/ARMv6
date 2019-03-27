#include "ports.S"
#include "basemacro.S"

/* .include "ports.S"
 * This construction shouldn't be used.
 * ports.S is assebmler language source file which contains C preprocessor constructions,
 * the constructions are processed by C-preprocessor and pure assembler language source code file is generated,
 * but .include directive says to assembler to get NOT preprocessed file ports.S with C-preprocessor 
 * constructions what causes assembling error.
 * .include directive should be used for pure assebly language files only!
 */

.global entry

.macro setup_stacks

	@ Setup stacks pointer for all Operating modes
	@cps #SVC_MODE		@ Its unnecessary operation
	ldr sp, = __svc_stack	@ Supervisor
	cps #FIQ_MODE		@ Change processor state
	ldr sp, = __fiq_stack	@ FIQ
	cps #IRQ_MODE
	ldr sp, = __irq_stack	@ IRQ
	cps #ABT_MODE
	ldr sp, = __abt_stack	@ Abort
	cps #UND_MODE
	ldr sp, = __und_stack	@ Undefined
#ifdef RASPBERRY_PI1
	cps #MON_MODE
	ldr sp, = __mon_stack	@ Secure Monitor
#endif
	cps #SYS_MODE
	ldr sp, = __sys_stack	@ System

.endm

.macro check_ccall
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

.endm

.macro do_checking

	@ Check ccall macro
	check_ccall

	check_memcpy

	@ Check UART manipulation functions
	bl uart_test

	@ Check GPIO manipulation functions
	@ bl gpio_test

.endm

.macro print_regs

	bl print_cpsr
	bl print_spsr
	bl print_scr
	bl print_tcmsr
	bl print_midr
	bl print_ctr

.endm

.macro check_irq_vec

	save

	mov r0, #0x0
	mov r1, #0x10
	bl memprint

	ldr r0, =_func_ptrs_begin
	ldr r1, =_func_ptrs_end
	sub r1, r1, r0
	bl memprint

	restore

.endm

.macro check_memcpy

	save
@***************************************
@ Prepare memory area

	ccall_prologue #0

	ldr r0, =memtest_region_begin
	ldr r1, =0xFFFF0000
	ldr r2, =1024

	ccall memfillinc
	ccall_epilogue
@***************************************
	ldr r0, =memtest_region_begin
	ldr r2, =offset1
	add r0, r2

	mov r1, r0
	ldr r2, =offset3
	add r1, r2

	mov r2, #128
	bl memcpy
@***************************************
	ldr r0, =memtest_region_begin
	ldr r2, =offset2
	add r0, r2

	mov r1, r0
	ldr r2, =offset4
	add r1, r2

	mov r2, #7
	bl memcpy
	restore

.endm

.macro setup_exc

	@ Setup exceptions vector to 0x0
	mov r0, #0x0
	bl place_exc_vector

	ldr r0, =undef_handler
	bl setup_undef_handler

	ldr r0, =svc_smc_handler
	bl setup_svc_smc_handler

	ldr r0, =pabt_handler
	bl setup_pabt_handler

	ldr r0, =dabt_handler
	bl setup_dabt_handler

	ldr r0, =irq_handler
	bl setup_irq_handler

	ldr r0, =fiq_handler
	bl setup_fiq_handler

	@ TODO Enable exceptions
	bl enable_irq @ TODO What does it do?

.endm

.equ offset1, 0
.equ offset2, 3
.equ offset3, 1024
.equ offset4, 2051

.data
arg_array_src:
s4:			.word 0x00010002, 0x00020003
s5:			.word 0x00030004, 0x00040005
s6:			.word 0x00050006, 0x00060007
s7:			.word 0x00070008, 0x00080009

arg_array_dst:
d4:			.word 0x88888888, 0x77777777
d5:			.word 0x66666666, 0x55555555
d6:			.word 0x44444444, 0x33333333
d7:			.word 0x22222222, 0x11111111

arg_array_res:
res4:			.word 0x00010002, 0x00020003
res5:			.word 0x00030004, 0x00000000
res6:			.word 0x00050006, 0x00060007
res7:			.word 0x00070008, 0x00000000

.org 1024
memtest_region_begin:
.word	0x01020304
.rept   4094
.word	0xEEEEEEEE
.endr
.word	0x50607080
memtest_region_end:

.text

/*
 * Entry point
 */
entry:

@1	@ The system is now in Supervisor mode
	setup_stacks
	@ The system now is in System mode - working mode
	do_checking
	@ Print registers
@	print_regs
	@ Setup default exceptions' handlers
	setup_exc

1:
	b 1b
	@ Check timer

	bl enable_irq
	bl enable_timer_irq
	bl setup_timer
	ldr r0, =0xFFFF
	bl set_timer_value
	bl enable_timer

2:
	b 2b
	/* !!!!!!!!!!!!  */
	ccall stub_func /* Important to be confident that project can be built with .S and .c files */
