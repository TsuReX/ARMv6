; The program was written with NASM language

%include 'src/functions.s'

section .somesect
	somedata dq 0xAABBCCFF

section mysection				;section name can be without preceding "."
	q	db	0x51                ; | 0x51 |
	w	db	0x52,0x56,0x57      ; | 0x52 | 0x56 | 0x57 |
	e	db	'a',0x53            ; | 0x41 | 0x53 |
	r	db	'hello',13,10,'$'   ; | 0x68 | 0x65 | 0x6C | 0x6C | 0x6F | 0x0D | 0x0A | 0x24 |
	t	dw	0x1234,0x5678       ; | 0x34 | 0x12 || 0x78 | 0x56 ||
	y	dw	'a'                 ; | 0x41 | 0x00 ||
	u	dw	'ab'                ; | 0x41 | 0x42 ||
	i	dw	'abc'               ; | 0x41 | 0x42 || 0x43 | 0x00 |
	o	dd	0x12345678          ; | 0x78 | 0x56  0x34 | 0x12 ||

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

entryPoint: ;Default entry point name is _start. User defined name should be pointed via
			;gcc -g -o ./build/program ./build/program.o -nostdlib -e entryPoint
			;or
			;ld -g -o ./build/program ./build/program.o -nostdlib -e entryPoint

	call	test_get_seg
	;call	test_mdfy_ss
	;call	test_mdfy_cs

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

test_get_seg:
	;mov rax, seg test_mdfy_ss
	mov es, rax
	mov rbx, test_mdfy_ss
	ret

test_mdfy_ss: ;it causes segmentation falut
	mov rax, ss
	inc rax
	mov ss, rax
	ret

test_mdfy_cs: ;it causes segmentation falut
	mov rax, cs
	inc rax
	mov cs, rax
	ret
