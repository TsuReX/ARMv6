.macro DELAY DELAY_TIME
	ldr r0, =\DELAY_TIME
	bl delay
.endm
