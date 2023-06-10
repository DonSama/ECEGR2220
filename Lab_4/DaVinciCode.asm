# Lab 4 Part 2.2


.eqv	MAX_FIBO	3       # Largest n, a
.eqv	MAX_FIBO_2	10	# Largest n, b
.eqv	MAX_FIBO_3	20	# Largest n, c


	.data
	.text
main:
	li a0, 0		# Clear accumulator
	li s0, 0		# Clear loop counter
	li s1, MAX_FIBO		# int a = 3
	j loop
	
	loop2:
	add, s9, s9, s2		# Store n = 3 fib # in s9
	li a0, 0		# Clear accumulator
	li s0, 0		# Clear loop counter
	li s1, MAX_FIBO_2	# int a = 10
	j loop
		
	loop3:
	add, s8, s8, s2		# Store n = 10 fib # in s8
	li a0, 0		# Clear accumulator
	li s0, 0		# Clear loop counter
	li s1, MAX_FIBO_3	# int a = 20
	j loop	
	
	
	loop:
	bgt s0, s1, done 	# Loop control, stop if > MAX_FIBO
	mv a0, s0		# Pass argument n in a0 to fibo(n) 
	jal fibo		# Return value from fibo(n) a0
	mv s2, a0		# Save return value
	
	addi s0, s0, 1		# Loop control
	j loop
	
	done:	
	li t4, 6765		# loop control for 20th fib number
	beq s2, t4, donedone	# jump to exit if 20th fib number reached
	li t5, 4
	beq s0, t5, loop2	# loop control to branch if n = 3 has completed
	li t6, 11
	beq s0, t6, loop3	# loop control to branch if n = 10 has completed
		
	donedone:
	add, s7, s7, s2		# Store n = 20 fib # in s7
	li a7, 10		# Exit program
	ecall
	
	fibo:
	# Argument n is in a0
	beqz a0, is_zero	# n = 0?
	addi t0, a0, -1 	# If a0 == 1 then t0 == 0
	beqz t0, is_one		# n = 1?
		
	# n > 1
	addi sp, sp, -8		# Make room for two words
	sw a0, 0(sp)		# Save original n
	sw ra, 4(sp)		# Save return address
		
	addi a0, a0, -1		# Now n-1 in a0
	jal fibo		# Calculate fibo(n-1)
		
	lw t0, 0(sp)		# Get original n from stack
	sw a0, 0(sp)		# Save fibo(n-1) to stack in same place
	addi a0, t0, -2		# Now n-2 in a0
	jal fibo		# Calculate fibo(n-2) 
		
	lw t0, 0(sp)		# Get result of fibo(n-1) from stack
	add a0, a0, t0		# add fibo(n-1) and fibo(n-2)
		
	lw ra, 4(sp)		# Get return address from stack
	addi sp, sp, 8		# clean up stack 
		
	# Fall through	
	is_zero:
	is_one:
	ret

	
