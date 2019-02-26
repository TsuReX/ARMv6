cmake_minimum_required(VERSION 2.8)

message("-- MSG: Add dir ${CMAKE_CURRENT_SOURCE_DIR}")

set(PROJ_NAME common)

project(${PROJ_NAME})

set(C_SRC	
		stub.c
		ccalltest.c
		)

set(ASM_SRC
		delay.S
		math.S
		)

include_directories("../include")

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
