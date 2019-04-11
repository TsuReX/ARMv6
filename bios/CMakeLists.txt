cmake_minimum_required(VERSION 2.8)

message("-- MSG: Add dir ${CMAKE_CURRENT_SOURCE_DIR}")

set(PROJ_NAME arm_bios)

project(${PROJ_NAME} C ASM)

#set(CMAKE_C_COMPILER "/home/yurchenko/soft/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc")
set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

#set(CMAKE_ASM_COMPILER "/home/yurchenko/soft/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc")
set(CMAKE_ASM_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

if ( NOT DEFINED PLATFORM )
	set (PLATFORM "VERSATILE_PB")
endif()

add_definitions(-D${PLATFORM})
message ("-- MSG: Selected platform is ${PLATFORM}")

if (DEFINED CHECKING)
	set (CHECKING "CHECKING")
	add_definitions(-D${CHECKING})
	message ("-- MSG: Checking mechanisms are activated")
endif()

set( CMAKE_EXECUTABLE_SUFFIX .elf )
set( CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/map.ld -nostdlib")

add_subdirectory(device)
add_subdirectory("debug")
add_subdirectory(arch)
add_subdirectory(common)

set(C_SRC	)

set(ASM_SRC	start.S
		)

include_directories("include")

add_executable(${PROJ_NAME} ${ASM_SRC} ${C_SRC})

target_link_libraries(${PROJ_NAME} device dbg common arch dbg device)
