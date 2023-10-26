.data
text: .asciiz "cool things "
.text
.globl main
main:
  

    # Start program 
    addi $t0, $0, 1 
    addi $t1, $0, 1  
    beq $t0, $t1, equal
    
    j exit
 equal:
    jal cond
    j exit
cond:
    addi $t2, $t0, 68
    addi $t3, $t3, 1
    slt   $t3, $t2, $t3     
    bne   $t3, $zero, temp 

 temp:
  addi $t5, $t5, 1
  
  slti $t6, $t5, 5
  bne $t6, $t5, temp2

temp2:
j temp3
temp3:
 addi $t1, $t1, 4
bne $t0, $t1, temp4

temp4:
addi $t3, $zero, 0

li $v0, 4
la $a0, text
#syscall

jr $ra	#return

exit:  
li $v0, 10
#syscall
halt

    
