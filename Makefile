include src/bios/arm/Makefile.inc

test:
	@echo TEST target
#	@echo $^


linker: ./src/linker/file1.c ./src/linker/file2.c ./src/linker/file2.c ./src/linker/linker.script
	rm -rf ./build
	mkdir -p ./build/linker
	gcc -c ./src/linker/file1.c -o ./build/linker/file1.o
	gcc -c ./src/linker/file2.c -o ./build/linker/file2.o
	gcc -c ./src/linker/file3.c -o ./build/linker/file3.o
	ld -T ./src/linker/linker.script -L ./build/linker -o ./build/linker/result.o

program: ./build/program.o
#	gcc -g -o ./build/program ./build/program.o -nostdlib -e entryPoint
	ld -g -o ./build/program ./build/program.o -nostdlib -e entryPoint
#	ld -g -o ./build/program2 ./build/cdecl.o ??? error
	
./build/program.o: ./src/program.s ./src/cdecl.c
	mkdir -p build
	nasm -f elf64 ./src/program.s -g -o ./build/program.o
	gcc -c ./src/cdecl.c -o ./build/cdecl.o
	gcc -g ./src/cdecl.c -o ./build/program2

clean: 
	rm -rf ./build