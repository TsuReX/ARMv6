target remote localhost:1234
layout asm
layout regs
layout split
focus cmd
symbol-file arm_bios.elf
b do_checking
