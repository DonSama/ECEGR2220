# Lab 2, Part 5

	.data	# Data declaration section

a:	.word	0
b:	.word	0
c:	.word	0

	.text

main:	
	
	# load variable values into temporary registers
	lw	a0, a
	lw	a1, b
	lw	a2, c
	li	t0, 5		# i
	li	t1, 10		# j
	addi	t0, x0, 0	# initialize i = 0 before For loop
	jal	For

	# loops
	For:
		bge	t0, a0, Decrement	# when i >= 5, exit For loop and go to Decrement
		slli	t1, t0, 2		# load i into temporary register t1, shifting to account for byte addressing
		add	t2, t1, s1		# get address of A[i]
		lw	t3, 0(t2)		# temporary register t3 = A[i]
		add	t4, t1, s2		# get address of B[i]
		lw	t5, 0(t4)		# temporary register t5 = B[i]
		addi	t3, t5, -1		# A[i] = B[i] - 1
		sw	t3, 0(t2)
		addi	t0, t0, 1		# increment i
		jal 	For			# return to beginning of loop
		
	AddItUp:
		lw	t0, x0			# set i = 0 before For loop
		lw	t1, x0			# set x = 0
		jal	For
	For:
		bge	t0, a3, Exit		# exit For loop if i >= n
		addi	t1, t0, 1		# x = x + i + 1
		addi	t0, t0, 1		# i++
		jal	For			# return to beginning of For loop
		
	Exit:
		sw	t3, A, a3		# store variable values in memory
		sw	t6, B, a4
		li	a7, 10
		ecall
		
# END OF PROGRAM
