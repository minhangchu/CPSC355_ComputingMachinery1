// CPSC 355 Spring 2019
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 1 - part B

// Minh Hang Chu - 30074056

/* This program is ARMv8 A64 assembly language that find the maximum of y = -5^3-31x + 4x + 31 by using loop and testing. 
 This version is written with macros, use madd instruction. The loop is pretest lop, the test is at the bottom of the loop
*/
					// Define the name of x19 is x19
					// Define the name of x20 is x20
					// Define the name of x21 is maximum Y value
					// Define the name of x22 is temporary value
					// Define the name of x23 is number of x23
// Format for print statement
format:
	.asciz "For x: %d. The value of y is: %d.\nThe current maximumvalue of y: %d\n"
	.balign 4					// Ensure all instructions are properly aligned
	.global main					// Make label main visible for linker
main:							// Where execution starts
	stp	x29,	x30,	[sp,-16]!		// Save FP register and link register current values on stack
	mov	x29,	sp				// Update FP register
	mov	x19,	-6				// Initialize  x value to integer value -6
	b	looptest				// Branch to looptest

loop:
	mov	x20,	0				// Initialize y value to 0 again in every loop
	mov	x22,	-5				// Set the first coefficient to x22 register x22 (-5)
	mul	x22,	x22,	x19			// Multiply coefficient with x value (-5x) and store in x22 register
	mul	x22,	x22,	x19			// Multiply register x22 with x value, store in x22 (-5*x*x)
	madd	x20,	x22,	x19,	x20		// Multiply register x22  with x value, then add to y value. Store in x20 x20 (y=-5*x*x*x +0)

	mov	x22,	-31				// Set the second coefficient to register x22 (-31)
	mul	x22,	x22,	x19			// Multiply coefficient in x22  with x value and store in register x22 (-31*x)
	madd	x20,	x22,	x19,	x20		// Multiply register x22  with x value, then add to y value. Store in x20 x20 (y=-5x^3 -31x^2)
	
	mov	x22,	4				// Set the third coefficient to temporary register x22 (4)
	madd	x20,	x22,	x19,	x20		// Multiply register x22  with x value, then add to y value. Store in x20 x20 (y=-5x^3 -31x^2+4x)

	add	x20,	x20,	31			// Add the last coefficient to y value. Store in x 20. (y = -5x^3-31x^2+4x+31)

	cmp	x23,	0				// If x23 equals 0, which is the first y value, assign y to y max
	b.eq	getYmax					

	cmp	x20,	x21				// Compare y value and max y value
	b.gt	getYmax					// If y is greater than max y, branch to getYmax

end:
	ldr	x0,	=format				// Load register x0 with the address of string output
	mov	x1,	x19				// Load register x1 with the value x
	mov	x2,	x20				// Load register x2 with the value y
	mov	x3,	x21				// Load register x3 with the maximum y value
	bl	printf					// Call print function
	add	x19,	x19,1			// Add 1 to x value
	add	x23, x23, 1				// Add 1 to x23 number
	b	looptest				// Branch to looptest again

looptest:
	cmp	x19,	5				// Loop test: compare x value with 5
	b.le	loop					// If x19 is less or equal 5, test passes. Branch to loop

done:				
	ldp	x29,	x30,	[sp],	16		// Restore FP and link registers
	ret						// End main

getYmax:		
	mov	x21,	x20				// Store value of y to max Y
	b	end					// Branch to end
	
