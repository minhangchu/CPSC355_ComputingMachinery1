// Minh Hang Chu 30074056
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 5: Part A

//Create an ARMv8 assembly language program

// Macros for registers








// Constants
QUEUESIZE = 8
MODMASK = 0x7
TRUE = 1
FALSE = 0

// Format for printing
  .text
overflow: .string "\nQueue overflow! Cannot enqueue into a full queue.\n"
underflow:.string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
emptyq:   .string "\nEmpty queue\n"
currentq: .string "\nCurrent queue contents:\n"
element:  .string "  %d"
headq:    .string " <-- head of queue"
tailq:    .string " <-- tail of queue"
space:    .string "\n"

            .balign 4

// Enqueue method----------------------------------------------------------------------------
  .global enqueue
enqueue:
    stp     x29, x30, [sp, -16]!              // save fp register and link register current values on stack   
    mov     x29, sp                           // update frame pointer

    mov     w9, w0                         // mov w0 to w9
    bl      queueFull                         // branch to queueFull
    cmp     w0, TRUE                          // Compare results to TRUE
    b.ne    eqnext                            // if not equal, branch to eqnext

    ldr	x0,	=overflow			// load address of print statement to xo
    bl      printf				// calling print function
    b       eqdone				// branch to eqdone

eqnext:
    bl      queueEmpty  			// calling to check if queue is empty
    cmp     w0, TRUE                            // compare result with TRUE
    b.ne    newtail                             // if result is not true, branch to new tail

    ldr	x24,	=head				// load address of head to x24
    str	wzr,	[x24]			// store zero register in x24
    ldr	x24,	=tail				// load address of tail to x24
    str	wzr,	[x24]			// store zero register in x24
    b	new                           		// branch to new

newtail:
    ldr	x24,	=tail				// load address of tail to x24
    ldr	w20,	[x24]			// load w9 in x24 into w20
    add	w20,	w20,	1			// increase w20
    and	w20,	w20,	MODMASK			// AND opertion with MODMASk
    str w20,	[x24]                        // Store tail

new:
    ldr     w20, [x24]                    // Load w9 in x24 into w20
    ldr	x24,	=queue                      	// load address of queue into x24
    str     w9, [x24, w20, SXTW 2]     // store w9 into new tail address

eqdone:
    ldp     x29, x30, [sp], 16                 	// resotre fp and link registers
    ret                                        	// end enqueue

// dequeue ---------------------------------------------------------------------------------------
    .global dequeue
dequeue:
    stp     x29, x30, [sp, -16]!                 // save fp register anf link register current w9 into stack
    mov     x29, sp                              // update fp register

    bl	queueEmpty				// branch to queueEmpty
    cmp	w0,	FALSE				// compare result with FALSE
    b.eq	dqnext				// if result is false, branch to dqnext

    ldr	x0,	=underflow			// load address of underflow print statement into x0
    bl	printf					// calling print function

    mov	x0,	-1				// move -1 into x0
    b	dqdone					// branch to dqdone

dqnext:
    ldr	x24,	=head				// load address of head into x24
    ldr	w19,	[x24]			// load w9 of x24 into w19

    ldr	x24,	=queue				// load address of queue into x24
    ldr	w9,	[x24, w19, sxtw 2]	// load w9 of head

    ldr	x24,	=tail				// load address of tail to x24
    ldr	w20,	[x24]			// load w9 of x24 into w20

    cmp	w19,	w20				// compare ead and tail values
    b.ne	newhead				// if not equal, branch to newhead

    mov	x25,	-1				// move -1 into x25
    ldr	x24,	=head				// ldr address of head into x24
    str	x25,	[x24]			// store -1 into x24
    ldr	x24,	=tail				// load tail address into x24
    str	x25,	[x24]			// store -1 into base-r
    b	dqret					// branch to dqret

newhead:
    add	w19,	w19,	1			// increase head by 1
    and	w19,	w19,	MODMASK			// AND operation with MODMASk
    ldr	x24,	=head				// load head address into x24
    str	w19,	[x24]			// store w19 into x24

dqret:
    mov	w0,	w9				// move w9 into w0
dqdone:
    ldp	x29,	x30,	[sp],	16		// restore fp and link register
    ret						// end main

// queueFull--------------------------------------------------------------------------------
  .global queueFull
