#include "stdint.h"

uint32_t stub_func(uint32_t val1, uint32_t val2, uint32_t val3/*, uint32_t val4, uint32_t val5*/) {
	val1++;	
	return val1 + val2 + val3 /*+ val4 + val5*/;
}
