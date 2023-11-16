# Testing common case of jumping both forward and backward	
	.data 
 
	.text
	.globl main
main:
	jal test2			# Forward jump
	nop		# added nops these to test our jal 
	nop		
	halt
 	
test1: 
	halt
	
test2:	
	jal test1			# Backwards jump
	nop
	nop
	addi $t0, $zero, 20	# In case of fail $t0 = 20
	
	
	
        halt
