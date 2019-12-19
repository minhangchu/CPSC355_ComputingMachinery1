// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 4: Structures and Subroutines

//Create an ARMv8 assembly language program that implements algorithm

// Format for printing

print1:	.string "Initial box values:\n"

print2:	.string "first"

print3:	.string "second"

print4:	.string "\nChanged box values:\n"

print5: .string "Box %s origin = (%d, %d) width = %d height = %d area = %d\n"

alloc	= -(16 + 20) & -16			
        .equ    dealloc,   -alloc
	.balign 4

//----------------------------- Struct --------------------------------------

point:							// Struct for point
	x = 0						// offset for point x, x is an interger
	y = 4						// offset for point y, y is an integer					
dimension:						// Struct for dimension
	width = 0					// offset for width (integer)
	height = 4					// offset for width (integer)

box:							// struct for box
	origin = 0					// offset for box origin
	bdimension = 8					// offset for bdimension
	area = 16					// offset for box area

newBox:
	stp	x29,	x30,	[sp, alloc]!		// (16B FrameRecord + 20B) & -16	
	mov	x29,	sp				// deallocate space is negation of allocating space. To be released at the end main
	
	mov	w9,	0				// move 0 to w9
	mov	w10,	1				// move 1 to w10

	str	w9,	[x8,	origin + x]		// store 0 to origin x
	str	w9,	[x8,	origin + y]		// store 0 to origin y
	str	w10,	[x8,	bdimension + width]	// store 1 to width of the box
	str	w10,	[x8,	bdimension + height]	// store 1 to height of the box
	str	w10,	[x8,	area]			// store 1 to area of the box

	ldp	x29,	x30,	[sp],	dealloc		// restore FP and LR and deallocate memory
	ret						// end main

move:
	stp	x29,	x30,	[sp,alloc]!		// (16B FrameRecord + 20B) & -16
	mov	x29,	sp				// deallocate space is negation of allocating space. To be released at the end main
	
	ldr	w21,	[x8, origin + x]		// load value of origin x to x21
	add 	w21,	w21,	-5			// add origin x to -5
	str	w21,	[x8, origin + x]		// store value of origin x to stack

	ldr	w21,	[x8, origin + y]		// load value of origin y to x21
	add 	w21,	w21,	7			// add origin y to 7
	str	w21,	[x8, origin + y]		// store value of origin x to stack

	ldp	x29,	x30,	[sp], dealloc		// restore FP and LR and deallocate memory
	ret						// end main

expand:
	stp	x29,	x30,	[sp,alloc]!		// (16B FrameRecord + 20B) & -16
	mov	x29,	sp				// deallocate space is negation of allocating space. To be released at the end main

	mov	w1,	3				// move w1 = 3

	ldr	w21,	[x8, bdimension + width]	// load value of width to x21
	mul 	w21,	w21,	w1			// multiply width with 3
	str	w21,	[x8, bdimension + width]	// store width into stack

	ldr	w22,	[x8, bdimension + height]	// load value of height to x21
	mul 	w22,	w22,	w1			// multiply heigth with 3
	str	w22,	[x8, bdimension + height]	// store height into stack

	mul	w21,	w21,	w22			// multiply w21 with w22 to get area
	str	w21,	[x8, area]			// store area of box to the stack

	ldp	x29,	x30,	[sp],	dealloc		// restore FP and LR and deallocate memory
	ret						// end main

printBox:
	stp	x29,	x30,	[sp,alloc]!		// (16B FrameRecord + 20B) & -16
	mov	x29,	sp				// deallocate space is negation of allocating space. To be released at the end main
	
	adrp	x0,	print5				// load string to print
	add	x0,	x0,	:lo12:print5		// load string to print

	ldr	w2,	[x8, origin + x]		// load origin x to w2
	ldr	w3,	[x8, origin + y]		// load origin y to w3
	ldr	w4,	[x8, bdimension + width]	// load width to w4
	ldr 	w5,	[x8, bdimension + height]	// load height to w5
	ldr	w6,	[x8, area]			// load area to w6
	bl	printf					// calling print funciton
	
	ldp	x29,	x30,	[sp],	dealloc		// restore FP and LR and deallocate memory
	ret						// end main

