; The program was written with NASM language
section .somesect
	somedata dq 0xAABBCCFF

section mysection				;section name can be without preceding "."
	data dd 0xDEADBEAF
	q	db	0x51                ; просто байт 0x55
	w	db	0x52,0x56,0x57      ; последовательно 3 байта
	e	db	'a',0x53            ; символьная константа
	r	db	'hello',13,10,'$'   ; это строковая константа
	t	dw	0x1234              ; 0x34 0x12
	y	dw	'a'                 ; 0x41 0x00 (это просто число)
	u	dw	'ab'                ; 0x41 0x42 (символьная константа)
	i	dw	'abc'               ; 0x41 0x42 0x43 0x00 (строка)
	o	dd	0x12345678          ; 0x78 0x56 0x34 0x12

section .bss
	varNameByte:		resb	1	;reserve space for 1 byte
	varNameWord:		resw	2	;reserve space for 2 words
	varNameDWord:		RESd	3	;reserve space for 3 double words
	varNameDPFloat:		resQ	4	;reserve space for 4 double precision floats (quad word)
	varNameXPFloat:		ReSt	5	;reserve space for 5 extended precision floats

	sinput:				resb	255


section .data						;section declaration
	;our string, or if to be simplier this's an array of bytes (db - data byte)
	msg db		"Please enter any string!",0xA,0x0
	;length of string
	len equ		$ - msg

section .text					;section declaration
								;we must export the entry point to the ELF linker or
	global  entryPoint			;loader. They conventionally recognize _start as their
								;entry point. Use ld -e foo to override the default.

;*************************************************

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
nextchar:						;this is the same as lesson3
    cmp		byte [rax], 0
    jz		finished
    inc		rax
    jmp		nextchar
finished:
	sub		rax, rbx
	ret							;return from calclen, return value shuld be stored in rax

;*************************************************

entryPoint: ;Default entry point name is _start. User defined name should be pointed via
			;gcc -g -o ./build/program ./build/program.o -nostdlib -e entryPoint
			;or
			;ld -g -o ./build/program ./build/program.o -nostdlib -e entryPoint
	; cdecl calling convention begin
	push	rbp       			;save old call frame
	mov		rbp, rsp			;to avoid problem with stack pointer
	mov		rax, msg			;get data pointer
	push	rax					;save data pointer in stack
	call	calclen				;return value shuld be stored in rax
	mov		rsp, rbp			;restore old call frame
	pop		rbp					;
	; cdecl calling convention end

	; cdecl calling convention begin
	push	rbp       			;save old call frame
	mov		rbp, rsp			;to avoid problem with stack pointer
	push	rax					;save operands in reverse order
	mov		rbx, msg			;
	push	rbx					;
	call	printstr			;operands are: data pointer, length in bytes
	mov		rsp, rbp			;restore old call frame
	pop		rbp					;
	; cdecl calling convention end

	push	rbp
	mov		rbp, rsp
	mov		rax, sinput
	push	rax
	push	255
	call	readstr
	mov		rsp, rbp
	pop		rbp

	; cdecl calling convention begin
	push	rbp       			;save old call frame
	mov		rbp, rsp			;to avoid problem with stack pointer
	mov		rax, sinput			;get data pointer
	push	rax					;save data pointer in stack
	call	calclen				;return value shuld be stored in rax
	mov		rsp, rbp			;restore old call frame
	pop		rbp					;
	; cdecl calling convention end

	; cdecl calling convention begin
	push	rbp       			;save old call frame
	mov		rbp, rsp			;to avoid problem with stack pointer
	push	rax					;save operands in reverse order
	mov		rbx, sinput			;
	push	rbx					;
	call	printstr			;operands are: data pointer, length in bytes
	mov		rsp, rbp			;restore old call frame
	pop		rbp					;
	; cdecl calling convention end

								;and exit
	mov		rbx,0				;first syscall argument: exit code
	mov		rax,1				;system call number (sys_exit)
	int		0x80				;call kernel, return value is stored in rax

;*************************************************
