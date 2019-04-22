case $1 in

	2)
		export ARMTOOL=/home/vasily/workspace/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin
		export C_COMPILER_PREFIX=arm-bcm2708-linux-gnueabi
		echo "ARMTOOL: ${ARMTOOL}"
		echo "C_COMPILER_PREFIX: ${C_COMPILER_PREFIX}"
		;;

	3)
		export ARMTOOL=/home/vasily/workspace/tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi/bin
		export C_COMPILER_PREFIX=arm-bcm2708hardfp-linux-gnueabi
		echo "ARMTOOL: ${ARMTOOL}"
		echo "C_COMPILER_PREFIX: ${C_COMPILER_PREFIX}"
		;;

	*)
		echo "Unknown compiler"
		return 1
		;;
esac

export PATH=$PATH:$ARMTOOL

rm -rf	./build
mkdir	./build
cp		.gdbinit	./build

echo "#/bin/sh" 												>> ./build/build.sh
echo "cmake ../bios/ -DCHECKING=1 -DPLATFORM=RASPBERRY_PI1 -DCMAKE_C_COMPILER=${ARMTOOL}/${C_COMPILER_PREFIX}-gcc "		>> ./build/build.sh
echo "make"														>> ./build/build.sh
echo "${ARMTOOL}/${C_COMPILER_PREFIX}-strip arm_bios.elf -o kernel.img"		>> ./build/build.sh
chmod 0777 ./build/build.sh

echo "#/bin/sh" 								>> ./build/debug.sh
echo "${ARMTOOL}/${C_COMPILER_PREFIX}-gdb"		>> ./build/debug.sh
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
