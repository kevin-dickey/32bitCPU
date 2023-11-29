.data
.text
.globl main

main:
jal swag
swag:
jal baller
addi $t1, $zero, 5 # shouldn't occur
baller:
halt
