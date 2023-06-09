# Lab 2, Part 3

	.data	# Data declaration section

Z:	.word	2
i:	.word	0

	.text

main:	
	
	# load variable values into temporary registers
	lw	t0, Z
	lw	t1, i
	li	a0, 20		# load comparison values into registers
	li	a1, 100
	li	a2, 2
	addi	t1, x0, 0	# initialize i = 0 before For loop
	jal	For

	# loops
	For:
		bgt	t1, a0, Do		# when i is greater than 20, exit For loop and go to Do
		addi	t1, t1, 2		# increment i by 2
		addi	t0, t0, 1		# increment Z by 1
		jal 	For			# return to beginning of loop
		
	Do:
		addi	t0, t0, 1		# increment Z by 1 before checking anything
		blt	t0, a1, Do		# loop back to Do as long as Z < 100
		jal	While
	
	While:
		ble	t1, x0, Exit		# exit the loop when i > 0, otherwise...
		addi	t0, t0, -1		# subtract 1 from Z and...
		addi	t1, t1, -1		# subtract 1 from i
		jal	While			# loop back to While until Exit condition met
		
	Exit:
		sw	t0, Z, t5		# store variable values in memory
		sw	t1, i, t6
		li	a7, 10
		ecall
		
# END OF PROGRAM
