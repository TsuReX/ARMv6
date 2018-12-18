.global print_scr, print_ttbr0, print_ttbr1, print_ttbcr, print_midr
.global print_dacr, print_nsacr, print_tcmsr, print_itcmr, print_dtcmr
.global print_tlbtr, print_ctr, print_cidr

.text

/* Print Secure Configurationa Register
 * Input:
 * Return:
 */
print_scr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c1, c1, 0

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Translation Table Base 0 Register
 * Input:
 * Return:
 */
print_ttbr0:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c2, c0, 0

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Translation Table Base 1 Register
 * Input:
 * Return:
 */
print_ttbr1:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c2, c0, 1

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Translation Table Base Control Register
 * Input:
 * Return:
 */
print_ttbcr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c2, c0, 2

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Main ID Register
 * Input:
 * Return:
 */
print_midr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c0, c0, 0

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Domain Access Control Register
 * Input:
 * Return:
 */
print_dacr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c3, c0, 0

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Non-Secure Access Control Register
 * Input:
 * Return:
 */
print_nsacr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c1, c1, 2

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print TCM Status Register
 * Input:
 * Return:
 */
print_tcmsr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c0, c0, 2

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Instruction TCM Register
 * Input:
 * Return:
 */
print_itcmr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c9, c1, 1

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Data TCM Register
 * Input:
 * Return:
 */
print_dtcmr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c9, c1, 0

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print TLB Type Register
 * Input:
 * Return:
 */
print_tlbtr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c0, c0, 3

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Cache Type Register
 * Input:
 * Return:
 */
print_ctr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c0, c0, 1

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

/* Print Context ID Register
 * Input:
 * Return:
 */
print_cidr:

        stmdb sp!, {r0, lr}
        sub sp, sp, #0x4

        mrc p15, 0, r0, c13, c0, 1

        bl uart_send

        add sp, sp, #0x4
        ldmia sp!, {r0, lr}
        mov pc, lr

