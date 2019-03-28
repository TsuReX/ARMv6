# ARMv6 boot

# cmake:
# To choose Raspberry Pi 1 platform
cmake ../bios/ -DPLATFORM=RASPBERRY_PI1

# To choose Versatile/PB platform (default)
cmake ../bios/ -DPLATFORM=VERSATILE_PB
# or
cmake ../bios/

# Inside build directory

rm -rf ./*; \
CC=arm-linux-gnueabihf-gcc cmake ../bios/ -DPLATFORM=RASPBERRY_PI1; \
make; \
arm-linux-gnueabihf-strip arm_bios.elf -o kernel.img; \
cp ../bios/.gdbinit .; \
cp ../prepare-img.sh .

# More correct variant
rm -rf ./*; \
cmake ../bios/ \
-DCHECKING \
-DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc -DPLATFORM=RASPBERRY_PI1; \
make; \
arm-linux-gnueabihf-strip arm_bios.elf -o kernel.img; \
cp ../bios/.gdbinit .; \
cp ../prepare-img.sh .

# Running:
qemu-system-arm \
-cpu arm1176 -M versatilepb -m 256 -nographic -s -S -monitor stdio \
-kernel arm_bios

# RaspberryPi tools:
git clone https://github.com/raspberrypi/tools.git
