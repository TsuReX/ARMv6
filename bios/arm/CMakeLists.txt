cmake_minimum_required(VERSION 2.8)

project(arm_bios C ASM)

set(CMAKE_C_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

set(CMAKE_ASM_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_ASM_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

set(C_SRC 	stub.c)

set(ASM_SRC	start.S
		leds.S
		uart.S
		exceptions.S
		delay.S
		gpio.S
		math.S
		ports.S)

include_directories( ${CMAKE_CURRENT_SOURCE_DIR} )

if ( NOT DEFINED PLATFORM )
    set (PLATFORM "VERSATILE_PB")
endif()

message ("-- Selected platform is ${PLATFORM}")
add_definitions(-D${PLATFORM})

set( CMAKE_EXECUTABLE_SUFFIX .elf )

set( CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/map.ld -nostdlib")

#message(${CMAKE_BINARY_DIR})
#enable_language(ASM)

add_executable(start ${ASM_SRC} ${C_SRC} )

# TODO Add here arm-linux-gnueabihf-objcopy -O binary start kernel.img
#add_library(start STATIC ${ASM_SRC})
#target_link_libraries(start)
#execute_process(COMMAND ${CMD})
