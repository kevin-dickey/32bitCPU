.data
.align 2
array: .word 1,65535,3,4,5,60
.text
.globl main

main:
    la $s0, array
    lw $t0, 4($s0)
    addi $t1, $t0, 5
    add $t2, $t0, $zero
    addiu $t3, $t2, 15
    addu $t0, $t3, $t1
    and $t1, $t0, $t1
    andi $t2, $t1, 65535
    lui $t3, 15
    nor $t0, $t3, $zero
    xor $t1, $t0, $t1
    xori $t2, $t1, 16383
    or $t3, $t2, $t0
    ori $t0, $t3, 65535
    slt $t0, $t0, $t3
    slti $t1, $t0, 16383
    sll $t2, $t0, 1
    srl $t3, $t0, 3
    sra $t4, $t3, 2
    sw $t2, 4($s0)
    sub $t1, $t0, $t3
    subu $t2, $t1, $t0
    halt

