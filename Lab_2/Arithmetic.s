# Lab 2, Part 1

	.data	# Data declaration section

Z:	.word	0

	.text

main:	
	
	# load variable values into temporary registers
	li	t0, 15		# A = 15
	li	t1, 10		# B = 10
	li	t2, 5		# C = 5
	li	t3, 2		# D = 2
	li	t4, 18		# E = 18
	li	t5, -3		# F = -3
	jal	math

math:	
	#begin arithmetic operations
	sub		a0, t0, t1	# A - B = a0
	mul		a1, t2, t3	# C*D = a1
	sub		a2, t4, t5	# E - F = a2
	div		a3, t0, t2	# A/C = a3
	add		a4, a0, a1	# (A - B) + (C*D) = a4
	add		a4, a4, a2	# ((A - B) + C*D)) + (E - F) = t1
	sub		a4, a4, a3	# ((A - B) + (C*D) + (E - F)) - (A/C) = a4
	sw		a4, Z, t0

# END OF PROGRAM
