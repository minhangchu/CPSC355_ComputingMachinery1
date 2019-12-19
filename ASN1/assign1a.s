// CPSC 355 Spring 2019
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 1 - part A

// Minh Hang Chu - 30074056

/* This program is ARMv8 A64 assembly language that find the maximum of y = -5^3-31x + 4x + 31 by using loop and testing. 
 This version is written without macros, use only mul, add, mov instruction. The loop is pretest lop, the test is on the top
*/

// Format for print statement
format:	.asciz "For x: %d. The value of y is: %d.\nThe current maximum value of y: %d\n"
	.balign 4					// Ensure all instructions are properly aligned
	.global main					// Make label main visible for linker
main: 							// Where starts execution
	stp 	x29,	x30,	[sp,-16]!		// Save FP register and link register current values on stack
	mov	x29,	sp				// Update FP register

	mov	x19,	-6				// Initialize  x value to integer value -6
	mov	x20,	0				// Initialize y value to 0
	mov	x21,	0				// Initialize max Y to 0
	mov	x23,	0				// Initialize number of count
	b	loop					// Branch to loop

loop:	cmp	x19,	5				// Loop starts. Loop test: compare x value with 5
	b.gt	done					// If x value is greater than 5, branch to done. Otherwise, go to the next line
		
	mov 	x20,	0				// Initialize y value to 0 again in every loop
	mov 	x22,	-5				// Set the first coefficient to temporary register x22 (-5)
	mul	x22,	x22,	x19			// Multiply coefficient with x value (-5x) and store in x22  register
	mul	x22,	x22,	x19			// Multiply register x22 with x value, store in x22 (-5*x*x)
	mul	x22,	x22,	x19			// Multiply register x22 with x value, store in x22 (-5*x*x*x)
	add	x20,	x20,	x22			// Add x22 to y value. Store in x20 which is y value. (y = -5x^3)

	mov	x22,	-31				// Set the second coefficient to temporary register x22 (-31)
	mul 	x22,	x22,	x19			// Multiply coefficient with x value and store in register x22 (-31*x)
	mul 	x22,	x22,	x19			// Multiply register x22 with x value, store in x22 (-31*x*x)
	add	x20,	x20,	x22			// Add x22 to y value. Store in x 20 (y = -5x^3 -31x^2)

	mov 	x22,	4				// Set the third coefficient to temporary register x22 (4)
	mul 	x22,	x22,	x19			// Multiply coefficient with x value and store in x22 (4*x)
	add	x20,	x20,	x22			// Add x22 to y value. Store in x20 (y = -5x^3 -31x^2 + 4x)

	add 	x20,	x20,	31			// Add the last coefficient to y value. Store in x 20. (y = -5x^3-31x^2+4x+31)
	cmp	x23,	0				// If count equals 0, which is the first y value, assign y to y max
	b.eq	getYmax
	
	cmp 	x20,	x21				// Compare y value and max y value
	b.gt	getYmax					// If y is greater than max y, branch to getYmax
end:
	ldr	x0,	=format				// Load register x0 with the address of string output
	mov	x1,	x19				// Load register x1 with the value x
	mov	x2,	x20				// Load register x2 with the value y
	mov 	x3,	x21				// Load register x3 with the maximum y value
	bl	printf					// Call print function
	add	x19,	x19,	1			// Add 1 to x value
	add 	x23,	x23,	1			// Add 1 to count number
	b	loop					// Branch to loop. the loop starts again
getYmax:
	mov	x21,	x20				// Store value of y to max Y
	b 	end					// Branch to end
done:	
	ldp	x29,	x30,	[sp],	16		// Restore FP and link registers
	ret						// end main
	
