/*
 *
 */
.macro POST VAL

	CCALL_PROLOGUE #0

	ldr r0, =\VAL

	CCALL post

	CCALL_EPILOGUE

.endm
