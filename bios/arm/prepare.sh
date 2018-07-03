#!/usr/bin
arm-linux-gnueabihf-as -g -ggdb start.s -o start.o
arm-linux-gnueabihf-ld -T map.ld start.o -o start.elf -e entry
arm-linux-gnueabihf-objcopy start.elf -O binary kernel.img
#scp start.s bios.elf horror:/home/yurchenko_v/workspace/arm
