readstr: ;function

	mov		edx, [rsp + 0x8]	;number of bytes to read
	mov		ecx, [rsp + 0x10]	;reserved space to store our input (known as a buffer)
	mov		ebx, 0				;write to the STDIN file
	mov		eax, 3				;invoke SYS_READ (kernel opcode 3)
	int		80h
	ret

;*************************************************

printstr: ;function				;write our string to stdout
	mov		rcx, [rsp+0x8]		;get first operand value from stack
	mov		rdx, [rsp+0x10]		;get second operand value from stack
    mov		rbx,1				;first argument: file handle (stdout)
    mov		rax,4				;system call number (sys_write)
    int		0x80				;call kernel, return value is stored in rax
	ret							;return from printstr, return value shuld be stored in rax

;*************************************************

calclen: ;function
	mov		rax, [rsp+0x8]		;get operand value from stack
	mov		rbx, rax
.nextchar:						;"." before name of label means that this labes is local for calclen function
    cmp		byte [rax], 0
    jz		.finished
    inc		rax
    jmp		.nextchar
.finished:
	sub		rax, rbx
	ret							;return from calclen, return value shuld be stored in rax

;*************************************************
