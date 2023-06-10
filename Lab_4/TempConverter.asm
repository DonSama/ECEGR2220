# Lab 4 Part 2.1

.data
K: .float 273.15
prompt: .asciz "Enter a Fahrenheit Temp: "
Kelvin: .asciz "T in Kelvin: "
Celsius: .asciz "T in Celsius: "

newln: .asciz "\r\n"

.text

main: 
	li a7, 4 
	la a0, prompt
	ecall
	
	li a7, 6
	ecall
	
	fmv.x.w a0, fa0		# move our input float value to register a0
	jal F2C			# call our first converter, F to C
	
	fmv.s.x fs0, a1
	
	mv a0, a1
	jal C2K			# call second converter, C to K
	
	fmv.s.x fs1, a1
	
	li a7, 10
	ecall
	
# convert Fahrenheit to Celsius	
F2C:
	addi t0, s0, 32		# add 32 to register t0 so we can do math with it
	fcvt.s.w ft0, t0	# store 32 as float in ft0
	addi t0, s0, 9		# add 9 to t0 so we can do math with it
	fcvt.s.w ft1, t0	# store 9 as float in ft1
	addi t0, s0, 5		# add 5  to t0
	fcvt.s.w ft2,t0
	
	fmv.s.x fa0, a0
	
	fsub.s fa0, fa0, ft0	# F - 32
	fmul.s fa0, fa0, ft2	# (F - 32)*5
	fdiv.s fa0, fa0, ft1	# [(F-32)*5]/9
	
	li a7,4
	la a0,Celsius
	ecall
	
	li a7,2
	ecall
	
	li a7,4
	la a0,newln
	ecall
	
	fmv.x.s a1,fa0
	ret

# convert Celsius to Kelvin
C2K:
	flw ft0, K, t0		# load 273.05
	fmv.s.x fa0, a0
	fadd.s fa0, fa0, ft0	# C + 273.15
	
	li a7, 4
	la a0, Kelvin
	ecall
	
	li a7, 2
	ecall
	li a7, 4
	la a0, newln
	ecall
	fmv.x.s a1, fa0
	ret
	