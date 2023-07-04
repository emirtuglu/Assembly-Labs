.data 
    prompt1: .asciiz "Enter the first number: "
    prompt2: .asciiz "Enter the second number: "
    prompt3: .asciiz "First number (in hex form): "
    prompt4: .asciiz "Second number (in hex form): "
    prompt5: .asciiz "Hamming distance: "
    prompt6: .asciiz "Enter y to continue. "
    newline: .asciiz "\n"
    
.text

Main:
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    jal getNumbers
    move $s0, $v1  # $s0 = first number
    move $s1, $v0  # $s1 = second number
    
    # Print first number in hex
    la $a0, prompt3
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 34
    syscall
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # Print second number in hex
    la $a0, prompt4
    li $v0, 4
    syscall
    move $a0, $s1
    li $v0, 34
    syscall
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    move $a0, $s0
    move $a1, $s1
    jal calculateHammingDistance
    move $s2, $v0 # s2 = hamming distance
    
    # Print the hamming distance
    la $a0, prompt5
    li $v0, 4
    syscall
    move $a0, $s2
    li $v0, 1
    syscall
    
    # Print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # Ask user to continue
    la $a0, prompt6
    li $v0, 4
    syscall
    li $v0, 12
    syscall
    move $s3, $v0 #s3 = answer
    li $s4, 'y' 
    
    beq $s3, $s4, Main
    
    # Exit program
    li $v0, 10
    syscall
    
    
getNumbers:
    la $a0, prompt1
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $v1, $v0
    
    la $a0, prompt2
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    
    jr $ra
    
# Inputs: a0 = first number, a1 = second number
calculateHammingDistance:
    # save s registers to the stack
    addi $sp, $sp, -24
    sw $s5, 20($sp)
    sw $s4, 16($sp)
    sw $s3, 12($sp)
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)
    
    add $s0, $0, $a0 #s0 = first number
    add $s1, $0, $a1 #s1 = second number
    addi $s2, $0, 0   #s2 = hamming distance
    addi $s3, $0, 0   #loop variable
    
    loop:
    # take LSBs of numbres
    andi $s4, $s0, 1
    andi $s5, $s1, 1
    
    # check if LSBs are equal, add to hamming distance if equal
    xor $s4, $s4, $s5
    add $s2, $s2, $s4
    
    # shift bits of the numbers
    srl $s0, $s0, 1
    srl $s1, $s1, 1
    
    addi $s3, $s3, 1
    bne $s3, 32, loop
    
    # save hamming distance in v0
    add $v0, $0, $s2
    
    # get s registers' original value from the stack
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    addi $sp, $sp, 24
    
    jr $ra
    
    
