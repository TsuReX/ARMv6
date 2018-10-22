ENTRY(__start)
 
SECTIONS
{


    . = 0x200;
	__fiq_stack = .;

    . = 0x600;
    __irq_stack = .;

	. = 0x800;
	__abt_stack = .;

	. = 0xA00;
	__und_stack = .;

/*????????????????????????*/
	. = 0xC00;
	__mon_stack = .;
/*????????????????????????*/

    . = 0x6000;
    __svc_stack = .;

    . = 0x8000 - 4;
    __sys_stack = .;
    
    . = 0x8000;
    __start = .;

/*****************************************************/

    __text_start = .; 
    .text :
    {
        *(.text)
    }
    . = ALIGN(4096); /* align to page size */
    __text_end = .;

/*****************************************************/

    __rodata_start = .;
    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096); /* align to page size */
    __rodata_end = .;

/*****************************************************/

    __data_start = .;
    .data :
    {
        *(.data)
    }
    . = ALIGN(4096); /* align to page size */
    __data_end = .;

/*****************************************************/

   __bss_start = .;
    .bss :
    {
        bss = .;
        *(.bss)
    }
    . = ALIGN(4096); /* align to page size */
    __bss_end = .;

/*****************************************************/

    __end = .;


}