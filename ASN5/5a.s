







// Constants
QUEUESIZE = 8
MODMASK = 0x7
TRUE = 1
FALSE = 0

            .data
head:       .word   -1
tail:       .word   -1

            .bss
queue:      .skip   QUEUESIZE * 4

            .text
overflow:   .string "\nQueue overflow! Cannot enqueue into a full queue.\n"
underflow:  .string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
emptyq:      .string "\nEmpty queue\n"
currentq:    .string "\nCurrent queue contents:\n"
element:    .string "  %d"
headq:     .string " <-- head of queue"
tailq:     .string " <-- tail of queue"
space:    .string "\n"

            .balign 4

  .global enqueue
enqueue:    stp     x29, x30, [sp, -16]!                      // Allocate Memory
            mov     x29, sp                                  // Update x29

            mov     w9, w0                               // val = w0
            bl      queueFull                               // branch to queueFull
            cmp     w0, TRUE                                // Compare results to TRUE
            b.ne    eqnext                                   // if not equal, branch to en_if

            ldr	x0,	=overflow
            bl      printf                                  // branch to printf
            b       eqdone                                 // branch to en_done

eqnext:      bl      queueEmpty                              // branch to queueEmpty
            cmp     w0, TRUE                                // Compare results to TRUE
            b.ne    newtail                                 // if not equal, branch to en_else

            ldr	x24,	=head
            str	wzr,	[x24]
            ldr	x24,	=tail
            str	wzr,	[x24]
            b	new                           // branch to en_body

newtail:
	           ldr	x24,	=tail
            	ldr	w20,	[x24]
            	add	w20,	w20,	1
            	and	w20,	w20,	MODMASK
            	str w20,	[x24]                     // Store tail

new:
          ldr     w20, [x24]                        // Load tail
          ldr	x24,	=queue                       // format lower 12 bits
          str     w9, [x24, w20, SXTW 2]       // store w9

eqdone:    ldp     x29, x30, [sp], 16                        // Deallocate
          ret                                             // return

.global dequeue
dequeue:    stp     x29, x30, [sp, -16]!                      // allocate space
            mov     x29, sp                                  // update x29

            bl	queueEmpty
    cmp	w0,	FALSE
    b.eq	dqnext

    ldr	x0,	=underflow
    bl	printf

    mov	x0,	-1
    b	dqdone

    dqnext:
    ldr	x24,	=head
    ldr	w19,	[x24]

    ldr	x24,	=queue
    ldr	w9,	[x24, w19, sxtw 2]

    ldr	x24,	=tail
    ldr	w20,	[x24]

    cmp	w19,	w20
    b.ne	newhead

    mov	x25,	-1
    ldr	x24,	=head
    str	x25,	[x24]
    ldr	x24,	=tail
    str	x25,	[x24]
    b	dqret

    newhead:
    add	w19,	w19,	1
    and	w19,	w19,	MODMASK
    ldr	x24,	=head
    str	w19,	[x24]

    dqret:
    mov	w0,	w9
    dqdone:
    ldp	x29,	x30,	[sp],	16
    ret

    queueFull:
    	stp	x29,	x30,	[sp,-16]!
    	mov	x29,	sp

    	ldr	x24,	=head
    	ldr	w19,	[x24]

    	ldr	x24,	=tail
    	ldr	w20,	[x24]

    	add	w20,	w20,	1
    	and	w20,	w20,	MODMASK

    	cmp	w19,	w20
    	b.ne	fullf
    	mov	x0,	TRUE
    	b	fdone
    fullf:
    	mov	x0,	FALSE
    fdone:
    	ldp	x29,	x30,	[sp],	16
    	ret

    //----------------------------------------------------------------------------------------

    	.global	queueEmpty
    queueEmpty:
    	stp	x29,	x30,	[sp,-16]!
    	mov	x29,	sp

    	ldr	x24,	=head
    	ldr	w19,	[x24]

    	cmp	w19,	-1
    	b.ne	emptyf
    	mov	x0,	TRUE
    	b	etdone

    emptyf:
    	mov	x0,	FALSE
    etdone:
    	ldp	x29,	x30,	[sp],	16
    	ret
    //----------------------------------------------------------------------------------------

    .global display
display:
	stp	x29,	x30,	[sp,-16]!
	mov	x29,	sp

	bl	queueEmpty
	cmp	w0,	TRUE
	b.ne	dpnext

	ldr	x0,	=emptyq
	bl	printf
	b	dpdone

dpnext:

	ldr	x24,	=head
	ldr	w19,	[x24]

	ldr	x24,	=tail
	ldr	w20,	[x24]

	sub	w22,	w20,	w19
	add	w22,	w22, 1

	cmp	w22,	0
	b.gt	printloop
	add	w22,	w22,	QUEUESIZE

printloop:
	ldr	x0,	=currentq
	bl	printf

	mov	w23,	w19
	mov	w21,	0
	b	test

loop:
	ldr	x24,	=queue

	ldr	w0,	=element
	ldr	w1,	[x24, w23, sxtw 2]
	bl	printf

	cmp	w23,	w19
	b.ne	prnext
	ldr	x0,	=headq
	bl	printf

prnext:
	cmp	w23,	w20
	b.ne	loopend
	ldr	x0,	=tailq
	bl	printf

loopend:
	ldr	x0,	=space
	bl	printf

	add	w23,	w23,	1
	and	w23,	w23,	MODMASK

	add	w21,	w21,	1

test:	cmp	w21,	w22
	b.lt	loop

dpdone:
	ldp	x29,	x30,	[sp],	16
	ret
