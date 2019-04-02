#include <stdint.h>
#include <stddef.h>

void *c_memcpy(void *dest, const void *src, size_t n) {
	
	size_t i = 0;
	for (; i < n; ++i) {
		((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
	}
	return dest;
}
