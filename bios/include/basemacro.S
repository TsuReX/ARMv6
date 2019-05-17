
.macro save
	stmdb sp!, {r0-r12,lr}
	sub sp, sp, #0x4
.endm

.macro restore
	add sp, sp, #0x4
	ldmia sp!, {r0-r12,lr}
.endm

.macro return
	mov pc, lr
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
	ldr r4,=\func
	mov lr, pc		@ pc is current instruction address + 8
	bx r4
.endm

.macro ccall_prologue size
	mov r11, sp			@ Save stack frame
	mov r12, \size
	sub sp, r12			@ Reserve memory for arguments
	mvn r12, #0x7		@ r12 = ~0x7 = 0xFFFFFFF8
	and sp, r12			@ Align stack by 8
.endm

.macro ccall_epilogue
	mov sp, r11
.endm
