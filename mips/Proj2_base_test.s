.data
.align 2
array: .word 1,65535,3,4,5,60
text: .asciiz "cool things "
.text
.globl main

# look over again for branches and jumps

main:
    la $s0, array
    addi $t1, $t0, 5	# testing framework uses reset signal before each test so this should store 5 into t1 no problem :)
    add $t2, $t0, $zero
    lw $t0, 4($s0)
    and $t1, $t0, $t1
    addiu $t3, $t2, 15
    nop		# stall for t3 (and t1)
    andi $t2, $t1, 65535
    addu $t0, $t3, $t1
    lui $t3, 15
    xori $t2, $t1, 16383
    srl $t3, $t0, 3
    sra $t4, $t3, 2
    sll $t2, $t0, 1
    nor $t0, $t3, $zero
    nop
    nop		# stall for t0
    xor $t1, $t0, $t1
    or $t3, $t2, $t0
    sw $t2, 4($s0)
    nop		# stall for t3
    slt $t0, $t0, $t3
    ori $t3, $t3, 65535
    slti $t1, $t2, 16383
    nop		# stall for t3 (and t1)
    sub $t1, $t0, $t3
    subu $t2, $t2, $t0
    
    # control flow tests here and onward
    addi $t0, $0, 1 
    addi $t1, $0, 1  
    nop
    nop		# stall for t1 (and t0)
    beq $t0, $t1, equal
    
    j exit
    
equal:
    jal cond
    j exit
    
cond:
    addi $t2, $t0, 68
    addi $t3, $t3, 1
    nop
    nop		# stall for t3 (and t2)
    slt   $t3, $t2, $t3
    nop
    nop     	# stall for t3
    bne   $t3, $zero, temp 

temp:
    addi $t5, $t5, 1
    nop
    nop		# stall for t5
    slti $t6, $t5, 5
    nop
    nop		# stall for t6
    bne $t6, $t5, temp2
    nop

temp2:
    nop
    j temp3

temp3:
    addi $t1, $t1, 4
    nop
    nop		# stall for t1
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








