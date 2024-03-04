#####################################################################
# Programmer: Jacob St Lawrence
# Last Modified: 05.09.2023
#####################################################################
# Functional Description:
# This program prompts the user to select from a menu. Depending
# on their selection, it will then do one of the following:
# 1. Prompt the user for integer n, then calculate and display
#    fibonacci(n).
# 2. Prompt the user for a list of integers, then check and display
#    whether any duplicate integers exist in the list.
# 3. Prompt the user for two values a and b, then calculate and
#    display the greatest common divisor of a and b.
#####################################################################
# Pseudocode:
#
# main:
#	cout << selPrompt
#	cin >> s0
#	if (s0 == 1), branch to recProc
#	if (s0 == 2), branch to dupCheck
#	if (s0 == 3), branch to ANS
#	if (s0 == 0), branch to exit
#	else, print error
# recProc:
#	cout << promptRec
#	cin >> NUMTIMES
#	int fibonacci(NUMTIMES)
#	print results
#	b	main
# fibonacci:
#	if (NUMTIMES <= 1), return NUMTIMES
#	else NUMTIMES = fibonacci(NUMTIMES - 1) + fibonacci(NUMTIMES - 2)
# dupCheck:
#	cout << promptDup
#	s2 = pointer to intList
# readList:
#	read int into 0($s2)
#	s2 ++
#	while 0($s2) >= 0, branch to readList
#	reset s2 as pointer to intList
# dupLoopOuter:
#	s3 = pointer s2 + 4
#	if ($s2 <= 0), dupFalse
#	call dupLoopInner
#	s2 ++
#	b	dupLoopInner
# dupLoopInner:
#	if ($s3 < 0), done with inner
#	if ($s2 == $s3), dupTrue
#	s3 ++
#	b	dupLoopOuter
# ANS:
#	cout << promptGCD
#	cin >> a >> b
#	call GCD
#	cout << result
#	b	main
# GCD:
#	while ((a % b)> 0)
#		a = b
#		b = a % b
#	return b as result
# exit:
#	cout << Goodbye!
#	terminate program
#
#####################################################################
# Register Usage:
# $s0: Menu Selection
# $s1: Result of Fibonacci Function
# $s2: Pointer to Integer List (Outer Loop)
# $s3: Pointer to Integer List (Inner Loop)
# $s4: GCD Value A
# $s5: GCD Value B
# $s6: GCD Result Value
#####################################################################
	.data
NUMTIMES:	.word	0
intList:	.space	44
menu:		.asciiz	"\nMenu:\n1. Fibonacci\n2. Duplicate Check\n3. Greatest Common Divisor\n0. EXIT\n"
selPrompt:	.asciiz	"Please enter the number for your choice from the options above: "
promptRec:	.asciiz	"Please enter an integer: "
fibOut1:	.asciiz	"The value of fibonacci("
fibOut2:	.asciiz	") = "
promptDup:	.asciiz	"Please enter your list of up to 10 integers, ending with -1 (press enter after each): "
dupOut:		.asciiz	"Duplicate found in list: "
trueOut1:	.asciiz	"True ("
trueOut2:	.asciiz	")"
falseOut:	.asciiz	"False"
promptGcdA:	.asciiz	"Enter your first positive integer: "
promptGcdB:	.asciiz	"Enter your second positive integer: "
gcdOut:		.asciiz	"The greatest common divisor between "
andOut:		.asciiz	" and "
isOut:		.asciiz	" is: "
errorMsg:	.asciiz	"Invalid selection entered. Please try again."
goodbye:	.asciiz	"Goodbye!"


	.text
main:		li	$v0, 4			# system call code to print string
		la	$a0, menu		# load address of menu string into argument to print
		syscall				# print menu string

		li	$v0, 4			# system call code to print string
		la	$a0, selPrompt		# load address of selPrompt string into argument to print
		syscall				# print selPrompt string

		li	$v0, 5			# system call code to read integer
		syscall				# read integer input
		move	$s0, $v0		# move integer input into s0

		beq	$s0, 1, recProc		# if selection was 1, branch to recProc
		beq	$s0, 2, dupCheck	# if selection was 2, branch to dupCheck
		beq	$s0, 3, ANS		# if selection was 3, branch to ANS
		beqz	$s0, exit		# if selection was 0, branch to exit
		b	selError		# else branch to selError

