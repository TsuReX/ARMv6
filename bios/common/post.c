#include "stdint.h"

#include "post.h"

#define GPIO_POST_MASK	0x01
#define UART_POST_MASK	0x02
#define I2C_POST_MASK	0x04

#define MASK GPIO_POST_MASK

void gpio_post(uint32_t post_val) {
}

void uart_post(uint32_t post_val) {
}

void i2c_post(uint32_t post_val) {
}

void post(uint32_t post_val) {
	
	if (MASK == 0) {
		gpio_post(post_val); // Default post
		return;
	}
	if (MASK & 0xF !=0) {
		gpio_post(post_val); 
		uart_post(post_val);
		i2c_post(post_val);
		return;
	}
	if (MASK & UART_POST_MASK != 0)
		uart_post(post_val);
	if (MASK & I2C_POST_MASK != 0)
		i2c_post(post_val);
	if (MASK & GPIO_POST_MASK != 0)
		gpio_post(post_val);
}
