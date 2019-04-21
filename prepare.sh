case $1 in

	1)
		export ARMTOOL=/home/vasily/workspace/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin
		export CMAKE_C_COMPILER=arm-linux-gnueabihf
		echo "ARMTOOL: ${ARMTOOL}"
		echo "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}"
		;;
		
	2)	
		export ARMTOOL=/home/vasily/workspace/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin
		export CMAKE_C_COMPILER=arm-bcm2708-linux-gnueabi
		echo "ARMTOOL: ${ARMTOOL}"
		echo "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}"
		;;
		
	3)
		export ARMTOOL=/home/vasily/workspace/tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi/bin
		export CMAKE_C_COMPILER=arm-bcm2708hardfp-linux-gnueabi
		echo "ARMTOOL: ${ARMTOOL}"
		echo "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}"
		;;
		
	4)
		export ARMTOOL=/home/vasily/workspace/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin
		export CMAKE_C_COMPILER=arm-linux-gnueabihf
		echo "ARMTOOL: ${ARMTOOL}"
		echo "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}"
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
echo "cmake ../bios/ -DCHECKING=1 -DPLATFORM=RASPBERRY_PI1 -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}-gcc "		>> ./build/build.sh
echo "make"														>> ./build/build.sh
echo "${CMAKE_C_COMPILER}-strip arm_bios.elf -o kernel.img"		>> ./build/build.sh
chmod 0777 ./build/build.sh

echo "#!/bin/sh" 						>> ./build/cp-img.sh
echo "mkdir -p /tmp/rpi"				>> ./build/cp-img.sh
echo "mount /dev/mmcblk0p1 /tmp/rpi" 	>> ./build/cp-img.sh
echo "cp -f kernel.img /tmp/rpi/" 		>> ./build/cp-img.sh
echo "umount /tmp/rpi" 					>> ./build/cp-img.sh
chmod 0777 ./build/cp-img.sh
