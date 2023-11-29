.data
.text
main:
  addi $t0, $zero, 0x0 # t0 = 0
  addi $t1, $zero, 0x1 # t1 = 1
  addi $t2, $zero, 0x2 # t2 = 2
  addi $t3, $zero, 0x3 # t3 = 3
  addi $t4, $zero, 0x4 # t4 = 4

  add $t0, $t0, $t0 # t0 = 0
  addi $t1, $zero, 0x1 # t1 = 1
  addi $t2, $zero, 0x2 # t2 = 2
  add $t3, $t0, $t1 # t3 = 1
  add $t4, $t2, $t3 # t4 = 3

  #sw $t4, 0($sp) 
  #lw $t3, 0($sp) # t3 = 3
  #sw $t3, 0($sp)
  halt
