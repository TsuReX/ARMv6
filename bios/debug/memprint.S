#include "basemacro.S"
#include "dbgprint.h"

.global memprint

.text

/*
 * Transfer via UART specified amount of memory
 * starting from specified address to examine it
 * Input:       r0 - Starting address of memory
 *              r1 - Count of bytes to transfer
 * Output: TODO What result a function should return?
 */
memprint:

        save

        mov r2, #0x0    @ Compare count of bytes with zero
        cmp r1, r2
        beq 4f

        mov r4, r0      @ Save r0

        ldr r0, =MEMPRINT       @ Send type of transmission
        bl uart_send4

        mov r0, r1      @ Send count of bytes
        bl uart_send4

        mov r0, r4      @ Send start address
        bl uart_send4

        lsr r2, r1, #0x2        @ Evaluate count of batches of 4 bytes

        mov r3, #0x0

2:      @ Loop for sending batches of 4 bytes
        cmp r2, r3
        beq 3f

        ldr r0, [r4]!   @ Load 4 bytes from memory
        bl uart_send4   @ Send 4 bytes

        mov r0, #0x1
        sub r2, r0      @ Decrement count of batches

        b 2b

        mov r3, #0x2    @ Evaluate elapsed count of bytes
        and r2, r3

        mov r0, #0x0

        ldr r3, [r4]    @ Load elapsed bytes
3: @ Loop for sending elapsed bytes(0 - 3) by 1 byte
        cmp r2, r0
        beq 4f

        mov r1, #0xFF   @ Extract byte form register
        and r0, r3, r1
        bl uart_send    @ Send byte

        lsr r3, r3, #0x8        @ Shift register by 8 bits right

        mov r1, #0x1    @ Decrement count of elapsed bytes
        sub r2, r1

        b 3b

4:
        restore
        mov pc, lr

