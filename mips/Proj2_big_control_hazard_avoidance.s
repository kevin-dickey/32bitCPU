.data
.text
.globl main

main:
bne $zero, $zero, exit
addi $t1, $zero, 1
addi $t2, $t1, 0
bne $t1, $t2, exit
beq $t1, $zero, exit
beq $t2, $zero, exit
j swag

baller:
j dope

swag:
bne $zero, $zero, exit
bne $zero, $zero, exit
j baller

dope:
jal cool
j exit

cool:
jr $ra

exit:
halt