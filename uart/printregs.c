#include <stdio.h>
#include "printregs.h"

void printreg(uint32_t type, uint32_t value) {
	
	// TODO Correct type checking
	if (type & 0xFFFF0000 != 0xDEAD0000) {
		printf("Unknown register: 0x%08X, value: 0x%08X", type, value);
		return;
	}

	if (type == CPSR) {
		printf("CPSR: 0x%08X 
				\n\tNegative/less then		%d, 
				\n\tZero			%d,
				\n\tCarry/borrow/extend		%d,
				\n\toVerflow			%d,
				\n\tQ sticky overflow		%d,
				\n\tJazelle			%d,
				\n\tGreater or Equal to		%d,
				\n\tEndianness			%d,
				\n\timprecise Abort disable bit	%d,
				\n\tIrq disable			%d,
				\n\tFiq disable			%d,
				\n\tThumb state bit		%d,
				\n\tModes bit			0x%02X\n", 
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
		return;
	}
}
