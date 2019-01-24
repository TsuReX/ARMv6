#include "../bios/printregs.h"

typedef struct {
	uint32_t type;
	uint32_t data;
} pkg_t

void printreg(uint32_t type, uint32_t data);
