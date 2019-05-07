# ARMv6 boot

# Prepare to build
./prepare.sh /path/to/compiler/directory

Example
./prepare.sh /home/yurchenko/soft/tools/arm-bcm2708/arm-linux-gnueabihf/bin

# Build
cd build
./build.sh

# Running qemu
./run-qemu.sh

# Copy image to flash
./cp-img.sh

# RaspberryPi tools:
git clone https://github.com/raspberrypi/tools.git
