#!/usr/bin
arm-linux-gnueabihf-as -g -ggdb start.s -o bios.o
arm-linux-gnueabihf-ld -T bios.ld bios.o -o bios.elf -e entry
scp start.s bios.elf horror:/home/yurchenko_v/workspace/arm
