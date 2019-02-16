
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
	la r10, \func
	mov lr, pc
	bx r10
	ldmed sp!, {r0-r14}
.endm