equal:
	stp	x29,	x30,	[sp,-16]!		// (16B FrameRecord + 20B) & -16
	mov	x29,	sp				// deallocate space is negation of allocating space. To be released at the end main
	mov	x23,	0				// set x23 equal 0, false
	add	x19,	x29,	16			// set x19 to be address of box 1
	add	x20,	x29,	16+20			// set x20 to be address of box 2
	
	ldr	x21,	[x19, origin + x]		// Load origin x of box 1
	ldr	x22,	[x20, origin + x]		// Load origin x of box 2
	cmp	x21,	x22				// compare origin x of 2 box
	b.ne	false					// if not equal, goes to false

	ldr	x21,	[x19, origin + y]		// load origin y of box 1
	ldr	x22,	[x20, origin + y]		// load origin y of box 2
	cmp	x21,	x22				// compare origin y of 2 box
	b.ne	false					// if not equal, goes to false

	ldr	x21,	[x19, bdimension + width]	// load width of box 1
	ldr	x22,	[x20, bdimension + width]	// load width of box 2
	cmp	x21,	x22				// compare width of 2 boxes
	b.ne	false					// if not equal, goes to false

	ldr	x21,	[x19, bdimension + height]	// load height of box 1
	ldr	x22,	[x20, bdimension + height]	// load height of box 2
	cmp	x21,	x22				// compare heigth of 2 boxes
	b.ne	false					// if not equal, goes to false

	mov	x23,	1				// set x 23 = 1, true
	b	end					// branch to end

false:	
	mov	x23,	0				// set x23 = 0, false

end:
	ldp	x29,	x30,	[sp],	16		// restore FP and LR and deallocate memory	
	ret						// end main

	
//------------------------------------------- MAIN ------------------------------------

alloc_m	= -(16 + 40) & -16				// allocate space needed for main function
        .equ    dealloc_m,   -alloc_m			// deallocate = -allocate


	.balign 4					
	.global main					// Start main function 
main:
	stp	x29,	x30,	[sp, alloc_m]!		// (16B FrameRecord + 20B) & -16
	mov	x29,	sp				// deallocate space is negation of allocating space. To be released at the end main
	
	mov	x8,	x29				// x8 has the address of struct box 1
	add	x8,	x8,	16
	bl	newBox
		
	mov	x8,	x29				// x8 has the address of struct box 2
	add	x8,	x8,	16+20
	bl	newBox

	ldr	x0,	=print1				// load print statement 1
	bl	printf					// calling print function

	// Printbox
	mov	x8,	x29				// x8 has the address of struct box 1
	add	x8,	x8,	16
	adrp	x1,	print2				// loading print statement
	add	x1,	x1, :lo12:print2	
	ldr	x2,	[x29, 16]			// loading the address of box 1
	bl 	printBox				// calling printBox

	mov	x8,	x29				// x8 has the address of struct box 2
	add	x8,	x8,	16+20
	adrp	x1,	print3
	add	x1,	x1, :lo12:print3		// loading print statement
	ldr	x2,	[x29,16+20]			// loading the address of box 2
	bl 	printBox				// caling printBox

	mov	x8,	x29
	add	x8,	x8,	16			// x8 has the address of box 1
	mov	x9,	x29
	add	x9,	x9,	16+20			// x9 has the address of box 2
	bl	equal					// calling equl

	cmp	x23,	0				// Compare result of equal with 0
	b.ne	next					// If not equal, goes to next

	mov	x8,	x29				// x8 has the address of box 1
	add	x8,	x8,	16
	mov	x0,	x19				// load the address of box 1
	mov	w1,	-5				// load -5 to 2nd argument
	mov	w2,	7				// loaf 7 to 3rd argument
	bl	move					// calling move 

	mov	x8,	x29		
	add	x8,	x8,	16+20			// x8 has the address of box  2
	mov	x0,	x20				// load the address of box 2 to register
	mov	w1,	3				// mov 3 to 2nd argument
	bl	expand					// calling expand

next:
	ldr	x0,	=print4				// load printstatement 4
	bl	printf					// calling print function

	// Printbox
	mov	x8,	x29
	add	x8,	x8,	16			// x8 has the address of struct box 1
	adrp	x1,	print2				// loading print statement
	add	x1,	x1, :lo12:print2
	ldr	x2,	[x29, 16]			// loading address of box 1
	bl 	printBox				// calling print box

	mov	x8,	x29
	add	x8,	x8,	16+20			// x8 has the address of box 2
	adrp	x1,	print3	
	add	x1,	x1, :lo12:print3		// loading print statement
	ldr	x2,	[x29,16+20]			// loading address of box 2
	bl 	printBox				// calling print box

	ldp	x29,	x30,	[sp],	dealloc_m	// restore FP and LR and deallocate memory	
	ret						// end main