queueFull:
    stp	x29,	x30,	[sp,-16]!		// savr fp register and link register current on stack
    mov	x29,	sp				// update fp register

    ldr	x24,	=head				// load head address into x24
    ldr	w19,	[x24]			// load w9 of x24 into w19

    ldr	x24,	=tail				// load tail address into x24	
    ldr	w20,	[x24]			// load w9 of x24 into w20

    add	w20,	w20,	1			// increase w20 by 1
    and	w20,	w20,	MODMASK			// AND operation with MODMASK

    cmp	w19,	w20				// compare head and tail
    b.ne	fullf				// If not equal, branch to fullf
    mov	x0,	TRUE				// move TRUE into x0
    b	fdone					// branch to fdone
fullf:
    mov	x0,	FALSE				// move FALSE into x0
fdone:
    ldp	x29,	x30,	[sp],	16		// restore fp and link registers
    ret						// end 

    //queueEmpty-----------------------------------------------------------------------------
    	.global	queueEmpty
queueEmpty:
    	stp	x29,	x30,	[sp,-16]!	// save fp register and link registers on stack
    	mov	x29,	sp			// update fp register

    	ldr	x24,	=head			// load head address into x24
    	ldr	w19,	[x24]		// load w9 in x24 into w19

    	cmp	w19,	-1			// compare w19 and -1
    	b.ne	emptyf				// if not equal, branch to emptyf
    	mov	x0,	TRUE			// move TRUE into x0
    	b	etdone				// branch to etdone

emptyf:
    	mov	x0,	FALSE			// move FALSE into w0
etdone:
    	ldp	x29,	x30,	[sp],	16	// restore fp and link register
    	ret					// end 
    //----------------------------------------------------------------------------------------

    .global display
display:
	stp	x29,	x30,	[sp,-16]!	// save fp registers and link registers on stack
	mov	x29,	sp			// update fp registers

	bl	queueEmpty			// branch to queueempty
	cmp	w0,	TRUE			// if results  not = TRUE
	b.ne	dpnext				// branch to dpnext

	ldr	x0,	=emptyq			// load address of emptyq string
	bl	printf				// calling printf
	b	dpdone				// branch dpdone

dpnext:
	ldr	x24,	=head			// load head address into x24
	ldr	w19,	[x24]		// load w9 of x24 into w19

	ldr	x24,	=tail			// load tail address into x24
	ldr	w20,	[x24]		// load w9 of x24 into w20

	sub	w22,	w20,	w19		// w22 = tail - head
	add	w22,	w22, 1		// w22 = w22 + 1

	cmp	w22,	0			// compare w22 and 0
	b.gt	printloop			// if greater than 0, branch to printloop
	add	w22,	w22,	QUEUESIZE	// w22 = w22 + QUEUESIZE

printloop:
	ldr	x0,	=currentq		// load currentq into x0
	bl	printf				// calling printf

	mov	w23,	w19			// move 0 into w23
	mov	w21,	0			// move 0 into w21
	b	test				// branch to test

loop:
	ldr	x24,	=queue			// load queue address into x24

	ldr	w0,	=element		// load element address into w0
	ldr	w1,	[x24, w23, sxtw 2]	// load element w9 into w1
	bl	printf				// calling printf

	cmp	w23,	w19			// compare w23 and head
	b.ne	prnext				// if not equal, branch to prnext
	ldr	x0,	=headq			// load headq into x0
	bl	printf				// calling print f

prnext:
	cmp	w23,	w20			// compare w23 and tail
	b.ne	loopend				// if not equal, branch ot loopend
	ldr	x0,	=tailq			// load tailq address into w0
	bl	printf				// calling print function

loopend:
	ldr	x0,	=space			// load space to x0
	bl	printf				// calling pritn fucntion

	add	w23,	w23,	1		// increase w23 by 1
	and	w23,	w23,	MODMASK		// AND operation with MODMASK

	add	w21,	w21,	1		// increase w21 by 1

test:	cmp	w21,	w22			// compare w21 and w22
	b.lt	loop				// if less than, branch to loop

dpdone:
	ldp	x29,	x30,	[sp],	16	// restore fp anf link register
	ret					// end display

// data section contains initialized global variable
  .data
head:       .word   -1
tail:       .word   -1

// bss section contains uninitialized variables
  .bss
queue:      .skip   QUEUESIZE * 4
