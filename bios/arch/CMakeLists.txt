cmake_minimum_required(VERSION 2.8)

set(PROJ_NAME arch)

project(${PROJ_NAME})

set(C_SRC	
		)

set(ASM_SRC
		exceptions.S
		specexchandler.S
		memory.S
		)

message(${CMAKE_CURRENT_SOURCE_DIR})

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
