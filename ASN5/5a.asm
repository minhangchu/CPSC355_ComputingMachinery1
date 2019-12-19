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

            mov     value, w0                               // val = w0
            bl      queueFull                               // branch to queueFull
            cmp     w0, TRUE                                // Compare results to TRUE
            b.ne    eqnext                                   // if not equal, branch to en_if

            ldr	x0,	=overflow
            bl      printf                                  // branch to printf
            b       eqdone                                 // branch to en_done

eqnext:      bl      queueEmpty                              // branch to queueEmpty
            cmp     w0, TRUE                                // Compare results to TRUE
            b.ne    newtail                                 // if not equal, branch to en_else

            ldr	base_r,	=head
            str	wzr,	[base_r]
            ldr	base_r,	=tail
            str	wzr,	[base_r]
            b	new                           // branch to en_body

newtail:
	           ldr	base_r,	=tail
            	ldr	tail_r,	[base_r]
            	add	tail_r,	tail_r,	1
            	and	tail_r,	tail_r,	MODMASK
            	str tail_r,	[base_r]                     // Store tail

new:
          ldr     tail_r, [base_r]                        // Load tail
          ldr	base_r,	=queue                       // format lower 12 bits
          str     value, [base_r, tail_r, SXTW 2]       // store value

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
    ldr	base_r,	=head
    ldr	head_r,	[base_r]

    ldr	base_r,	=queue
    ldr	value,	[base_r, head_r, sxtw 2]

    ldr	base_r,	=tail
    ldr	tail_r,	[base_r]

    cmp	head_r,	tail_r
    b.ne	newhead

    mov	x25,	-1
    ldr	base_r,	=head
    str	x25,	[base_r]
    ldr	base_r,	=tail
    str	x25,	[base_r]
    b	dqret

    newhead:
    add	head_r,	head_r,	1
    and	head_r,	head_r,	MODMASK
    ldr	base_r,	=head
    str	head_r,	[base_r]

    dqret:
    mov	w0,	value
    dqdone:
    ldp	x29,	x30,	[sp],	16
    ret

    queueFull:
    	stp	x29,	x30,	[sp,-16]!
    	mov	x29,	sp

    	ldr	base_r,	=head
    	ldr	head_r,	[base_r]

    	ldr	base_r,	=tail
    	ldr	tail_r,	[base_r]

    	add	tail_r,	tail_r,	1
    	and	tail_r,	tail_r,	MODMASK

    	cmp	head_r,	tail_r
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

    	ldr	base_r,	=head
    	ldr	head_r,	[base_r]

    	cmp	head_r,	-1
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

	ldr	base_r,	=head
	ldr	head_r,	[base_r]

	ldr	base_r,	=tail
	ldr	tail_r,	[base_r]

	sub	count,	tail_r,	head_r
	add	count,	count, 1

	cmp	count,	0
	b.gt	printloop
	add	count,	count,	QUEUESIZE

printloop:
	ldr	x0,	=currentq
	bl	printf

	mov	i,	head_r
	mov	j,	0
	b	test

loop:
	ldr	base_r,	=queue

	ldr	w0,	=element
	ldr	w1,	[base_r, i, sxtw 2]
	bl	printf

	cmp	i,	head_r
	b.ne	prnext
	ldr	x0,	=headq
	bl	printf

prnext:
	cmp	i,	tail_r
	b.ne	loopend
	ldr	x0,	=tailq
	bl	printf

loopend:
	ldr	x0,	=space
	bl	printf

	add	i,	i,	1
	and	i,	i,	MODMASK

	add	j,	j,	1

test:	cmp	j,	count
	b.lt	loop

dpdone:
	ldp	x29,	x30,	[sp],	16
	ret
