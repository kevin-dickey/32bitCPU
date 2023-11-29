.data
.text
main:
	addi $t0, $zero, 0x0 # t0 = 0
	addi $t1, $zero, 0x1 # t1 = 1
  j loop

  skip:
  addi $t0, $zero, 0xFFFF # should be skipped
  addi $t1, $zero, 0xFFFF # should be skipped

  loop:
  addi $t0, $t0, 0x1 
  slti $t6, $t0, 2 
  bne $t6, $0, branch
  j end

  branch:
  addi $t6, $0, 0x1
  j loop

  end:
  addi $t3, $zero, 0x0 # t3 = 0
  addi $t4, $zero, 0x0 # t4 = 0
  addi $t5, $zero, 0x0 # t5 = 0
  bne $v0, $0, end 

halt
