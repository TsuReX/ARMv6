cmake_minimum_required(VERSION 2.8)

project(arm_bios)

set(CMAKE_C_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_ASM_COMPILER "arm-linux-gnueabihf-as")
set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding")

set(C_SRC "bios.c")
set(ASM_SRC "start.s")

set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/bios.ld -nostdlib")


enable_language(ASM)
add_executable(bios ${C_SRC})
add_library(start STATIC ${ASM_SRC})
target_link_libraries(bios start)