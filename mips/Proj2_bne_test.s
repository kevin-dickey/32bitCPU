.data
.text
.globl main

main:
addi $t1, $zero, 5
addi $t2, $zero, 5
bne $t1, $t2, swag
addi $t1, $t1, 5 # should occur

swag:
halt