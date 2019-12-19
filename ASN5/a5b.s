// Minh Hang Chu 30074056
// Univesity of Calgary
// Prof: Tamer Jarada
// TA: AbdelGhani Guerbas
// Assignment 5: Part B

//Create an ARMv8 assembly language program that accepts 2 strings mm dd

// Format for printing
errorm:	.string "usage:	a5b mm dd\n"
outputm:	.string "%s %d%s is %s\n"

// Macros for registers








// All strings
	.text
win:    .string "Winter"
spr:    .string "Spring"
sum:    .string "Summer"
fal:    .string "Fall"

jan:    .string "January"
feb:    .string "Febuary"
mar:    .string "March"
apr:    .string "April"
may:    .string "May"
jun:    .string "June"
jul:    .string "July"
aug:    .string "August"
sep:    .string "September"
oct:    .string "October"
nov:    .string "November"
dec:    .string "December"

st:     .string "st"
nd:     .string "nd"
rd:     .string "rd"
th:     .string "th"

	.balign	4
	.global	main
main:
	stp	x29,	x30,	[sp,-16]!	// Allocate memory and store FP and LR
	mov	x29,	sp			// FP gets the address of fram record	

	mov	w19, w0			// move w0 into w19
	mov	x20,	x1			// move w1 into x20

// Month
	cmp	w19,	3			// compare number of arguments with 3
	b.ne	error				// if not equal, branch to error message

	ldr	x0,	[x20, 8]		// load the first argument
	bl	atoi				// convert from string to integer
	mov	w21,	w0		// mov the value of w0 into w21

	cmp     w21,	1		// If argument month is less than 1
	b.lt    error				// branch to error message
	cmp     w21,	12		// if argument month is more than 12
	b.gt    error				// branch to error message

/// date and suffix
	ldr	x0,	[x20,16]		// load the second argument
	bl	atoi				// convert from string to integer
	mov	w22,		w0		// move	the value of w0 into w22

	cmp     w22, 31			// compare input day with 31
	b.gt    error				// if more than 31, branch to error message
	cmp     w22, 1			// comapare day with 0
	b.le    error				// if less or equal, branch to error message

	cmp w22,	11			// If day is less than 11
	b.lt	getSuffix			// branch to get suffix
	cmp	w22,	13			// If day is more than 13
	b.gt	getSuffix			// branch to get suffix
	mov	w25,0			// otherwise, suffix will be 0 (th)

getSuffix:
	mov	w24,	10				// set w24 = 10
	udiv	w25,	w22,w24		// devide the day by 10 to get the lst degit
	msub	w25,	w24,	w25,w22	// calculate suffix = 10 - (suffix*day)

	cmp	w25,	3			// If suffix is less than or equal 3
	b.le getSeason					// branch to getSeason
	mov	w25,	0			// otherwise, suffix will be th
	b getSeason					// branch to getSeason

getSeason:
	mov	w24,	w21			// move month into w24
	cmp	w22,	21			// compare day and 21
	b.lt	seasonCheck			// If less than 21, branch to season checl
	add	w24,	w24,	1		// increase w24 month by 1

seasonCheck:
	cmp	w24,	12			// If w24 is less than 12
	b.le	winC				// branch to winter check
	mov	w24,	1			// else move w24 = 1

winC:
	cmp	w24,	3			// If w24 is greater than 3
	b.gt	sprC				// branch to Spring check
	mov	w23,	0		// w24 <= 3, set season winter
	b	output				// branch to print output

sprC:
	cmp	w24,	5			// If w24 is greater than 5
	b.gt	sumC				// branch to Summer check
	mov	w23,	1		// w24 is <= 5, set season Spring
	b	output				// branch to print output
sumC:
	cmp	w24,	9			// If w24 is greater than 9
	b.gt	falC				// branch to Fall Check
	mov	w23,	2		// w24 <= 9, set season to Summer
	b	output				// Branch to print output

falC:
	mov	w23,	3		// Set season Fall

output:
	ldr	x0,	=outputm		// load the address of output print statement

	sub w21,	w21,	1	// subtract month by 1
	ldr	x26,	=month			// load the address of month
	ldr	x1,	[x26,w21,sxtw 3]	// load month strng into x1

	mov	w2,	w22			// load day into w2

	ldr	x27,	=suffix			// load suffix array address into x27
	ldr	x3,	[x27, w25, sxtw 3]	// load suffix into x3

	ldr	x28,	=season			// load season address into x28
	ldr	x4,	[x28,	w23,sxtw 3]// load season into x4

	bl printf				// calling print f
	b	done				// branch to done

error:
	ldr	x0,	=errorm			// loaf address of error message
	bl 	printf				// calling print function

done:
	ldp	x29,	x30,	[sp],	16	// resotr FP and LR and deallocate stack space							
	ret					// end main

// Global variables
// An array of months, seasons and suffix
	.data
	.balign	8
month:	.dword	jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec
season:	.dword	win,spr,sum,fal
suffix:	.dword	th,st,nd,rd
