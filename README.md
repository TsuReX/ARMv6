# sandbox

cmake:
To choose Raspberry Pi 1 platform
cmake ../bios/arm/ -DPLATFORM=RASPBERRY_PI1

To choose Versatile/PB platform (default)
cmake ../bios/arm/ -DPLATFORM=VERSATILE_PB
or
cmake ../bios/arm/

Running:
qemu-system-arm -cpu arm1176 -M versatilepb -m 256 -nographic -kernel start -s -S -monitor stdio

RaspberryPi tools:
git clone https://github.com/raspberrypi/tools.git