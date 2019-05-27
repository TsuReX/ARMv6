#include "post.S"
#include "ports.S"
#include "gpio_rpib.inc.S"
#include "gpio_io.inc.S"
#include "delay.S"

.equ STOP,				0x1
.equ NOSTOP,			0x0
.equ ASSERT_GPIO_NUM,	GPIO_IN_0
/*
 *
 */
.macro ASSERT_POST R0 CMP_VAL EQ_VAL NEQ_VAL STOP

#ifdef ASSERT

	ldr r4, =\CMP_VAL
	cmp \R0, r4
	bne 4f

	@ R0 and CMP_VAL are equal
	POST \EQ_VAL

	b 1f

4:
	@ R0 and CMP_VAL aren't equal
	POST \NEQ_VAL

1:
	ldr r4, =\STOP
	mov r5, #0x1
	cmp r4, r5
	bne 2f

3:
	GPIO_GET ASSERT_GPIO_NUM r5
	mov r4, #0x1
	cmp r5, r4
	beq 2f
	DELAY 5000000
	b 3b
2:

#else	// ASSERT
	@ Do nothing
#endif	// ASSERT

.endm
