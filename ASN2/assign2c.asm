// CPSC 355 Spring 2019
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 2 - part c

//Create an ARMv8 assembly language program that implements integer multiplication program

// Format for printing
data1:
	// Print out initial values of variables
	.asciz "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"
	.balign 4

data2:
	// Print out product and multiplier
 	.asciz "product = 0x%08x multiplier = 0x%08x\n"
 	.balign 4

data3:
	// Combine product and multiplier together
	.asciz "64-bit result = 0x%016lx (%ld)\n"
	.balign 4
	
	
 	.global main						// Make label main visible for linker
main:								// Where execution starts
	stp	x29,	x30,	[sp,-16]!			// Save FP register and link register current values on stack
	mov 	x29,	sp					// Update FP register

	// Define register name
	define(multiplier, w19)					// Define the name of w19 is multiplier	
	define(multiplicand, w20)				// Define the name of w20 is multiplicand
	define(product, w21)					// Define the name of w21 is product
	define(i, w22)						// Define the name of w20 is variable i for loop
	define(negative, w23)					// Define the name of w23 is negative to check if multiplier is ngative
	define(result, x24)					// Define the name of x24 is result
	define(temp1, x25)					// Define the name of x25 is temp1
	define(temp2, x26)					// Define the name of x26 is temp2

  	// Initialize variable
	mov	multiplicand, 	-252645136			// Initialize multiplicand value to -252645136
	mov	multiplier,	-256				// Initialize multiplier value to -256
	mov	product,	0				// Initialize product to 0
	mov	i,       	0				// Initialize i to 0


	// Print out initial values of variables
	ldr	x0,	=data1					// Load register x0 with the address of string output
 	mov	w1,	multiplier				// Load register w1 with the value of mutiplier
	mov	w2,	multiplier				// Load register w2 with the value of mutiplier
	mov	w3,	multiplicand				// Load register w3 with the value of mutiplicand
 	mov	w4,	multiplicand				// Load register w4 with the value of mutiplicand
  	bl	printf						// Call print function

	// Determine if multiplier is negative
 	cmp 	multiplier,	0				// Compare the multiplier with 0
  	b.le 	true_neg					// If multipler is less or equal 0, branch to true_neg
	mov 	negative,	0				// else set negative to 0

checkLMB:							
	cmp	i,	32					// Compare variable i to 32
	b.ge	adjustProduct					// If i is greater or equal 32, branch to adjustProduct
	
	tst	multiplier,	0x1				// Test if multiplier has the least most bit is 1
	b.eq	shift						// If the LMB is not 1, branch to shift
	add	product,	product,	multiplicand	// else: add product with multiplicand

shift:
	asr	multiplier,	multiplier,	1		// Arithmetic shift right for multiplier
	
	tst	product,	0x1				// Test if product has the least most bit equal 1
	b.eq	shift_2						// If the LMB is not 1, branch to shift_2
	orr	multiplier,	multiplier,	0x80000000	// OR operation with multiplier and 0x80000000

	b	loopend						// Branch to loopend
	
shift_2:
	and	multiplier,	multiplier,	0x7FFFFFFF	// AND operation with multiplier and 0x7FFFFFFF
	
loopend:
	asr	product,	product,	1		// Arithmetic shift right for product
	add	i,	i,	1				// increase variable i
	b	checkLMB					// Go back to checkLMB to repeat the loop if needed

true_neg:	
	mov 	negative,	1				// set negative to 1
	b	checkLMB					// Branch to the loop check LMB

adjustProduct:
	cmp	negative,	1				// Compare negative to 1
	b.ne	print						// If negative is not 1, branch to print
	sub	product,	product,	multiplicand	// Else: subtract multiplicand from product

print:
	// Print out product and multiplier
	ldr	x0,	=data2					// Load register x0 with the address of string output
 	mov	w1,	product					// Load register w1 with the value of product
	mov	w2,	multiplier				// Load register w2 with the value of mutiplier
  	bl	printf						// Call print function

	// Combine product and multiplier together
	sxtw	temp1,	product					// Extract product from 32 bit to 64 bit
	and	temp1,	temp1,	0xFFFFFFFF			// Set AND between temp1 and 0xFFFFFFFF
	lsl	temp1,	temp1,	32				// Logical shift left 32 bit
	sxtw	temp2,	multiplier				// Extract multiplier from 32 bit to 64 bit
	and	temp2,	temp2,	0xFFFFFFFF			// Set AND between temp2 and 0xFFFFFFFF
	add	result,	temp1,	temp2				// Add temp1 and temp  2 to the result

	// Print out 64-bit result
	ldr	x0,	=data3					// Load register x0 with the address of string output
 	mov	x1,	result					// Load register x1 with the value of result
	mov	x2,	result					// Load register x2 with the value of product
  	bl	printf						// Call print function

done:
	ldp x29,  x30,  [sp], 16				// Restore FP and link registers
	ret							// End main
