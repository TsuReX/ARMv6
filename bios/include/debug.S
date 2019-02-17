
.macro  print type, reg

        save

        ldr r0, =\type
        bl uart_send4

        mov r0, \reg
        bl uart_send4

        restore
.endm

.macro  print_val val

        save

        ldr r0, =(VAL)
        bl uart_send4

        ldr r0, =\val
        bl uart_send4

        restore
.endm
