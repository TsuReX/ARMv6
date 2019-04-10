#include "printreg.h"

.macro  print type, reg

        save

        mov r0, \reg
        ldr r1, =REG
		ldr r2, =\type

		ccall_prologue #0
		ccall memprint
		ccall_epilogue

        restore
.endm

.macro  print_val val

        save

        ldr r0, \val
        ldr r1, =REG
		ldr r2, =VAL

		ccall_prologue #0
		ccall memprint
		ccall_epilogue

        restore
.endm
