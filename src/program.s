section .somesect
	somedata dq 0xAABBCCFF

section .mysection
	data dd 0xDEADBEAF

section .data						;section declaration
	msg db      "Hello, world!",0xa ;our dear string
	len equ     $ - msg             ;length of our dear string


section .text					;section declaration

								;we must export the entry point to the ELF linker or
    global  _start				;loader. They conventionally recognize _start as their
								;entry point. Use ld -e foo to override the default.

;*************************************************

printstr:						;write our string to stdout
	mov		rcx, [rsp+0x8]		;get first operand value from stack
	mov		rdx, [rsp+0x10]		;get second operand value from stack
    mov     rbx,1				;first argument: file handle (stdout)
    mov     rax,4				;system call number (sys_write)
    int     0x80				;call kernel
								;return value is stored in rax		???????????????????????????????????
	ret							;return from printstr, return value shuld be stored in rax

;*************************************************

calclen:
	mov		rax, [rsp+0x8]		;get operand value from stack
	mov		rbx, rax
nextchar:						;this is the same as lesson3
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar
finished:
	sub		rax, rbx

	ret							;return from calclen, return value shuld be stored in rax

;*************************************************

_start:
	; cdecl calling convention begin
	push    rbp       			;save old call frame
	mov     rbp, rsp			;to avoid problem with stack pointer

	mov		rax, msg			;get data pointer
	push	rax					;save data pointer in stack
	call	calclen				;return value shuld be stored in rax

	mov     rsp, rbp			;restore old call frame
	pop		rbp					;
	; cdecl calling convention end

	; cdecl calling convention begin
	push    rbp       			;save old call frame
    mov     rbp, rsp			;to avoid problem with stack pointer

	push	rax					;save operands in reverse order
	mov		rbx, msg			;
	push	rbx					;
	call	printstr			;operands are: data pointer, length in bytes

	mov     rsp, rbp			;restore old call frame
	pop		rbp					;
	; cdecl calling convention end

								;and exit

  	mov     rbx,0				;first syscall argument: exit code
    mov     rax,1				;system call number (sys_exit)
    int     0x80				;call kernel

;*************************************************
