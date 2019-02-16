cmake_minimum_required(VERSION 2.8)

set(PROJ_NAME common)

project(${PROJ_NAME})

set(C_SRC	
		stub.c
		)

set(ASM_SRC
		delay.S
		math.S
		)

message(${CMAKE_CURRENT_SOURCE_DIR})

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
