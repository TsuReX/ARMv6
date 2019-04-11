cmake_minimum_required(VERSION 2.8)

message("-- MSG: Add dir ${CMAKE_CURRENT_SOURCE_DIR}")

set(PROJ_NAME dbg)

project(${PROJ_NAME})

set(C_SRC
		memprint.c
		)

set(ASM_SRC
		printreg.S
		check.S
		)

include_directories("../include")

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
