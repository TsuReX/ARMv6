ENTRY(_start)
 
SECTIONS
{
    
/*    . = 0x10;
    .ivt :
    {
	*(.ivt)
    }
*/
    /* Starts at LOADER_ADDR. */
    . = 0x8000;
/*    __start = .;
    __text_start = .;
*/
    .text :
    {
        KEEP(*(.text.boot))
        *(.text)
    }
    . = ALIGN(4096); /* align to page size */
/*    __text_end = .;

    __rodata_start = .;
*/
    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096); /* align to page size */
/*    __rodata_end = .;
 
    __data_start = .;
*/
    .data :
    {
        *(.data)
    }
    . = ALIGN(4096); /* align to page size */
/*    __data_end = .;
 
   __bss_start = .;
*/
    .bss :
    {
        bss = .;
        *(.bss)
    }
    . = ALIGN(4096); /* align to page size */
/*
    __bss_end = .;
    __end = .;
*/
    . = 0x1000;
    irq_stack = .;
    . = 0x2000;
    sys_stack = .;
    . = 0x3000;
    usr_stack = .;


}