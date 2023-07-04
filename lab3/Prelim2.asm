.data
	prompt1: .asciiz "Enter dividend: "
	prompt2: .asciiz "Enter divisor: " 
	prompt3: .asciiz "Quotient: "
	prompt4: .asciiz "Remainder: "
	newline: .asciiz "\n"
	
.text
	# Get dividend from user
	la $a0, prompt1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	
	# Get divider
	la $a0, prompt2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s1, $v0
	
	# Call recursive division
	move $a0, $s0
	move $a1, $s1
	jal recursiveDivision
	move $s2, $v0
	move $s3, $v1
	
	# Print quotient
	la $a0, prompt3
	li $v0, 4
	syscall
	move $a0, $s2
	li $v0, 1
	syscall
	
	# Print newline
	la $a0, newline
	li $v0, 4
	syscall
	
	# Print remainder
	la $a0, prompt4
	li $v0, 4
	syscall
	move $a0, $s3
	li $v0, 1
	syscall
	
	# Exit program
	li $v0, 10
	syscall
	
recursiveDivision:
	# Save s registers to the stack
	addi $sp, $sp -12
	sw $ra, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0 # s0 = dividend
	move $s1, $a1 # s1 = divider
	
	# If dividend is less than divider, go exit1
	blt $s0, $s1, exit1
	
	# Else, subtract divider and call function recursively
	sub $s0, $s0, $s1
	move $a0, $s0
	move $a1, $s1
	jal recursiveDivision
	
	# Increment quotient
	addi $v0, $v0, 1
	# Go exit2
	j exit2
	
exit1:
	li $v0, 0
	move $v1, $s0
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
exit2:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
