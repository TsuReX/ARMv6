#include <gpio_rpib.inc.S>

.equ LED_0,			GPIO_OUT_0
.equ LED_1,			GPIO_OUT_1
.equ LED_2,			GPIO_OUT_2
.equ LED_3,			GPIO_OUT_3
.equ LED_4,			GPIO_OUT_4
.equ LED_5,			GPIO_OUT_5
.equ LED_6,			GPIO_OUT_6
.equ LED_7,			GPIO_OUT_7

.equ ON,			0x01
.equ OFF,			0x00

.macro LED NUM VAL

	mov r0, #\NUM
	mov r1, #\VAL
	bl gpio_set

.endm @ LED
