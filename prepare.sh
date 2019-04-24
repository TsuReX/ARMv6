CROSS_GCC=` basename $(find $1 -type f -name "*-gcc") `
echo "CROSS_GCC is" $CROSS_GCC
if [ -z "$CROSS_GCC" ] ;then
	echo "Cross-gcc wasn't found"
	return 1
fi

CROSS_GDB=` basename $(find $1 -type f -name "*-gdb") `
echo "CROSS_GDB is" $CROSS_GDB
if [ -z "$CROSS_GDB" ] ;then
	echo "Cross-gdb wasn't found"
	return 2
fi

CROSS_STRIP=` basename $(find $1 -type f -name "*-strip") `
echo "CROSS_STRIP is" $CROSS_STRIP
if [ -z "$CROSS_STRIP" ] ;then
	echo "Cross-strip wasn't found"
	return 3
fi

CROSS_TOOLS_DIR=$1
echo "CROSS_TOOLS_DIR is" $CROSS_TOOLS_DIR

rm -rf	./build
mkdir	./build
cp		.gdbinit	./build

echo "#/bin/sh" 												>> ./build/build.sh
echo "cmake ../bios/ -DCHECKING=1 -DPLATFORM=RASPBERRY_PI1 -DCMAKE_C_COMPILER=${CROSS_TOOLS_DIR}/${CROSS_GCC}"		>> ./build/build.sh
echo "make"														>> ./build/build.sh
echo "${CROSS_TOOLS_DIR}/${CROSS_STRIP} arm_bios.elf -o kernel.img"		>> ./build/build.sh
chmod 0777 ./build/build.sh

echo "#/bin/sh" 								>> ./build/debug.sh
echo "${CROSS_TOOLS_DIR}/${CROSS_GDB}"			>> ./build/debug.sh
chmod 0777 										./build/debug.sh

echo "#/bin/sh" 								>> ./build/run-qemu.sh
echo "qemu-system-arm -cpu arm1176 -M versatilepb -m 256 -nographic -s -S -monitor stdio -kernel arm_bios.elf"	>> ./build/run-qemu.sh
chmod 0777 										./build/run-qemu.sh

echo "#!/bin/sh" 						>> ./build/cp-img.sh
echo "mkdir -p /tmp/rpi"				>> ./build/cp-img.sh
echo "mount /dev/mmcblk0p1 /tmp/rpi" 	>> ./build/cp-img.sh
echo "cp -f kernel.img /tmp/rpi/" 		>> ./build/cp-img.sh
echo "umount /tmp/rpi" 					>> ./build/cp-img.sh
chmod 0777 ./build/cp-img.sh
