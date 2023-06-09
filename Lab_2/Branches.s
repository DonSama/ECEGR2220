# Lab 2, Part 2

	.data	# Data declaration section

A:	.word	15
B:	.word	15
C:	.word	10
Z:	.word	0

	.text

main:	
	
	# load variable values into temporary registers
	lw	t0, A
	lw	t1, B
	lw	t2, C
	lw	t3, Z
	jal	FirstTest

	# begin branching operations
	FirstTest:
		blt	t0, t1, Temp1		# if A < B branch to Temp1 for further testing
		jal 	SecondTest
		
	SecondTest:
		bgt	t0, t1, IntZ2		# if A > B branch to IntZ2 to set Z = 2
		addi	a0, t2, 1		# add 1 to C before seeing if C + 1 = 7
		li	a1, 7			# load 7 into t6 before seeing if C + 1 = 7
		beq	a0, a1, IntZ2		# if C + 1 = 7, branch to IntZ2 to set Z = 2
		beq	zero, zero, IntZ3	# if no other conditions met first, branch to IntZ3
	
	Temp1:
		li	a2, 5			# load 5 into a0 to compare to C
		bgt	t2, a2, IntZ1		# if C > 5, branch to IntZ1 to set Z = 1
		jal	SecondTest		# if C <= 5, continue with testing at SecondTest
		
		
	# Set Z to switch values and go to switching cases
	IntZ1:
		li	t3, 1			# set Z = 1	
		jal	Case1
	
	IntZ2:
		li	t3, 2			# set Z = 2
		jal	Case2
		
	IntZ3:
		li	t3, 3			# set Z = 3
		jal	Case3
	
	# the cases
	
	Case1:
		li	t3, -1			# set Z = -1
		sw	t3, Z, t4
		li	a7, 10
		ecall
	
	Case2:
		li	t3, -2			# set Z = -2
		sw	t3, Z, t4
		li	a7, 10
		ecall		
	Case3:
		li	t3, -3			# set Z = -3
		sw	t3, Z, t4
		li	a7, 10
		ecall
		
# END OF PROGRAM
