ENTRY(_start)
 
SECTIONS
{
    . = 0x1000;
    __irq_stack = .;
    . = 0x2000;
    __sys_stack = .;
    . = 0x3000;
    __usr_stack = .;

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