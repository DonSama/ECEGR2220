# Lab 2 - Part 5

    .data   # Place variables a, b, and c in memory

	a:	.word 0
	b:	.word 0
	c:	.word 0

    .text

main:       # Start of code section

    # Read variables from memory to registers
    lw a0, a		# load variables into registers
    lw a1, b
    lw a2, c
    
    # a = AddItUp(i);
    li t0, 5		# Set i = 5
    addi sp, sp, -8	# make space in stack for two variables
    sw t0, 0(sp)	# place i first in stack
    sw t1, 4(sp)
    jal AddItUp		# call function
    sw t1, a, t4	# Store returned x to a
    
    # b = AddItUp(j);
    li t1, 10		# j = 10
    addi sp, sp, -8	# make space in stack for two variables
    sw t0, 4(sp)	# place j first in stack
    sw t1, 0(sp)
    jal AddItUp		# send j to AddItUp
    sw t1, b, t5	# Store returned x to register
    
    lw t0, a		# load i...
    lw t1, b		# and j into registers
    add t6, t0, t1	# c = a + b
    sw t6, c, t5	# store c in memory
    
    li a7,10
    ecall
    
    AddItUp:
    add t0, x0, x0	# set i...
    add t1, x0, x0	# and x = 0 before entering AddItUpFor loop
    addi sp, sp, -4	# make room in stack for return address
    sw ra, 8(sp)	# save return address last in stack
    lw a3, 4(sp)	# set n = whatever is 2nd in the stack (should be i and then j)
    add t3, x0, a3	# place n in t3
    
    jal AddItUpFor
    
    AddItUpFor:
    bge t0, t3, Exit	# if i >= n, exit
    addi a4, t0, 1	# (i + 1)
    add t1, a4, t1	# x = x + (i + 1)
    addi t0, t0, 1	# i++
    jal AddItUpFor
    
    Exit:
    sw t1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12
    ret
    
# END OF PROGRAM
