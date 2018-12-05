#include "ports.S"

.text

/* 
 * TODO
 * Input:	r0 - The begining address of word of being copied field
 *			r1 - Address of word immediately after being copied field
 *			r2 - Destination address
 * Return:	r0 - Error code
 */
memcpy:
	@ 1. Save registers
	@ 2. Check begin < end
	@ 3. Check (end - begin) mod 8 == 0
	@ 4. Eval C8 = (end - begin) div 8
	@ 5. Eval C1 = (end - begin) - (C8 * 8)
	@ 6. Copy batches of 8
	@ 7. Copy remaider words
	@ 8. Restore registers
	@ 9. Return