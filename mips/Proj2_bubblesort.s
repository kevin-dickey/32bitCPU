.data
str1:  .asciiz "Please enter the number of integers in your array (up to 10):\n"
str2:  .asciiz "Please enter an integer:\n"
#.align 2 # align the array by word-spacing
#array: .space 40 # reserves space for 40 bytes (10 integers)
array: .word 6, 3, 11, 4, 6, 7, 9, 7, 1023, 43


.text
.globl main

# NOTE: Added 21 nop instructions to work in a 5-stage pipeline (without forwarding or hazard detection). Not the greatest, but it'll do for now. 
# NOTE: Look over for branches and jumps.

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
#la $s3, array		# s3 = array base address
lui $at, 4097
nop
nop		# stall for at
ori $s3, $at, 92


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
addi $t0, $s2, -1	# t0 = N - 1		# should be ok, just make sure register file writes in first half and reads in second
outerCond:
nop
nop
nop		# stall for branch to outercond to finish 
addi $s1, $zero, 0	# j = 0
nop	# stall for t0
slt $t1, $s0, $t0	# t1 = 1 when i < N-1 	
nop
nop	# stall for t1
beq $t1, $zero, printResults
nop
nop	# stall for beq
addi $t2, $zero, 0	# t2 acts as a boolean, t2 = 0 = false, see "https://www.geeksforgeeks.org/bubble-sort/" for more info on this part
innerCond:
nop
nop		# stall for branch
sub $t3, $t0, $s0	# t3 = N - 1 - i
nop
nop 	# stall for t3
slt $t4, $s1, $t3	# t4 = 1 when j < N - 1 - i
nop
nop	# stall for t4
beq $t4, $zero, check
nop
nop	# stall for beq
# if arr[j] > arr[j+1], swap em and set t2 to 1
sll $t5, $s1, 2		# t5 = j * 4 to load integers
addiu $s6, $s1, 1	# s6 = j+1
nop	# stall for t5 (and s6)
addu $t6, $s3, $t5	# t6 = array[j] (proper array address w/ offset)
sll $s6, $s6, 2		# s6 = (j+1) * 4 to load integers
nop	# stall for t6 (and s6)
lw $t7, 0($t6)		# t7 = value at array[j]
addu $s6, $s3, $s6	# s6 = array[j+1] address
addi $s1, $s1, 1	# j++
nop
lw $t8, 0($s6)		# t8 = value at array[j+1]
# should be able to reuse t4 here (i think)
nop
nop	# stall for t8
slt $t4, $t8, $t7	# t4 = 1 when array[j+1] < array[j]
nop
nop	# stall for t4
beq $t4, $zero, innerCond
nop
nop	# stall for beq
# swap em
sw $t7, 0($s6)		# array[j+1] = contents from array[j] (s6 should still be address at array[j+1])
addi $s6, $s6, -4	# s6 = array[j] address
nop
nop	# stall for s6
sw $t8, 0($s6)		# array[j] = contents from array[j+1]
addi $t2, $zero, 1
j innerCond
nop
nop	# stall for jump
check: # if no elements were swapped in inner loop, stop bubbleSort and print results. otherwise, back to outerCond
nop
nop	# stall for branch to check
slti $t2, $t2, 1	# t2 = 1 when t2<1 (t2=true (1) ==> t2=0, t2=false (0) ==> t2=1)
addi $s0, $s0, 1	# i++
nop	# stall for t2
beq $t2, $zero, outerCond
nop
nop	# stall for beq
#goes to printResults when nothing was swapped in innerCond

printResults:
nop
nop
addi $s0, $zero, 0	# i = 0
nop
nop	# stall for s0
loop:
nop
nop	# stall for jump to finish
slt $at, $s0, $s2	# at = 1 when i < N
nop
nop	#stall for at
beq $at, $zero, exit
nop
nop	# stall for beq
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
nop
nop

exit:
nop
nop	# stall for jump to finish
li $v0, 10
halt
#syscall
