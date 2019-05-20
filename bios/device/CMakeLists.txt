cmake_minimum_required(VERSION 2.8)

message("-- MSG: Add dir ${CMAKE_CURRENT_SOURCE_DIR}")

set(PROJ_NAME device)

project(${PROJ_NAME})

set(C_SRC	
		)

set(ASM_SRC
		gpio_rpib.S
#		gpiotest.S
		term_blink.S
		systimer.S
		timer.S
		uart.S
		)

include_directories("../include")

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
