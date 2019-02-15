cmake_minimum_required(VERSION 2.8)

project(arch)

#set(CMAKE_C_COMPILER "/home/yurchenko/soft/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc")
#set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

#set(CMAKE_ASM_COMPILER "/home/yurchenko/soft/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc")
#set(CMAKE_ASM_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

set(C_SRC	
		)

set(ASM_SRC
		exceptions.S
		specexchandler.S
		memory.S
		)

message(${CMAKE_CURRENT_SOURCE_DIR})

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
