program: ./build/program.o
	gcc -o ./build/program ./build/program.o -nostdlib
	
./build/program.o: program.s
	mkdir -p build
	nasm -f elf64 program.s -g -o ./build/program.o

clean: 
	rm -r ./build