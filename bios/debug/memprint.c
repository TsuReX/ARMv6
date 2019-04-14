#include "stdint.h"
#include "stddef.h"
#include "printreg.h"

extern uint32_t uart_send(uint8_t data);
extern uint32_t uart_send4(uint32_t data);

static uint32_t send_head(uint32_t source_type, uint32_t data_type, size_t size) {

	if (uart_send4(source_type) != 0)
		return 1;

	if (uart_send4(data_type) != 0)
		return 2;

	if (uart_send4(size) != 0)
		return 3;

	return 0;
}

static uint32_t send_tail(void) {

	if (uart_send4(0xABC5DEF9) != 0)
		return 1;

	return 0;
}

void memprint(uint32_t source, uint32_t source_type, uint32_t data_type, size_t size) {

	if (source_type == REG) {
		if (send_head(source_type, data_type, 1) != 0)
			return;

		uart_send4(source);

		send_tail();
	}
	else if (source_type == MEM) {
		if (send_head(source_type, data_type, 1) != 0)
			return;

		uint8_t* ptr_data = (uint8_t*)source;
		size_t i = 0;
		for (; i < size; ++i) {
			uart_send(uart_send(ptr_data[i]));
		}

		send_tail();
	}
	else {
	;// WARNING! Illegal source type
	}
}
