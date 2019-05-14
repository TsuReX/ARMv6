/*#ifdef PLAT /**/
#ifdef RASPBERRY_PI1
.equ GPIO_BASE, 	0x20200000 /* RaspberryPi 1 */
#elif TEST_BOARD
.equ GPIO_BASE,		0x00009000
#else /* VERSATILE_PB */
.equ GPIO_BASE, 	0x101E4000 /* Versatile/PB  */
#endif

.equ GPIO_REG_GPFSEL0,		0x00
.equ GPIO_REG_GPFSEL1,		0x04
.equ GPIO_REG_GPSET0,		0x1C
.equ GPIO_REG_GPSET1,		0x20
.equ GPIO_REG_GPCLR0,		0x28
.equ GPIO_REG_GPCLR1,		0x2C
.equ GPIO_REG_GPLEV0,		0x34
.equ GPIO_REG_GPLEV1,		0x38

.equ GPIO_MODE_IN,			0x00 /* 0b000 */
.equ GPIO_MODE_OUT,			0x01 /* 0b001 */
.equ GPIO_MODE_ALT0,		0x04 /* 0b100 */
.equ GPIO_MODE_ALT1,		0x05 /* 0b101 */
.equ GPIO_MODE_ALT2,		0x06 /* 0b110 */
.equ GPIO_MODE_ALT3,		0x07 /* 0b111 */
.equ GPIO_MODE_ALT4,		0x03 /* 0b011 */
.equ GPIO_MODE_ALT5,		0x02 /* 0b010 */

.equ _GPIO_02,				0x02
.equ _GPIO_03,				0x03
.equ _GPIO_04,				0x04
.equ _GPIO_07,				0x07
.equ _GPIO_08,				0x08
.equ _GPIO_09,				0x09
.equ _GPIO_10,				0x0A
.equ _GPIO_11,				0x0B
.equ _GPIO_14,				0x0D
.equ _GPIO_15,				0x0F
.equ _GPIO_17,				0x11
.equ _GPIO_18,				0x12
.equ _GPIO_22,				0x16
.equ _GPIO_23,				0x17
.equ _GPIO_24,				0x18
.equ _GPIO_25,				0x19
.equ _GPIO_27,				0x1B

.equ GPIO_IN_0,				_GPIO_02
.equ GPIO_IN_1,				_GPIO_03

.equ GPIO_OUT_0,				_GPIO_03
.equ GPIO_OUT_1,				_GPIO_03
.equ GPIO_OUT_2,				_GPIO_03
.equ GPIO_OUT_3,				_GPIO_03
.equ GPIO_OUT_4,				_GPIO_03
.equ GPIO_OUT_5,				_GPIO_03
.equ GPIO_OUT_6,				_GPIO_03
.equ GPIO_OUT_7,				_GPIO_03


.macro GPIO_GET GPIO_NUM DST_REG
	@ TODO
.endm

.macro GPIO_SET_V GPIO_NUM VAL
	@ TODO
.endm

.macro GPIO_SET_R GPIO_NUM REG
	@ TODO
.endm

.macro GPIO_SET_MODE GPIO_NUM DST_REG
	@ TODO
.endm
