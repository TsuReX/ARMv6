asm: asm.o
	gcc -o asm asm.o -nostdlib
	
	
asm.o: asm.s
	nasm -f elf64 asm.s -g


	
clean: 
	rm asm.o asm