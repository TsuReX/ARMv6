#include "../bios/include/printreg.h"

typedef struct {
	uint32_t source_type;
	uint32_t data_type;
	uint32_t size;
} header_t;

typedef struct {
	uint32_t tail_magic;
} tail_t;

void printreg(uint32_t type, uint32_t data);
int32_t process_data(uint8_t *data, header_t *p_header);
