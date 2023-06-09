# Lab 2, Part 4

	.data	# Data declaration section

A:	.word	0, 0, 0, 0, 0
B:	.word	1, 2, 4, 8, 16
i:	.word	0

	.text

main:	
	
	# load variable values into temporary registers
	la	s1, A
	la	s2, B
	lw	t0, i
	li	a0, 5		# load comparison values into registers
	li	a1, 2
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
		
	Decrement:
		addi	t0, t0, -1		# decrement i by 1
		jal	While
		
	While:
		blt	t0, x0, Exit		# exit the loop when i < 0, otherwise...
		slli	t1, t0, 2		# load i into t1 and shift to the left
		add	t2, t1, s1		# get address of A[i]
		lw	t3, 0(t2)		# temporary register t3 = A[i]
		add	t4, t1, s2		# get address of B[i]
		lw	t5, 0(t4)		# temporary register t5 = B[i]
		add	t6, t3, t5		# A[i] + B[i]
		mul	t3, t6, a1		# (A[i] + B[i])*2
		sw	t3, 0(t2)
		addi	t0, t0, -1		# decrement i	
		jal	While			# loop back to While until Exit condition met
		
	Exit:
		sw	t3, A, a3		# store variable values in memory
		sw	t6, B, a4
		li	a7, 10
		ecall
		
# END OF PROGRAM
