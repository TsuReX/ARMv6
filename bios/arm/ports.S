#include "config.h"

.equ FIQ_MODE,	0x11 /* 0b10001 */
.equ IRQ_MODE,	0x12 /* 0b10010 */
.equ ABT_MODE,	0x17 /* 0b10111 */
.equ UND_MODE,	0x1B /* 0b11011 */
.equ SVC_MODE,	0x13 /* 0b10011 */
.equ SYS_MODE,	0x1F /* 0b11111 */
.equ USR_MODE,	0x10 /* 0b10000 */
.equ MON_MODE,	0x16 /* 0b10110 */

/*#ifdef PLAT /**/
#ifdef RASPBERRY_PI1
.equ GPIO_BASE, 0x20200000 /* RaspberryPi 1 */
#else /* VERSATILE_PB */
.equ GPIO_BASE, 0x101E4000 /* Versatile/PB  */
#endif

.equ GPIO_IN,	0x00 /* 0b000 */
.equ GPIO_OUT,	0x01 /* 0b001 */
.equ GPIO_ALT0,	0x04 /* 0b100 */
.equ GPIO_ALT1,	0x05 /* 0b101 */
.equ GPIO_ALT2,	0x06 /* 0b110 */
.equ GPIO_ALT3,	0x07 /* 0b111 */
.equ GPIO_ALT4,	0x03 /* 0b011 */
.equ GPIO_ALT5,	0x02 /* 0b010 */

.equ GPIO_1,	0x1
.equ GPIO_2,	0x2
.equ GPIO_3,	0x3
.equ GPIO_4,	0x4
.equ GPIO_5,	0x5
.equ GPIO_6,	0x6
.equ GPIO_7,	0x7
.equ GPIO_8,	0x8
.equ GPIO_9,	0x9
.equ GPIO_10,	0xA
.equ GPIO_11,	0xB
