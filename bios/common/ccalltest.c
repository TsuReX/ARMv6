#include "stdint.h"

uint32_t sum(uint32_t *array, uint32_t cnt) {
    if (cnt == 1)
        return array[0];
    return array[cnt - 1] + sum(array, cnt - 1);
}

uint64_t c_test_1(	uint32_t *arg_array_src, uint32_t *arg_array_dst, 
					uint32_t a2, uint32_t a3, 
					uint64_t a4, uint32_t a5,
					uint64_t a6, uint32_t a7) {
	
	((uint64_t*)arg_array_dst)[0] = a4;
	((uint64_t*)arg_array_dst)[1] = a5;
	((uint64_t*)arg_array_dst)[2] = a6;
	((uint64_t*)arg_array_dst)[3] = a7;
	
	return (uint64_t)a3 << 32 | a2;
	
}

uint32_t c_test_2(	uint32_t *arg_array_src,
					uint32_t *arg_array_dst, 
					uint32_t *arg_array_res,
					uint32_t wordscount) {
	while (wordscount > 0) {
		
		if (arg_array_dst[wordscount - 1] != arg_array_res[wordscount - 1])
			return 0xDEADBEEF;
		--wordscount;
	}
	return 0xBABADEDA;
	
}
