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

void *memset(void *src, uint8_t filler, size_t n) {
	
	size_t i = 0;
	
	for (; i < n; ++i) {
		((uint8_t*)src)[i] = filler;
	}
	
	return src;
	
}

void memfillinc(uint32_t *dst, uint32_t base_val, uint32_t count) {

	uint32_t i = 0;

	for (; i < count; ++i) {
		dst[i] = base_val + i;
	}
}

int32_t memcmp(const void *s1, const void *s2, size_t n) {

	size_t i = 0;

	for (; i < n; ++i) {
		if (((uint8_t*)s1)[i] > ((uint8_t*)s1)[i])
			return -1;
		else if (((uint8_t*)s1)[i] < ((uint8_t*)s1)[i])
			return 1;
	}

	return 0;
}
