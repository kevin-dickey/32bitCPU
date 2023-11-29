.data
.text
.globl main

main:
addi $t1, $zero, 5
addi $t2, $zero, 5
beq $t1, $t2, swag
addi $t1, $t1, 5 # shouldn't occur

swag:
halt