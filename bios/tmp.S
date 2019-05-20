.macro print_regs

	bl print_cpsr
	bl print_spsr
	bl print_scr
	bl print_tcmsr
	bl print_midr
	bl print_ctr

.endm @ print_regs

.macro setup_exc

	@ Setup exceptions vector to 0x0
	mov r0, #0x0
	bl place_exc_vector

	ldr r0, =undef_handler
	bl setup_undef_handler

	ldr r0, =svc_smc_handler
	bl setup_svc_smc_handler

	ldr r0, =pabt_handler
	bl setup_pabt_handler

	ldr r0, =dabt_handler
	bl setup_dabt_handler

	ldr r0, =irq_handler
	bl setup_irq_handler

	ldr r0, =fiq_handler
	bl setup_fiq_handler

	@ TODO Enable exceptions
	bl enable_irq @ TODO What does it do?

.endm @ setup_exc


	bl enable_irq
	bl enable_timer_irq
	bl setup_timer
	ldr r0, =0xFFFF
	bl set_timer_value
	bl enable_timer
