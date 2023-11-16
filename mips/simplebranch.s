main:
	ori $s0, $zero 0x1234
	j skip
	nop
	nop
	li $s0 0xffffffff
skip:
	nop
	nop
	ori $s1 $zero 0x1234
	nop
	nop
	beq $s0 $s1 skip2
	nop
	nop
	nop
	li $s0 0xffffffff
	nop
skip2:
	nop
	nop
	jal fun
	nop
	nop
	ori $s3 $zero 0x1234
	
	beq $s0, $zero exit
	nop
	nop
	ori $s4 $zero 0x1234
	j exit
	nop
	nop

fun:
	nop
	nop
	nop
	ori $s2 $zero 0x1234
	jr $ra
	nop
	nop
exit:
	nop
	nop
	halt

