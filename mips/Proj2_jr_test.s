.data
.text
.globl main

main:
jal swag
jal baller
jal epic

swag:
addi $t1, $zero, 5
jr $ra

baller:
addi $t1, $zero, 10
jr $ra

epic:
halt