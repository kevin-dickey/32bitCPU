.data
str1:  .asciiz "Please enter the number of integers in your array (up to 10):\n"
str2:  .asciiz "Please enter an integer:\n"
#.align 2 # align the array by word-spacing
#array: .space 40 # reserves space for 40 bytes (10 integers)
array: .word 6, 3, 11, 4, 6, 7, 9, 7, 1023, 43


.text
.globl main

main: 
# prompt user for number of elements
#la $a0, str1
#li $v0, 4
#syscall

# read number entered by user, this will be how many elements will be in the array
#li $v0, 5
#syscall

#addi $s0, $zero, 0	# i = 0		# commented out b/c do it anyway on line 50
addi $s1, $zero, 0	# j = 0		# was commented out b/c do it anyway on line 51, may want to keep
addi $s2, $zero, 10	# N = 10 (num elements in array)
la $s3, array		# s3 = array base address

readArrayElements:
# condition here
#slt $t0, $s0, $s2 	# t0 = 1 when i < N
#beq $t0, $zero, bubbleSort

# loop here
# prompt for input
#la $a0, str2
#li $v0, 4
#syscall
# read integer element and store in array
#li $v0, 5
#syscall

#addi $t1, $v0, 0 	# t1 = current integer element 
#sll $t2, $s0, 2		# t2 = i * 4 to load integers
#addu $t3, $s3, $t2	# t3 = array[i] (proper array address w/ offset) 
#sw $t1, 0($t3)		# store integer into array
#addi $s0, $s0, 1	# i++
#j readArrayElements

# at this point all elements should be properly in array
bubbleSort:
addi $s0, $zero, 0 	# i = 0 (resetting i after using it to enter array elements)
addi $t0, $s2, -1	# t0 = N - 1		# will be ok with forwarding result from ALU, otherwise needs 1 nop before this instruc
outerCond:
addi $s1, $zero, 0	# j = 0
slt $t1, $s0, $t0	# t1 = 1 when i < N-1 	# will be ok with forwarding result from ALU, otherwise needs 2 nop before this instruc
beq $t1, $zero, printResults
addi $t2, $zero, 0	# t2 acts as a boolean, t2 = 0 = false, see "https://www.geeksforgeeks.org/bubble-sort/" for more info on this part
innerCond:
sub $t3, $t0, $s0	# t3 = N - 1 - i
slt $t4, $s1, $t3	# t4 = 1 when j < N - 1 - i
beq $t4, $zero, check
# if arr[j] > arr[j+1], swap em and set t2 to 1
sll $t5, $s1, 2		# t5 = j * 4 to load integers
addu $t6, $s3, $t5	# t6 = array[j] (proper array address w/ offset)
lw $t7, 0($t6)		# t7 = value at array[j]
addiu $t6, $s1, 1	# t6 = j+1
sll $t6, $t6, 2		# t6 = (j+1) * 4 to load integers
addu $t6, $s3, $t6	# t6 = array[j+1] address
lw $t8, 0($t6)		# t8 = value at array[j+1]
addi $s1, $s1, 1	# j++
# should be able to reuse t4 here (i think)
slt $t4, $t8, $t7	# t4 = 1 when array[j+1] < array[j]
beq $t4, $zero, innerCond
# swap em
sw $t7, 0($t6)		# array[j+1] = contents from array[j] (t6 should still be address at array[j+1])
addi $t6, $t6, -4	# t6 = array[j] address
sw $t8, 0($t6)		# array[j] = contents from array[j+1]
addi $t2, $zero, 1
j innerCond
check: # if no elements were swapped in inner loop, stop bubbleSort and print results. otherwise, back to outerCond
addi $s0, $s0, 1	# i++
slti $t2, $t2, 1	# t2 = 1 when t2<1 (t2=true (1) ==> t2=0, t2=false (0) ==> t2=1)
beq $t2, $zero, outerCond
#goes to printResults when nothing was swapped in innerCond

printResults:
addi $s0, $zero, 0	# i = 0
loop:
slt $at, $s0, $s2	# at = 1 when i < N
beq $at, $zero, exit

lw $t0, 0($s3)
addi $s3, $s3, 4

#li $v0, 1
#add $a0, $t0, $zero
#syscall
# next part adds spaces between each integer
#li $a0, 32
#li $v0, 11
#syscall

addi $s0, $s0, 1	# i++
j loop

exit:
li $v0, 10
halt
#syscall
