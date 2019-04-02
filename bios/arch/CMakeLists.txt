cmake_minimum_required(VERSION 2.8)

message("-- MSG: Add dir ${CMAKE_CURRENT_SOURCE_DIR}")

set(PROJ_NAME arch)

project(${PROJ_NAME} C ASM)

set(C_SRC	
		c_memcpy.c)

set(ASM_SRC
		exceptions.S
		specexchandler.S
		memory.S
		memoryaux.c
		)

include_directories("../include")

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
