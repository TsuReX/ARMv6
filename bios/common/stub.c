#include "stdint.h"

uint32_t stub_func(uint32_t val1, uint32_t val2, uint32_t val3/*, uint32_t val4, uint32_t val5*/) {
	val1++;	
	return val1 + val2 + val3 /*+ val4 + val5*/;
}

int32_t func(int32_t v0, int32_t v1, int32_t v2, int32_t v3, int32_t v4, int32_t v5, int32_t v6, int32_t v7) {
	return v0 + v1 + v2 + v3 + v4 + v5 + v6 + v7;
}
