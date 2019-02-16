cmake_minimum_required(VERSION 2.8)

set(PROJ_NAME device)

project(${PROJ_NAME})

set(C_SRC	
		)

set(ASM_SRC
		gpio.S
		gpiotest.S
		leds.S
		systimer.S
		timer.S
		uart.S
		)

message(${CMAKE_CURRENT_SOURCE_DIR})

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
