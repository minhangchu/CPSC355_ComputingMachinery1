// CPSC 355 Spring 2019
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 1 - part B

// Minh Hang Chu - 30074056

/* This program is ARMv8 A64 assembly language that find the maximum of y = -5^3-31x + 4x + 31 by using loop and testing. 
 This version is written with macros, use madd instruction. The loop is pretest lop, the test is at the bottom of the loop
*/
	define(xvalue, x19)				// Define the name of x19 is xvalue
	define(yvalue, x20)				// Define the name of x20 is yvalue
	define(maxY, x21)				// Define the name of x21 is maximum Y value
	define(temp, x22)				// Define the name of x22 is temporary value
	define(count, x23)				// Define the name of x23 is number of count
// Format for print statement
format:
	.asciz "For x: %d. The value of y is: %d.\nThe current maximumvalue of y: %d\n"
	.balign 4					// Ensure all instructions are properly aligned
	.global main					// Make label main visible for linker
main:							// Where execution starts
	stp	x29,	x30,	[sp,-16]!		// Save FP register and link register current values on stack
	mov	x29,	sp				// Update FP register
	mov	xvalue,	-6				// Initialize  x value to integer value -6
	b	looptest				// Branch to looptest

loop:
	mov	yvalue,	0				// Initialize y value to 0 again in every loop
	mov	temp,	-5				// Set the first coefficient to temp register x22 (-5)
	mul	temp,	temp,	xvalue			// Multiply coefficient with x value (-5x) and store in temp register
	mul	temp,	temp,	xvalue			// Multiply register x22 with x value, store in x22 (-5*x*x)
	madd	yvalue,	temp,	xvalue,	yvalue		// Multiply register x22  with x value, then add to y value. Store in yvalue x20 (y=-5*x*x*x +0)

	mov	temp,	-31				// Set the second coefficient to register x22 (-31)
	mul	temp,	temp,	xvalue			// Multiply coefficient in x22  with x value and store in register x22 (-31*x)
	madd	yvalue,	temp,	xvalue,	yvalue		// Multiply register x22  with x value, then add to y value. Store in yvalue x20 (y=-5x^3 -31x^2)
	
	mov	temp,	4				// Set the third coefficient to temporary register x22 (4)
	madd	yvalue,	temp,	xvalue,	yvalue		// Multiply register x22  with x value, then add to y value. Store in yvalue x20 (y=-5x^3 -31x^2+4x)

	add	yvalue,	yvalue,	31			// Add the last coefficient to y value. Store in x 20. (y = -5x^3-31x^2+4x+31)

	cmp	count,	0				// If count equals 0, which is the first y value, assign y to y max
	b.eq	getYmax					

	cmp	yvalue,	maxY				// Compare y value and max y value
	b.gt	getYmax					// If y is greater than max y, branch to getYmax

end:
	ldr	x0,	=format				// Load register x0 with the address of string output
	mov	x1,	xvalue				// Load register x1 with the value x
	mov	x2,	yvalue				// Load register x2 with the value y
	mov	x3,	maxY				// Load register x3 with the maximum y value
	bl	printf					// Call print function
	add	xvalue,	xvalue,1			// Add 1 to x value
	add	count, count, 1				// Add 1 to count number
	b	looptest				// Branch to looptest again

looptest:
	cmp	xvalue,	5				// Loop test: compare x value with 5
	b.le	loop					// If xvalue is less or equal 5, test passes. Branch to loop

done:				
	ldp	x29,	x30,	[sp],	16		// Restore FP and link registers
	ret						// End main

getYmax:		
	mov	maxY,	yvalue				// Store value of y to max Y
	b	end					// Branch to end
	
