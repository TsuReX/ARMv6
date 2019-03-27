#include <stdint.h>

void memfillinc(uint32_t *dst, uint32_t base_val, uint32_t count) {
	
	uint32_t i = 0;
	
	for (; i < count; ++i) {
		dst[i] = base_val + i;
	}
}
