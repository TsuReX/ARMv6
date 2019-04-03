#include <stdint.h>
#include <stddef.h>

#ifdef MEMCPY_C
void *memcpy(void *dest, const void *src, size_t n) {

	size_t i = 0;
	for (; i < n; ++i) {
		((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
	}
	return dest;
}
#endif //MEMCPY_C

void memfillinc(uint32_t *dst, uint32_t base_val, uint32_t count) {

	uint32_t i = 0;

	for (; i < count; ++i) {
		dst[i] = base_val + i;
	}
}
