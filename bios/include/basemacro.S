
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

	ldr r4,=\func
	mov lr, pc		@ pc is current instruction address + 8
	bx r4

.endm

.macro ccall_prologue size
	
	mov r11, sp			@ Save stack frame
	
	mov r0, \size
	sub sp, r0			@ Reserve memory for arguments
		
	ldr r0, =0xFFFFFFF8	@ Alignment mask
	mov r2, #0x0
	and r1, sp, #0x7	@ Is alignment by 8?
	cmp r1, r2
	andne sp, r0		@ Align stack by 8
	
.endm

.macro ccall_epilogue
	
	mov sp, r11
	
.endm
