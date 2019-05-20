#include <stdint.h>
#include <post.h>

#define GPIO_POST_MASK		0x01
#define UART_POST_MASK		0x02
#define I2C_POST_MASK		0x04

#define POST_MASK 			GPIO_POST_MASK

#define GPIO_POST_BIT_COUNT	0x4

void led(uint32_t led_num, uint32_t on) {
	
	uint32_t ret_val = 0;
	asm volatile ( 
		"mov r0, %1 \t\n"
		"mov r1, %2 \t\n"
		"bl gpio_set \t\n"
		"mov %0, r0 \t\n" 
		:"=r"(ret_val) :"r"(led_num), "r"(on)
	);
}

void gpio_post(uint32_t post_val) {

	uint32_t i = 0;
	uint32_t map[GPIO_POST_BIT_COUNT] = {0, 1, 2, 3};
	for(; i < GPIO_POST_BIT_COUNT; ++i) {
		led(map[i], (post_val >> i) & 1);
	}
}

void uart_post(uint32_t post_val) {
}

void i2c_post(uint32_t post_val) {
}

void post(uint32_t post_val) {

	if (POST_MASK == 0) {
		gpio_post(post_val); // Default post
		return;
	}

	if (POST_MASK & 0xF !=0) {
		gpio_post(post_val); 
		uart_post(post_val);
		i2c_post(post_val);
		return;
	}

	if (POST_MASK & UART_POST_MASK != 0)
		uart_post(post_val);

	if (POST_MASK & I2C_POST_MASK != 0)
		i2c_post(post_val);

	if (POST_MASK & GPIO_POST_MASK != 0)
		gpio_post(post_val);
}
