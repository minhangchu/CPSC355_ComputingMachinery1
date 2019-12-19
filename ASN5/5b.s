












/** Strings representing months of the year */
jan_m:      .string "January"
feb_m:      .string "February"
mar_m:      .string "March"
apr_m:      .string "April"
may_m:      .string "May"
jun_m:      .string "June"
jul_m:      .string "July"
aug_m:      .string "August"
sep_m:      .string "September"
oct_m:      .string "October"
nov_m:      .string "November"
dec_m:      .string "December"

/** Strings representing seasons of the year */
win_m:      .string "Winter"
spr_m:      .string "Spring"
sum_m:      .string "Summer"
fal_m:      .string "Fall"

/** Strings representing suffixes */
th_m:		.string "th"
st_m:		.string "st"
nd_m:		.string "nd"
rd_m:		.string "rd"

/** Strings containing messages to display */
display:	.string "%s %d%s is %s\n"
usage:		.string "Usage: a5b mm dd\n"
err_msg:	.string "Error: Day is out of range for that month\n"

/** Initialize arrays in the .data section and doubleword aligned*/
            .data
            .balign 8
month_m:    .dword  jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m
suffix_m:   .dword  th_m, st_m, nd_m, rd_m
season_m:   .dword  win_m, spr_m, sum_m, fal_m

		    .text

            fp  .req x29
            lr  .req x30

            .balign 4
            .global main

main:       stp     fp, lr, [sp, -16]!								// Memory Allocations
            mov     fp, sp											// Update fp

            mov     w19, w0                  					// Store argc_c in w0
            mov     x20, x1                  					// Store arg_v in x1

            cmp     w19, 3                   					// Check that 3 command line arguments have been given
            b.eq    continue                    					// If true, branch to continue
            adrp    x0, usage                   					// else, prepare the error message
            add     x0, x0, :lo12:usage         					// Format lower 12 bits of usage
            bl      printf                      					// Call to printf
            b       done                        					// Branch to done (terminate program)

continue:   ldr     x0, [x20, 8]									// Load first command line arg into x0
            bl      atoi											// Convert arg to int
            mov     w21, w0										// Move the converted arg into w21

            ldr     x0, [x20, 16]								// Load second command line arg into x0
            bl      atoi											// Convert arg to int
            mov     w22, w0										// Move the converted arg into w22

            cmp     w21, 1										// if (month < 1) then,
            b.lt    error											// branch to error
            cmp     w21, 12										// if (month > 12) then,
            b.gt    error											// branch to error
            cmp     w22, 1										// if (day < 1) then
            b.lt    error											// branch to error
            cmp     w22, 31										// if (day > 31) then,
            b.gt    error											// branch to error

suffix_s:	cmp	    w22, 11										// else, if (day < 11)
		    b.lt	suffix											// branch to suffix
		    cmp	    w22, 13										// else if (day > 13)
		    b.gt	suffix											// branch to suffix
		    mov	    w3, 0										// else suffix = "th"

suffix:	    mov	    w24, 10											// w24 = 10 (for modulus)
		    udiv	w3, w22, w24							// suffix = day / 10
		    msub	w3, w24, w3, w22					// suffix = 10 - (suffix * day)
		    cmp	    w3, 3										// if (suffix <= 3)
		    b.le	season											// branch to season
		    mov	    w3, 0										// else, suffix = "th"
		    b	    season											// branch to season

season:		mov	    w26, w21							// tmp_month = month
		    cmp	    w22, 21										// if (day < 21) then,
		    b.lt	season1											// branch to season1
		    add	    w26, w26, 1						// else, tmp_month++

season1:	cmp	    w26, 12									// if (tmp_month <= 12)
		    b.le	winter											// branch to winter
		    mov	    w26, 1									// else, tmp_month = 1

winter:		cmp	    w26, 3									// if (tmp_month > 3)
		    b.gt	spring											// branch to spring
		    mov	    w25, 0										// w25 = winter
		    b	    output											// branch to output

spring:		cmp	    w26, 5									// if (tmp_month > 5)
		    b.gt	summer											// branch to summer
		    mov	    w25, 1										// w25 = spring
		    b	    output											// branch to output

summer:		cmp	    w26, 9									// if (month > 9)
		    b.gt	fall											// branch to fall
		    mov	    w25, 2										// else, season = summer
		    b	    output											// branch to output

fall:		mov	    w25, 3										// else, season = fall

output:

        ldr x0, =display

		    ldr	x26, =month_m				            // Get base address of month
		//    add	    x23, x23, :lo12:month_m		// Format lower 12 bits
		    sub	    w21, w21, 1				                // month - 1 (to account for having incremented it)
		    ldr	    x1, [x26, w21, SXTW 3]			    // Load first arg

		    mov	    w2, w22					                    // second arg

		    ldr	x27, =suffix_m				            // Get base address of suffix
	//	    add	    x22, x22, :lo12:suffix_m	// Format lower 12 bits
		    ldr	    x3, [x27, w3, SXTW 3]			// 3rd arg

		    ldr	x28, =season_m				            // Get base address of season
	//	    add	    x24, x24, :lo12:season_m	// Format lower 12 bits
		    ldr	    x4, [x28, w25, SXTW 3]			// 4th arg
		    bl	    printf					                        // call printf
		    b	    done					                        // branch to done

error:
        ldr x0, =err_msg
		    bl	    printf											// call printf

done:		ldp	    x29, x30, [sp], 16								// Deallocate space
		    ret
