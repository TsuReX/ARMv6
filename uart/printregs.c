#include <stdio.h>
#include <stdint.h>

#include "printregs.h"

void print_cpsr(uint32_t value) {
	
	printf("CPSR: 0x%08X "
			"\n\tNegative/less then		%d, "
			"\n\tZero			%d,"
			"\n\tCarry/borrow/extend		%d,"
			"\n\toVerflow			%d,"
			"\n\tQ sticky overflow		%d,"
			"\n\tJazelle			%d,"
			"\n\tGreater or Equal to		%d,"
			"\n\tEndianness			%d,"
			"\n\timprecise Abort disable bit	%d,"
			"\n\tIrq disable			%d,"
			"\n\tFiq disable			%d,"
			"\n\tThumb state bit		%d,"
			"\n\tModes bit			0x%02X\n", 
			value,
			(value >> 31) & 0x1,
			(value >> 30) & 0x1,
			(value >> 29) & 0x1,
			(value >> 28) & 0x1,
			(value >> 27) & 0x1,
			(value >> 24) & 0x1,
			(value >> 16) & 0xF,
			(value >> 9) & 0x1,
			(value >> 8) & 0x1,
			(value >> 7) & 0x1,
			(value >> 6) & 0x1,
			(value >> 5) & 0x1,
			value & 0x1F
			);
}

int32_t print_mem(uint8_t *data, uint32_t size) {
	// Data should consist of: MEM_SIZE(4),START_ADDR(4), BYTES..... 
	
	if (size < 2 * sizeof(uint32_t) + sizeof(uint8_t))
		return -1;
	
	uint32_t mem_size = *(uint32_t*)data;
	uint32_t start_addr = *(uint32_t*)(data + sizeof(uint32_t));
	
	if (size < mem_size + 2 * sizeof(uint32_t))
		return -2;

	uint32_t words_count = mem_size >> 2;
	uint32_t bytes_count = mem_size & 0x3;
	
	printf("Start address = 0x%X\n", start_addr);
	printf("Words count = 0x%X\n", words_count);
	printf("Bytes count = 0x%X\n", bytes_count);
	
	uint32_t* words_ptr = (uint32_t*)(data + 2 * sizeof(uint32_t));
	
	uint32_t word_address = *(uint32_t*)(data + 2 * sizeof(uint32_t));
	
	uint32_t i = 0;
	
	for (;i < words_count; ++i, ++word_address, ++words_ptr) {
		printf("0x%08X : 0x%08X\n", word_address, *words_ptr);
	}
	
	switch(bytes_count) {
		case 1:
			printf("0x%08X : 0x%02X\n", word_address, *words_ptr & 0xFF);
			break;
		
		case 2:
			printf("0x%08X : 0x%04X\n", word_address, *words_ptr & 0xFFFF);
			break;
		
		case 3:
			printf("0x%08X : 0x%06X\n", word_address, *words_ptr & 0xFFFFFF);
			break;
		
		default:
			printf("Illegal remaining bytes count!!!!\n");
			break;
		}


	return 0;
}

int32_t process_data(uint8_t *data, uint32_t size) {
    
	uint32_t data_size = size - sizeof(uint32_t);
	
	if (data == NULL)
		return -2;
	
	if (data_size < sizeof(uint32_t))
		return -1;
	
	uint32_t type = *(uint32_t*)data;
	data += sizeof(uint32_t);
	
	switch (type) {

		case CPSR:
			if (size < 2 * sizeof(uint32_t))
				return -1;
			print_cpsr(*(uint32_t*)data);
			break;

		case MEMPRINT:
			// Don't check size here
			if (print_mem(data, size - sizeof(uint32_t)) != 0)
				return -3;
			
			break;
		
		default:
			return -2;
	}

    return 0;
}