# prompt for fibonacci index, call fibonacci function, and display result
recProc:	li	$v0, 4			# system call code to print string
		la	$a0, promptRec		# load address of promptRec string into argument to print
		syscall				# print promptRec string

		li	$v0, 5			# system call code to read integer
		syscall				# read integer input
		sw	$v0, NUMTIMES		# store integer input integer in NUMTIMES address

		lw	$a0, NUMTIMES		# load integer input from NUMTIMES into a0 to pass as argument
		jal	fibonacci		# call fibonacci function

		move	$s1, $v0		# move result of fibonacci into s1 to save

		li	$v0, 4			# system call code to print string
		la	$a0, fibOut1		# load address of fibOut1 string into argument to print
		syscall				# print fibOut1 string

		li	$v0, 1			# system call code to print integer
		lw	$a0, NUMTIMES		# load input integer from NUMTIMES into argument to print
		syscall				# print input integer

		li	$v0, 4			# system call code to print string
		la	$a0, fibOut2		# load address of fibOut2 string into argument to print
		syscall				# print fibOut2 string

		li	$v0, 1			# system call code to print integer
		move	$a0, $s1		# move fibonacci result into argument to print
		syscall				# print fibonacci result

		b	main			# branch to main to start over

# define base case
fibonacci:
		bgt	$a0, 1, fibRec		# if argument value is greater than 1, branch to fibRec to process
		move	$v0, $a0		# else, move argument into v0 to represent result
		jr	$ra			# and return to ra

# recursive function to build stack for fib(n) = fib(n - 1) + fib(n - 2)
fibRec:
		sub	$sp, $sp, 12		# subtract 12 from stack pointer to make room for stack of 3 integers
		sw	$ra, 0($sp)		# store the return address in first spot in stack

		sw	$a0, 4($sp)		# store argument in second spot
		subi	$a0, $a0, 1		# decrement argument value
		jal	fibonacci		# recursively call fibonacci for n - 1
		lw	$a0, 4($sp)		# load value from second spot of stack
		sw	$v0, 8($sp)		# store returned value in third spot in stack

		subi	$a0, $a0, 2		# decrement argument value by 2
		jal	fibonacci		# recursively call fibonacci for n - 2

		lw	$t0, 8($sp)		# retrieve value from third spot in stack
		add	$v0, $t0, $v0		# add both result values

		lw	$ra, 0($sp)		# load return address from first spot in stack
		addi	$sp, $sp, 12		# increment stack pointer to top of stack

		jr	$ra			# return to ra

# prompt user to input list of integers
dupCheck:
		li	$v0, 4			# system call code to print string
		la	$a0, promptDup		# load address of promptDup string into argument to print
		syscall				# print promptDup string

		la	$s2, intList		# make s2 a pointer to intList

# loop to read input integers into intList array
readList:
		li	$v0, 5			# system call code to read integer input
		syscall				# read integer input

		sw	$v0, 0($s2)		# store integer input in address of s2 pointer
		bltz	$v0, readDone		# if integer input is negative, done reading
		addi	$s2, $s2, 4		# increment pointer to next index of list
		b	readList		# branch to readList for next iteration

# print output message and set pointer for array to check for duplicates
readDone:
		li	$v0, 4			# system call code to print string
		la	$a0, dupOut		# load address of dupOut string into argument to print
		syscall				# print dupOut string

		la	$s2, intList		# reset s2 as pointer to intList

# outer loop to traverse intList array
dupLoopOuter:
		lw	$t0, 0($s2)		# load integer from address of s2 pointer into t0
		bltz	$t0, dupFalse		# if the integer is negative, list has been fully checked and found no duplicate
		la	$s3, 4($s2)		# make s3 pointer to index after s2
		jal	dupLoopInner		# call inner loop
		addi	$s2, $s2, 4		# increment s2 pointer to next integer in list
		b	dupLoopOuter		# branch to dupLoopOuter for next iteration

# inner loop to use second pointer to compare each index of array against outer loop's index
dupLoopInner:
		lw	$t1, 0($s3)		# load integer from address of s3 pointer
		bltz	$t1, innerDone		# if integer is negative, pointer has reached end of list, exit loop
		beq	$t0, $t1, dupTrue	# if integer at s2 and s3 pointers is equal, duplicate found
		addi	$s3, $s3, 4		# increment s3 pointer to next integer in list
		b	dupLoopInner		# branch to dupLoopInner for next iteration

# after end of array reached by second pointer, go back to outer loop for next index of first pointer
innerDone:
		nop				# stall between branch and jump
		jr	$ra			# jump to return address in outer loop

