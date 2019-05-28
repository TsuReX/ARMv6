#ifndef _GPIO_IO
#define _GPIO_IO

.macro GPIO_GET GPIO_NUM DST_REG
	mov r0, \GPIO_NUM
	bl gpio_get
	mov \DST_REG, r1
.endm

.macro GPIO_SET_V GPIO_NUM VAL
	mov r0, \GPIO_NUM
	ldr r1, =\VAL
	bl gpio_set
.endm

.macro GPIO_SET_R GPIO_NUM REG
	mov r0, \GPIO_NUM
	mov r1, \REG
	bl gpio_set
.endm

#endif /* _GPIO_IO */
