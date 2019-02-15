cmake_minimum_required(VERSION 2.8)

set(PROJ_NAME arm_bios)

project(arm_bios C ASM)

#set(CMAKE_C_COMPILER "/home/yurchenko/soft/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc")
#set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

#set(CMAKE_ASM_COMPILER "/home/yurchenko/soft/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc")
#set(CMAKE_ASM_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

set(C_SRC	)

set(ASM_SRC	start.S
		)

include_directories("include")

#add_subdirectory("device")
#add_subdirectory("debug")
add_subdirectory(arch)
#add_subdirectory("common")

if ( NOT DEFINED PLATFORM )
    set (PLATFORM "VERSATILE_PB")
endif()

message ("-- Selected platform is ${PLATFORM}")
add_definitions(-D${PLATFORM})

set( CMAKE_EXECUTABLE_SUFFIX .elf )

set( CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/map.ld -nostdlib")

message(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(start ${ASM_SRC} ${C_SRC})

target_link_libraries(start)
