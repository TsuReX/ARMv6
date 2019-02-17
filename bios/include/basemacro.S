
.macro save
	stmdb sp!, {r0-r12,lr}
	sub sp, sp, #0x4
.endm

.macro restore
	add sp, sp, #0x4
	ldmia sp!, {r0-r12,lr}
.endm

.macro fiq_save
	stmdb sp!, {r0-r7,lr}
	sub sp, sp, #0x4
.endm

.macro fiq_restore
	add sp, sp, #0x4
	ldmia sp!, {r0-r7,lr}
.endm

.macro ccall func
	stmed sp!, {r0-r14}

	and r2, sp, #0x7	@ Mask stack address to calc alignment

	mov r1, #0x0		@ If r1 == 0 that's  sp is aligned 
	cmp r2, r1

	la r3, \func

	beq 1f
	b 2f

1:	ldr lr, =4f		@ Aligned stack by 8
	bx r3

2:	sub sp, #0x4		@ Not aligned stack by 8
	mov lr, pc		@ pc is current instruction address + 8
	bx r3

3:	add sp, #0x4

4:	ldmed sp!, {r0-r14}
.endm
