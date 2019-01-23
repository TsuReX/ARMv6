#include "ports.S"

.global undef_handler, svc_cmc_handler, pabt_handler, dabt_handler, irq_handler, fiq_handler

.text

undef_handler:

	save

	print SPECUND, r0

	restore
	mov pc, lr

svc_cmc_handler:

	save

	print SPECSVMC, r0

	restore
	mov pc, lr

pabt_handler:

	save

	print SPECPABT, r0

	restore
	mov pc, lr

dabt_handler:

	save

	print SPECDABT, r0

	restore
	mov pc, lr

irq_handler:

	save

	print SPECIRQ, r0
	bl armside_timer_exc_handler

	restore
	mov pc, lr

fiq_handler:

	save

	print SPECFIQ, r0

	restore
	mov pc, lr
