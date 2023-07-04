.data
	prompt1: .asciiz "Enter a nubmer within the range of 1-31: "
	prompt2: .asciiz "Number of times the register you chose used in the prgoram: "
	newline: .asciiz "\n"
.text

main:
	# Ask user to enter a number between 1-31
	la $a0, prompt1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0 # s0 = chosen register
	
	# Check if register number is valid
	blt $s0, 1, exit
	bgt $s0, 31, exit
	
	# Call the subprogram to count number of uses
	move $a0, $s0
	jal registerCount
	move $s1, $v0
	
	# Print how many times the register is used
	la $a0, prompt2
	li $v0, 4
	syscall
	move $a0, $s1
	li $v0, 1
	syscall
	j exit
	
	
registerCount:
	# Save s registers to the stack
	addi $sp, $sp -32
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0  # s0 = register number
	la $s1, registerCount   # s1 = start address
	la $s2, exit   # s2 = exit address
	li $s7, 0  # number of occurences
	
	loop:
		bgt $s1, $s2, loopExit
		# Load the next instruction
		lw $s3, 0($s1)
		
		# Parse opcode
		andi $s4, $s3, 0xfc000000 # s4 = opcode
		
		# Decide instruction type
		beq $s4, 0, rtype
		
		# jump to the end of the loop if its a j type instruction
		beq $s4, 2, restOfLoop
		beq $s4, 3, restOfLoop
		
		j itype  # if not r and j type, then it is i type
		
		rtype:
			# Parse rs rt and rd
			andi $s4, $s3, 0x03e00000  # s4 = rs
			andi $s5, $s3, 0x001f0000  # s5 = rt
			andi $s6, $s3, 0x0000f800  # s6 = rd
			
			srl $s4, $s4, 21
			srl $s5, $s5, 16
			srl $s6, $s6, 11
			
			seq $s4, $s4, $s0
			seq $s5, $s5, $s0
			seq $s6, $s6, $s0
			
			add $s7, $s7, $s4
			add $s7, $s7, $s5
			add $s7, $s7, $s6
			j restOfLoop 
		itype:
			# Parse rs and rt 
			andi $s4, $s3, 0x03e00000  # s4 = rs
			andi $s5, $s3, 0x001f0000  # s5 = rt
			
			srl $s4, $s4, 21
			srl $s5, $s5, 16
			
			seq $s4, $s4, $s0
			seq $s5, $s5, $s0
			
			add $s7, $s7, $s4
			add $s7, $s7, $s5
			j restOfLoop
		
		restOfLoop:
			addi $s1, $s1, 4
			j loop
		
	loopExit:
		move $v0, $s7
		# Getting s registers' values back from stack
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $s5, 20($sp)
		lw $s6, 24($sp)
		lw $s7, 28($sp)
		addi $sp, $sp, 32
		jr $ra
		
exit:
	li $v0, 10
	syscall
	