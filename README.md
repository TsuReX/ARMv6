# ARMVv6 boot

cmake:
To choose Raspberry Pi 1 platform
cmake ../bios/ -DPLATFORM=RASPBERRY_PI1

To choose Versatile/PB platform (default)
cmake ../bios/ -DPLATFORM=VERSATILE_PB
or
cmake ../bios/

inside build directory

rm -rf ./*; cmake ../bios/ -DPLATFORM=RASPBERRY_PI1; make; arm-linux-gnueabihf-strip start.elf -o kernel.img; cp ../bios/.gdbinit .

Running:
qemu-system-arm -cpu arm1176 -M versatilepb -m 256 -nographic -kernel start -s -S -monitor stdio

RaspberryPi tools:
git clone https://github.com/raspberrypi/tools.git
