
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
#elif TEST_BOARD
.equ GPIO_BASE,		0x00009000
#else /* VERSATILE_PB */
.equ GPIO_BASE, 	0x101E4000 /* Versatile/PB  */
#endif

.equ GPIO_GPFSEL0,	0x00
.equ GPIO_GPFSEL1,	0x04
.equ GPIO_GPSET0,	0x1C
.equ GPIO_GPSET1,	0x20
.equ GPIO_GPCLR0,	0x28
.equ GPIO_GPCLR1,	0x2C
.equ GPIO_GPLEV0,	0x34
.equ GPIO_GPLEV1,	0x38

.equ GPIO_IN,		0x00 /* 0b000 */
.equ GPIO_OUT,		0x01 /* 0b001 */
.equ GPIO_ALT0,		0x04 /* 0b100 */
.equ GPIO_ALT1,		0x05 /* 0b101 */
.equ GPIO_ALT2,		0x06 /* 0b110 */
.equ GPIO_ALT3,		0x07 /* 0b111 */
.equ GPIO_ALT4,		0x03 /* 0b011 */
.equ GPIO_ALT5,		0x02 /* 0b010 */

.equ GPIO_16,		0x10
.equ GPIO_22,		0x16
.equ GPIO_23,		0x17
.equ GPIO_24,		0x18
.equ GPIO_25,		0x19
.equ GPIO_27,		0x1B

.equ LED_0,			0x11
.equ LED_1,			0x18
.equ LED_2,			0x1B
.equ LED_3,			0x16
.equ LED_4,			0x17
.equ LED_5,			0x18
.equ LED_6,			0x19
.equ LED_7,			0x04

.equ LED_ON,		0x01
.equ LED_OFF,		0x00

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

.equ IRQ_BASE,		0x2020B000
.equ IRQ0_PEND,		0x200
.equ IRQ1_PEND,		0x204
.equ IRQ2_PEND,		0x208
.equ FIQ_CTRL,		0x20C
.equ IRQ0_EN,		0x218
.equ IRQ1_EN,		0x210
.equ IRQ2_EN,		0x214
.equ IRQ0_DIS,		0x224
.equ IRQ1_DIS,		0x21C
.equ IRQ2_DIS,		0x220
.equ IRQ0_ARM_TIMER,	(1 << 0)

.equ CPSR_FIQ, 		(1 << 6)
.equ CPSR_IRQ, 		(1 << 7)

.equ TIMER_BASE,	0x2020B000
.equ TIMER_LOAD,	0x400
.equ TIMER_CTRL,	0x408
.equ TIMER_CLRIRQ,	0x40C
.equ TIMER_IRQPEND,	0x410
.equ TIMER_MSKIRQ,	0x414
.equ TIMER_PREDIV,	0x41C
.equ TIMER_RELOAD,	0x418

.equ TIMER_CTRL_32BIT,	(0x1 << 1)
.equ TIMER_CTRL_PRE16,	(0x1 << 2)
.equ TIMER_CTRL_PRE256,	(0x2 << 2)
.equ TIMER_CTRL_IRQEN,	(0x1 << 5)
.equ TIMER_CTRL_ENABLE,	(0x1 << 7)
.equ TIMER_CTRL_FRCSCL,	(0x3E << 16)
.equ TIMER_CTRL_DEFVAL, (TIMER_CTRL_FRCSCL | TIMER_CTRL_IRQEN | TIMER_CTRL_PRE256 | TIMER_CTRL_32BIT)

.equ SYS_TIMER_BASE,	0x20203000
.equ SYS_TIMER_CLO,	0x4
.equ SYS_TIMER_CHI,	0x8

