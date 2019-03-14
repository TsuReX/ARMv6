#include "stdint.h"

extern int32_t func(int32_t v0, int32_t v1, int32_t v2, int32_t v3, int32_t v4, int64_t v5, int64_t v6);

uint32_t sum(uint32_t *array, uint32_t cnt) {
    if (cnt == 1)
        return array[0];
    return array[cnt - 1] + sum(array, cnt - 1);
}

c_test_1(uint32_t v0, uint32_t v1, uint32_t v2, uint32_t v3, uint32_t v4, uint32_t v5, uint32_t v6) {
   // uint32_t array[5] = {v0, v1, v2, v3, v4};
    uint32_t a = v6 + v5;
    return func(v0, v1, v2, v3, v4, v5, a);
   // return sum(array, 5);
}

