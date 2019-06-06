cmake_minimum_required(VERSION 2.8)

project(uart)

set(C_SRC 	uart.c
#			printregs.c
			)

include_directories( ${CMAKE_CURRENT_SOURCE_DIR} )


set( CMAKE_EXECUTABLE_SUFFIX .elf )

add_executable(uart ${C_SRC} )

#target_link_libraries(start)
