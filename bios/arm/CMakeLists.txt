cmake_minimum_required(VERSION 2.8)

project(arm_bios)

#set(CMAKE_C_COMPILER "arm-linux-gnueabihf-gcc")
#set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

set(CMAKE_ASM_COMPILER "arm-linux-gnueabihf-gcc")
set(CMAKE_ASM_FLAGS "-mcpu=arm1176jzf-s -fpic -ffreestanding -ggdb -g")

#set(C_SRC "*.c")
set(ASM_SRC	start.S
		leds.S
		uart.S
		exceptions.S
		delay.S
		gpio.S
		math.S
		ports.S
		config.h)

include_directories( ${CMAKE_CURRENT_SOURCE_DIR} )
set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/map.ld -nostdlib")
set(CMAKE_ASM_FLAGS "-DPLATFORM=1")
add_definitions(-DPLATFORM=1)
#message(${CMAKE_SOURCE_DIR})
#message(${CMAKE_BINARY_DIR})

if ( DEFINED CMD )
	message("-- User msg: " ${CMD})
endif()

#enable_language(ASM)
add_executable(start ${ASM_SRC} )
# TODO Add here arm-linux-gnueabihf-objcopy -O binary start kernel.img

#add_library(start STATIC ${ASM_SRC})
#target_link_libraries(start)
#execute_process(COMMAND ${CMD})
#execute_process(COMMAND echo hellloooo)