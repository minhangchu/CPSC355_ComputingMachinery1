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
define(argc, w19)
define(argv, x20)
define(month_r, w21)
define(day_r, w22)
define(season_r,w23)
define(temp,w24)
define(suffix_r,w25)

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

	mov	argc, w0			// move w0 into argc
	mov	argv,	x1			// move w1 into argv

// Month
	cmp	argc,	3			// compare number of arguments with 3
	b.ne	error				// if not equal, branch to error message

	ldr	x0,	[argv, 8]		// load the first argument
	bl	atoi				// convert from string to integer
	mov	month_r,	w0		// mov the value of w0 into month_r

	cmp     month_r,	1		// If argument month is less than 1
	b.lt    error				// branch to error message
	cmp     month_r,	12		// if argument month is more than 12
	b.gt    error				// branch to error message

/// date and suffix
	ldr	x0,	[argv,16]		// load the second argument
	bl	atoi				// convert from string to integer
	mov	day_r,		w0		// move	the value of w0 into day_r

	cmp     day_r, 31			// compare input day with 31
	b.gt    error				// if more than 31, branch to error message
	cmp     day_r, 1			// comapare day with 0
	b.le    error				// if less or equal, branch to error message

	cmp day_r,	11			// If day is less than 11
	b.lt	getSuffix			// branch to get suffix
	cmp	day_r,	13			// If day is more than 13
	b.gt	getSuffix			// branch to get suffix
	mov	suffix_r,0			// otherwise, suffix will be 0 (th)

getSuffix:
	mov	temp,	10				// set temp = 10
	udiv	suffix_r,	day_r,temp		// devide the day by 10 to get the lst degit
	msub	suffix_r,	temp,	suffix_r,day_r	// calculate suffix = 10 - (suffix*day)

	cmp	suffix_r,	3			// If suffix is less than or equal 3
	b.le getSeason					// branch to getSeason
	mov	suffix_r,	0			// otherwise, suffix will be th
	b getSeason					// branch to getSeason

getSeason:
	mov	temp,	month_r			// move month into temp
	cmp	day_r,	21			// compare day and 21
	b.lt	seasonCheck			// If less than 21, branch to season checl
	add	temp,	temp,	1		// increase temp month by 1

seasonCheck:
	cmp	temp,	12			// If temp is less than 12
	b.le	winC				// branch to winter check
	mov	temp,	1			// else move temp = 1

winC:
	cmp	temp,	3			// If temp is greater than 3
	b.gt	sprC				// branch to Spring check
	mov	season_r,	0		// temp <= 3, set season winter
	b	output				// branch to print output

sprC:
	cmp	temp,	5			// If temp is greater than 5
	b.gt	sumC				// branch to Summer check
	mov	season_r,	1		// temp is <= 5, set season Spring
	b	output				// branch to print output
sumC:
	cmp	temp,	9			// If temp is greater than 9
	b.gt	falC				// branch to Fall Check
	mov	season_r,	2		// temp <= 9, set season to Summer
	b	output				// Branch to print output

falC:
	mov	season_r,	3		// Set season Fall

output:
	ldr	x0,	=outputm		// load the address of output print statement

	sub month_r,	month_r,	1	// subtract month by 1
	ldr	x26,	=month			// load the address of month
	ldr	x1,	[x26,month_r,sxtw 3]	// load month strng into x1

	mov	w2,	day_r			// load day into w2

	ldr	x27,	=suffix			// load suffix array address into x27
	ldr	x3,	[x27, suffix_r, sxtw 3]	// load suffix into x3

	ldr	x28,	=season			// load season address into x28
	ldr	x4,	[x28,	season_r,sxtw 3]// load season into x4

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
