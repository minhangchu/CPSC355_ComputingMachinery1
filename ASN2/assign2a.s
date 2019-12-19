// CPSC 355 Spring 2019
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 2 - part A

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
						// Define the name of w19 is w19	
					// Define the name of w20 is w20
						// Define the name of w21 is w21
							// Define the name of w22 is variable w22 for loop
						// Define the name of w23 is w23 to check if w19 is ngative
						// Define the name of x24 is x24
						// Define the name of x25 is x25
						// Define the name of x26 is x26

  	// Initialize variable
	mov	w20, 	-16843010			// Initialize w20 value to -16843010
	mov	w19,	70				// Initialize w19 value to 70
	mov	w21,	0				// Initialize w21 to 0
	mov	w22,       	0				// Initialize w22 to 0


	// Print out initial values of variables
	ldr	x0,	=data1					// Load register x0 with the address of string output
 	mov	w1,	w19				// Load register w1 with the value of mutiplier
	mov	w2,	w19				// Load register w2 with the value of mutiplier
	mov	w3,	w20				// Load register w3 with the value of mutiplicand
 	mov	w4,	w20				// Load register w4 with the value of mutiplicand
  	bl	printf						// Call print function

	// Determine if w19 is w23
 	cmp 	w19,	0				// Compare the w19 with 0
  	b.le 	true_neg					// If multipler is less or equal 0, branch to true_neg
	mov 	w23,	0				// else set w23 to 0

checkLMB:							
	cmp	w22,	32					// Compare variable w22 to 32
	b.ge	adjustProduct					// If w22 is greater or equal 32, branch to adjustProduct
	
	tst	w19,	0x1				// Test if w19 has the least most bit is 1
	b.eq	shift						// If the LMB is not 1, branch to shift
	add	w21,	w21,	w20	// else: add w21 with w20

shift:
	asr	w19,	w19,	1		// Arithmetic shift right for w19
	
	tst	w21,	0x1				// Test if w21 has the least most bit equal 1
	b.eq	shift_2						// If the LMB is not 1, branch to shift_2
	orr	w19,	w19,	0x80000000	// OR operation with w19 and 0x80000000

	b	loopend						// Branch to loopend
	
shift_2:
	and	w19,	w19,	0x7FFFFFFF	// AND operation with w19 and 0x7FFFFFFF
	
loopend:
	asr	w21,	w21,	1		// Arithmetic shift right for w21
	add	w22,	w22,	1				// increase variable w22
	b	checkLMB					// Go back to checkLMB to repeat the loop if needed

true_neg:	
	mov 	w23,	1				// set w23 to 1
	b	checkLMB					// Branch to the loop check LMB

adjustProduct:
	cmp	w23,	1				// Compare w23 to 1
	b.ne	print						// If w23 is not 1, branch to print
	sub	w21,	w21,	w20	// Else: subtract w20 from w21

print:
	// Print out w21 and w19
	ldr	x0,	=data2					// Load register x0 with the address of string output
 	mov	w1,	w21					// Load register w1 with the value of w21
	mov	w2,	w19				// Load register w2 with the value of mutiplier
  	bl	printf						// Call print function

	// Combine w21 and w19 together
	sxtw	x25,	w21					// Extract w21 from 32 bit to 64 bit
	and	x25,	x25,	0xFFFFFFFF			// Set AND between x25 and 0xFFFFFFFF
	lsl	x25,	x25,	32				// Logical shift left 32 bit
	sxtw	x26,	w19				// Extract w19 from 32 bit to 64 bit
	and	x26,	x26,	0xFFFFFFFF			// Set AND between x26 and 0xFFFFFFFF
	add	x24,	x25,	x26				// Add x25 and temp  2 to the x24

	// Print out 64-bit x24
	ldr	x0,	=data3					// Load register x0 with the address of string output
 	mov	x1,	x24					// Load register x1 with the value of x24
	mov	x2,	x24					// Load register x2 with the value of w21
  	bl	printf						// Call print function

done:
	ldp x29,  x30,  [sp], 16				// Restore FP and link registers
	ret							// End main
