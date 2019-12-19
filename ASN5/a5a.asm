// Minh Hang Chu 30074056
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 5: Part A

//Create an ARMv8 assembly language program

// Macros for registers
define(base_r, x24)
define(value, w9)
define(head_r, w19)
define(tail_r, w20)
define(j, w21)
define(count, w22)
define(i, w23)

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

    mov     value, w0                         // mov w0 to value
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

    ldr	base_r,	=head				// load address of head to base_r
    str	wzr,	[base_r]			// store zero register in base_r
    ldr	base_r,	=tail				// load address of tail to base_r
    str	wzr,	[base_r]			// store zero register in base_r
    b	new                           		// branch to new

newtail:
    ldr	base_r,	=tail				// load address of tail to base_r
    ldr	tail_r,	[base_r]			// load value in base_r into tail_r
    add	tail_r,	tail_r,	1			// increase tail_r
    and	tail_r,	tail_r,	MODMASK			// AND opertion with MODMASk
    str tail_r,	[base_r]                        // Store tail

new:
    ldr     tail_r, [base_r]                    // Load value in base_r into tail_r
    ldr	base_r,	=queue                      	// load address of queue into base_r
    str     value, [base_r, tail_r, SXTW 2]     // store value into new tail address

eqdone:
    ldp     x29, x30, [sp], 16                 	// resotre fp and link registers
    ret                                        	// end enqueue

// dequeue ---------------------------------------------------------------------------------------
    .global dequeue
dequeue:
    stp     x29, x30, [sp, -16]!                 // save fp register anf link register current value into stack
    mov     x29, sp                              // update fp register

    bl	queueEmpty				// branch to queueEmpty
    cmp	w0,	FALSE				// compare result with FALSE
    b.eq	dqnext				// if result is false, branch to dqnext

    ldr	x0,	=underflow			// load address of underflow print statement into x0
    bl	printf					// calling print function

    mov	x0,	-1				// move -1 into x0
    b	dqdone					// branch to dqdone

dqnext:
    ldr	base_r,	=head				// load address of head into base_r
    ldr	head_r,	[base_r]			// load value of base_r into head_r

    ldr	base_r,	=queue				// load address of queue into base_r
    ldr	value,	[base_r, head_r, sxtw 2]	// load value of head

    ldr	base_r,	=tail				// load address of tail to base_r
    ldr	tail_r,	[base_r]			// load value of base_r into tail_r

    cmp	head_r,	tail_r				// compare ead and tail values
    b.ne	newhead				// if not equal, branch to newhead

    mov	x25,	-1				// move -1 into x25
    ldr	base_r,	=head				// ldr address of head into base_r
    str	x25,	[base_r]			// store -1 into base_r
    ldr	base_r,	=tail				// load tail address into base_r
    str	x25,	[base_r]			// store -1 into base-r
    b	dqret					// branch to dqret

newhead:
    add	head_r,	head_r,	1			// increase head by 1
    and	head_r,	head_r,	MODMASK			// AND operation with MODMASk
    ldr	base_r,	=head				// load head address into base_r
    str	head_r,	[base_r]			// store head_r into base_r

dqret:
    mov	w0,	value				// move value into w0
dqdone:
    ldp	x29,	x30,	[sp],	16		// restore fp and link register
    ret						// end main

// queueFull--------------------------------------------------------------------------------
  .global queueFull
queueFull:
    stp	x29,	x30,	[sp,-16]!		// savr fp register and link register current on stack
    mov	x29,	sp				// update fp register

    ldr	base_r,	=head				// load head address into base_r
    ldr	head_r,	[base_r]			// load value of base_r into head_r

    ldr	base_r,	=tail				// load tail address into base_r	
    ldr	tail_r,	[base_r]			// load value of base_r into tail_r

    add	tail_r,	tail_r,	1			// increase tail_r by 1
    and	tail_r,	tail_r,	MODMASK			// AND operation with MODMASK

    cmp	head_r,	tail_r				// compare head and tail
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

    	ldr	base_r,	=head			// load head address into base_r
    	ldr	head_r,	[base_r]		// load value in base_r into head_r

    	cmp	head_r,	-1			// compare head_r and -1
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
	ldr	base_r,	=head			// load head address into base_r
	ldr	head_r,	[base_r]		// load value of base_r into head_r

	ldr	base_r,	=tail			// load tail address into base_r
	ldr	tail_r,	[base_r]		// load value of base_r into tail_r

	sub	count,	tail_r,	head_r		// count = tail - head
	add	count,	count, 1		// count = count + 1

	cmp	count,	0			// compare count and 0
	b.gt	printloop			// if greater than 0, branch to printloop
	add	count,	count,	QUEUESIZE	// count = count + QUEUESIZE

printloop:
	ldr	x0,	=currentq		// load currentq into x0
	bl	printf				// calling printf

	mov	i,	head_r			// move 0 into i
	mov	j,	0			// move 0 into j
	b	test				// branch to test

loop:
	ldr	base_r,	=queue			// load queue address into base_r

	ldr	w0,	=element		// load element address into w0
	ldr	w1,	[base_r, i, sxtw 2]	// load element value into w1
	bl	printf				// calling printf

	cmp	i,	head_r			// compare i and head
	b.ne	prnext				// if not equal, branch to prnext
	ldr	x0,	=headq			// load headq into x0
	bl	printf				// calling print f

prnext:
	cmp	i,	tail_r			// compare i and tail
	b.ne	loopend				// if not equal, branch ot loopend
	ldr	x0,	=tailq			// load tailq address into w0
	bl	printf				// calling print function

loopend:
	ldr	x0,	=space			// load space to x0
	bl	printf				// calling pritn fucntion

	add	i,	i,	1		// increase i by 1
	and	i,	i,	MODMASK		// AND operation with MODMASK

	add	j,	j,	1		// increase j by 1

test:	cmp	j,	count			// compare j and count
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
