#define FIQ_MODE	0x11 // 0b10001
#define IRQ_MODE	0x12 // 0b10010
#define ABT_MODE	0x17 // 0b10111
#define UND_MODE	0x1B // 0b11011
#define SVC_MODE	0x13 // 0b10011
#define SYS_MODE	0x1F // 0b11111
#define USR_MODE	0x10 // 0b10000
#define MON_MODE	0x16 // 0b10110

#define GPIO_IN		0x00 // 0b000
#define GPIO_OUT	0x01 // 0b001
#define GPIO_ALT0	0x04 // 0b100
#define GPIO_ALT1	0x05 // 0b101
#define GPIO_ALT2	0x06 // 0b110
#define GPIO_ALT3	0x07 // 0b111
#define GPIO_ALT4	0x03 // 0b011
#define GPIO_ALT5	0x02 // 0b010

#define GPIO_1		0x1
#define GPIO_2		0x2
#define GPIO_3		0x3
#define GPIO_4		0x4
#define GPIO_5		0x5
#define GPIO_6		0x6
#define GPIO_7		0x7
#define GPIO_8		0x8
#define GPIO_9		0x9
#define GPIO_10		0xA
#define GPIO_11		0xB

.global entry
.text
/*
 * Entry point
 */
entry:

    @ System is now in Supervisor mode
    @ Setup stacks pointer for all Operating modes
    cpsid #FIQ_MODE 		@ Change processor state, interrupt disabled
	ldr sp, = __fiq_stack	@ FIQ
    cpsid #IRQ_MODE
    ldr sp, = __irq_stack 	@ IRQ
	cpsid #ABT_MODE
	ldr sp, = __abt_stack 	@ Abort
	cpsid #UND_MODE
	ldr sp, = __und_stack 	@ Undefined
    cpsid #SVC_MODE
    ldr sp, = __svc_stack 	@ Supervisor
	cpsid #SYS_MODE
    ldr sp, = __sys_stack 	@ System
	@ TODO Change mode to Secure Monitor
	@ How to do it?
	ldr sp, = __mon_stack @ Secure Monitor
    
	@ User

    @ TODO Check GPIO manipulation functions
	mov r0, GPIO_1
	mov r1, 1
	bl set_gpio_mode
    @ TODO Check UART manipulation functions


    bl print_scr			@ TODO Check
    bl setup_gpio			@ TODO Remove
    bl setup_irq_vector		@ TODO Check
    bl enable_irq			@ TODO Check
    @bl enable_timer_irq	@ TODO Check
    @bl enable_timer		@ TODO Check

    bl blink_led
    
    b .

//******************************************************************//


/*
 * Print Secure Configurationa Register
 * Input:
 * Return:
 */
print_scr:

	str r0, [r13], #-0x4
	str r1, [r13], #-0x4

	@ Read Secure Configurationa Register
    mcr p15, 0, r1, c1, c1, 0

	@ Send [7:0]
	mov r0, r1
	bl uart_send
	cmp r0, #0x0
	bne 1f

	@ Send [15:8]
	mov r0, r1, lsr #0x8
	bl uart_send
	cmp r0, #0x0
	bne 1f

	@ Send [23:16]
	mov r0, r1, lsr #0x8
	bl uart_send
	cmp r0, #0x0
	bne 1f

	@ Send [31:24]
	mov r0, r1, lsr #0x8
	bl uart_send
	cmp r0, #0x0
	bne 1f

	1: @ Error occured during transfer
	ldr r1, [r13, #0x4]!
	ldr r0, [r13, #0x4]!

    mov pc, lr

/*
 * TODO
 * Input:
 * Return:
 */
setup_gpio:
    ldr r0, =0x20200000
    ldr r1, =0x40000
    str r1, [r0, #0x4]
    ldr r1, =0x9000
    str r1, [r0, #0x8]
    mov pc, lr

/*
 * TODO
 * Input:
 * Return:
 */
enable_timer:
	@	in <--- out
    ldr r0, =0x202B0400
    @	in <--- out
    ldr r1, =0xF4240
    @	out ---> in
    str r1, [r0]	@ Load 1.000.000 into the counter register
    ldr r0, =0x202B0408
    ldr r1, [r0]
    mov r2, #0xA2
    orr r1, r2
    @	out ---> in
    str r1, [r0]	@ Set Timer enable, Timer interrupt enable, 23-bit counter set
    mov pc, lr

