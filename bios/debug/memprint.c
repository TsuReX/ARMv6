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

/*
 * Transfer via UART debugging data. The data can be a value, a register, or memory field.
 * source		- value / register / pointer of memory field
 * source_type	- REG in case of value / register, MEM in case of pointer of memory field
 * data_type	- VAL in case of value, CPSR or SPSR and so on in case of register (see printreg.h ),
 * 					unused in case of memory field
 * size			- size of memory field in bytes, unused in case of value / register
 *
 * Examples:	memprint(0x1234, REG, VAL, 0);
 * 				memprint(value_of_cpst_register, REG, CPSR, 0);
 *				memprint(value_of_spst_register, REG, SPSR, 0);
 *				memprint(pointer, MEM, 0, size_of_memory);
 */
void memprint(uint32_t source, uint32_t source_type, uint32_t data_type, size_t size) {

	if (source_type == REG) {
		if (send_head(source_type, data_type, 4) != 0)
			return;

		uart_send4(source);

		send_tail();
	}
	else if (source_type == MEM) {
		if (send_head(source_type, data_type, size) != 0)
			return;

		uint8_t* ptr_data = (uint8_t*)source;
		size_t i = 0;
		for (; i < size; ++i) {
			uart_send(ptr_data[i]);
		}

		send_tail();
	}
	else {
	;// WARNING! Illegal source type
	}
}
