#include "stdint.h"

uint32_t sum(uint32_t *array, uint32_t cnt) {
    if (cnt == 1)
        return array[0];
    return array[cnt - 1] + sum(array, cnt - 1);
}

c_test_1(uint32_t v0, uint32_t v1, uint32_t v2, uint32_t v3, uint32_t v4) {
    uint32_t array[5] = {v0, v1, v2, v3, v4};
    return sum(array, 5);
}
