cmake_minimum_required(VERSION 2.8)

message("-- MSG: Add dir ${CMAKE_CURRENT_SOURCE_DIR}")

set(PROJ_NAME arch)

project(${PROJ_NAME} C ASM)

if (DEFINED MEMCPY)
	if (${MEMCPY} STREQUAL ASM)

		add_definitions(-DMEMCPY_ASM)
		message("-- MSG: memcpy function will be built form assembly language")

	elseif(${MEMCPY} STREQUAL C)
		add_definitions(-DMEMCPY_C)
		message("-- MSG: memcpy function will be built form C language")

	else() # ${MEMCPY} STREQUAL C
		add_definitions(-DMEMCPY_ASM)
		message("-- MSG: memcpy function will be built form assembly language")
	endif() # ${MEMCPY} STREQUAL C

else()
	add_definitions(-DMEMCPY_ASM)
	message("-- MSG: memcpy function will be built form assembly language")
endif()

set(C_SRC	
		c_memory.c)

set(ASM_SRC
		exceptions.S
		specexchandler.S
		asm_memory.S
		)

include_directories("../include")

add_library(${PROJ_NAME} STATIC ${ASM_SRC} ${C_SRC})
