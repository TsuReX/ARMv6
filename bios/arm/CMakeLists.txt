cmake_minimum_required(VERSION 2.8)

project(arm_bios)

set(CMAKE_C_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_ASM_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding")

#set(C_SRC "bios.c")
set(ASM_SRC start.s
			leds.s
			uart.s
			exceptions.s
			delay.s)

set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/map.ld -nostdlib")


enable_language(ASM)
add_executable(start ${ASM_SRC})
#add_library(start STATIC ${ASM_SRC})
target_link_libraries(start)