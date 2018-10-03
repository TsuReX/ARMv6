.equ FIQ_MODE,		0x11 /* 0b10001 */
.equ IRQ_MODE,		0x12 /* 0b10010 */
.equ ABT_MODE,		0x17 /* 0b10111 */
.equ UND_MODE,		0x1B /* 0b11011 */
.equ SVC_MODE,		0x13 /* 0b10011 */
.equ SYS_MODE,		0x1F /* 0b11111 */
.equ USR_MODE,		0x10 /* 0b10000 */
.equ MON_MODE,		0x16 /* 0b10110 */

/*#ifdef PLAT /**/
#ifdef RASPBERRY_PI1
.equ GPIO_BASE, 	0x20200000 /* RaspberryPi 1 */
#else /* VERSATILE_PB */
.equ GPIO_BASE, 	0x101E4000 /* Versatile/PB  */
#endif

.equ GPIO_FSEL0,	0x00
.equ GPIO_FSEL1,	0x04

.equ GPIO_GPSET0,	0x1C
.equ GPIO_GPSET1,	0x20

.equ GPIO_GPCLR0,	0x28
.equ GPIO_GPCLR1,	0x2C

.equ GPIO_IN,		0x00 /* 0b000 */
.equ GPIO_OUT,		0x01 /* 0b001 */
.equ GPIO_ALT0,		0x04 /* 0b100 */
.equ GPIO_ALT1,		0x05 /* 0b101 */
.equ GPIO_ALT2,		0x06 /* 0b110 */
.equ GPIO_ALT3,		0x07 /* 0b111 */
.equ GPIO_ALT4,		0x03 /* 0b011 */
.equ GPIO_ALT5,		0x02 /* 0b010 */


.equ GPIO_16,		(0x1 << 16)
.equ GPIO_24,		(0x1 << 24)
.equ GPIO_25,		(0x1 << 25)

.equ UART_BASE,		0x20201000
.equ UART_DR,		0x00
.equ UART_RSECR,	0x04
.equ UART_FR,		0x18
.equ UART_ILPR,		0x20
.equ UART_IBRD,		0x24
.equ UART_FBRD,		0x28
.equ UART_LCRH,		0x2C
.equ UART_CR,		0x30
.equ UART_IFLS,		0x34
.equ UART_IMSC,		0x38
.equ UART_RIS,		0x3C
.equ UART_MIS,		0x40
.equ UART_ICR,		0x44
.equ UART_DMACR,	0x48
.equ UART_ITCR,		0x80
.equ UART_ITIP,		0x84
.equ UART_ITOP,		0x88
.equ UART_TDR,		0x8C
