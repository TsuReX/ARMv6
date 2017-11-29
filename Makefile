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