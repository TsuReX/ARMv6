program: ./build/program.o
	gcc -g -o ./build/program ./build/program.o -nostdlib
	
./build/program.o: ./src/program.s ./src/cdecl.c
	mkdir -p build
	nasm -f elf64 ./src/program.s -g -o ./build/program.o
	gcc -c ./src/cdecl.c -o ./build/cdecl.o

clean: 
	rm -r ./build