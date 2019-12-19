// CPSC 355 Spring 2019
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 3: Sorting One-Dimensional Arrays

//Create an ARMv8 assembly language program that implements algorithm
// The algorithm will create random new array list with 50 elements inside and sort them in ascending order. 
// Using insertion method

// Format for printing
data1:
	// Print out initial random array
	.asciz "v[%d]: %d\n"
	.balign 4

data2:
	// Print out label sorted array
	.asciz "\nSorted array:\n"
	.balign 4

data3:
	// Print out sorted array
	.asciz "v[%d]: %d\n"
	.balign 4

// Initialize

alloc	= -(16+50*1)&-16			// (16B FrameRecord + 50B array) & -16
        .equ    dealloc,   -alloc		// deallocate space is negation of allocating space. To be released at the end main

i       .req    x19				// define x19 to be variable i
arrayBA .req    x20				// define x20 to be variable array base address
j       .req    x21				// define x21 to be variable j
temp    .req    w22				// define w22 to be temporary number
preVal	.req    w23				// define w23 to be the number at index j-1
prej	.req    x24				// define w24 to be j-1

// Main
       .global main
main:
	stp	x29,    x30,    [sp,alloc]!	// Allocate memory and store FP and LR
	mov     x29,    sp			// Fp gets the address of the frame record

	mov     i,  0				// Initialize i = 0
	mov     arrayBA,    x29			// Calculating base address
	add     arrayBA,    arrayBA,    16	// base address = x19 +16

	bl      clock				// get current time
	bl      srand				// using current time as the seed for rand()

// Loop 1: to create an array with 50 elements inside (inndex form 0 -49)
loop1:	
	bl      rand				// call random function to get new number
	and     x2,     x0,     0xFF		// x2 = x0 % 30
	strb    w2 ,    [arrayBA,i]		// initialize the current element

	ldr     x0,     =data1			// print the current array element
	mov     x1,     i			// index
	bl      printf

	add	i,	i,	1		// increase index by 1 after each loop
	cmp	i,	49			// compare index with 49, if less or equal, start the loop again
	b.le	loop1

// Sorting an array
	mov	i,	1			// Initialize i = 1
loop2a:
	ldrb	temp,	[arrayBA,i]		// Load value of v[i] to temp
	mov	j,	i			// Initialize j = i
	sub	prej,	j,	1		// Set prej = j-1
	ldrb	preVal,	[arrayBA,prej]		// Load preVal is v[j-1]
	// Inner loop
loop2b:	
	cmp	j,	0			// Compare j with 0
	b.le	end1				// If j is less or equal to 0, loop ends, goes to end1
	cmp	temp,	preVal			// Compare temp with preVal
	b.ge	end1				// If greater or equal, loop ends, goes to end1
	
	strb	w23,	[arrayBA,j]		// Store value of v[j] into v[j-1]
	sub	j,	j,	1		// Decrease j by 1	
	sub	prej,	j,	1		// Set prej = j-1 again
	ldrb	w23,	[arrayBA,prej]		// Load value of v[j-1] into w23
	b	loop2b				// Branch to loop2b
// Ending of loop2a
end1:
	strb	temp,	[arrayBA,j]		// Store temp value intp v[i]
	add	i,	i,	1		// Increase i by 1
	
// Loop test of 2a
looptest:
	cmp	i,	50			// Compare i and 50
	b.lt	loop2a				// If less or equal, branch to loop2a

	ldr	x0,	=data2			// Get format for print statement
	bl	printf				// Call print function

	mov	i,	0			// Initialize i = 0 again

// Printing out sorted list
printloop:
	ldrb	w25,	[arrayBA,i]		// Loading w25 with v[i]
	ldr	x0,	=data3			// Get format for print statement
	mov	x1,	i			// Get index
	mov	w2,	w25			// Get value at the index
	bl	printf				// Calling print statement
	add	i,	i,	1		// Increase i by 1
	cmp	i,	50			// Compare i and 50
	b.lt	printloop			// if less than 50, branch to printloop again
	
	ldp	x29,	x30,	[sp],	dealloc	// restore FP and LR and deallocate memory
	ret					// end main
