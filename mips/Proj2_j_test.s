.data
.text
.globl main

main:
j swag
addi $t1, $zero, 10 # shouldn't occur
addi $t2, $zero, 20 # shouldn't occur

swag:
addi $t1, $zero, 3 # should occur
addi $t2, $zero, 7 # should occur
halt