# if duplicate not found, display result
dupFalse:
		li	$v0, 4			# system call code to print string
		la	$a0, falseOut		# load address of falseOut string into argument to print
		syscall				# print falseOut string

		b	main			# branch to main to start over

# if duplicate is found, display result
dupTrue:
		li	$v0, 4			# system call code to print string
		la	$a0, trueOut1		# load address of trueOut1 string into argument to print
		syscall				# print trueOut1 string

		li	$v0, 1			# system call code to print integer
		move	$a0, $t0		# move found duplicate integer into argument to print
		syscall				# print found duplicate integer

		li	$v0, 4			# system call to print string
		la	$a0, trueOut2		# load address of trueOut2 string into argument to print
		syscall				# print trueOut2 string

		b	main			# branch to main to start over

# prompt for integer inputs for a and b for Euclidean Algorithm, call GCD function, display results
ANS:
		li	$v0, 4			# system call code to print string
		la	$a0, promptGcdA		# load address of promptGcdA string into argument to print
		syscall				# print promptGcdA string

		li	$v0, 5			# system call code to read integer
		syscall				# read integer input
		move	$s4, $v0		# move integer input value into s4

		li	$v0, 4			# system call code to print string
		la	$a0, promptGcdB		# load address of promptGcdB string into argument to print
		syscall				# print promptGcdB string

		li	$v0, 5			# system call code to read integer
		syscall				# read integer input
		move	$s5, $v0		# move integer input value into s5

		li	$v0, 4			# system call code to print string
		la	$a0, gcdOut		# load address of gcdOut string into argument to print
		syscall				# print gcdOut string

		li	$v0, 1			# system call code to print integer
		move	$a0, $s4		# move first integer input into argument to print
		syscall				# print first integer input

		li	$v0, 4			# system call code to print string
		la	$a0, andOut		# load address of andOut string into argument to print
		syscall				# print andOut string

		li	$v0, 1			# system call code to print integer
		move	$a0, $s5		# move second integer input into argument to print
		syscall				# print second integer input

		li	$v0, 4			# system call code to print string
		la	$a0, isOut		# load address of isOut string into argument to print
		syscall				# print isOut string

		move	$a0, $s4		# move first integer input value into a0 to represent 'a'
		move	$a1, $s5		# move second integer input value into a1 to represent 'b'

		jal	GCD			# call GCD function

		move	$s6, $v0		# move value returned by GCD into s6

		li	$v0, 1			# system call code to print integer
		move	$a0, $s6		# move returned value into argument to print
		syscall				# print returned value

		b	main			# branch to main to start over

# recursive function to apply Euclidean Algorithm for calculating GCD
GCD:
 		subi 	$sp, $sp, 12		# subtract 12 from stack pointer to make room for stack of 3 integers
    		sw 	$ra, 0($sp) 		# save function call in first spot in stack
    		sw 	$s0, 4($sp) 		# save s0 in second spot in stack
    		sw 	$s1, 8($sp) 		# save s1 in third spot in stack

    		move	$s0, $a0 		# place argument value a into s0
    		move	$s1, $a1 		# place argument value b into s1

    		addi 	$t1, $zero, 0	 	# intitialize t1 to 0
    		beq 	$s1, $t1, returnGcd 	# if b = 0, branch to returnGcd

    		move 	$a0, $s1 		# move b into argument a
    		div 	$s0, $s1 		# calculate a / b
    		mfhi 	$a1 			# place remainder in b

    		jal 	GCD			# recursively call GCD function

# tear down stack / unwind recursion
exitGcd:
    		lw 	$ra, 0 ($sp)  		# load ra from stack
    		lw 	$s0, 4 ($sp)		# load a from stack
    		lw 	$s1, 8 ($sp)		# load b from stack
    		addi 	$sp, $sp, 12 		# move sp to top of stack
    		jr 	$ra			# return to ra

# return resulting value from Euclidean Algorithm
returnGcd:
    		move 	$v0, $s0 		# move s0 into v0 to return result
    		j 	exitGcd			# jump to exitGcd to exit function

# display error message if menu selection invalid
selError:	li	$v0, 4			# system call code to print string
		la	$a0, errorMsg		# load address of errorMsg string into argument to print
		syscall				# print errorMsg string

		b	main			# branch to main to try again

# display goodbye message and terminate program
exit:		li	$v0, 4			# system call code to print string
		la	$a0, goodbye		# load address of goodbye string into argument to print
		syscall				# print goodbye string

		li	$v0, 10			# system call code to terminate program
		syscall				# terminate program

						# END OF PROGRAM
