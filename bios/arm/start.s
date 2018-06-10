
.text
.global entry

entry:
    @msr cpsr, r0
    mrs r0, cpsr
    b loop

loop:
    b loop

