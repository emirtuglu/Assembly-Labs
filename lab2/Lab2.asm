.data
    prompt1: .asciiz "Enter size of the array: "
    prompt2: .asciiz "Enter the next array element: "
    prompt3: .asciiz "Enter the index: "
    prompt4: .asciiz "Number of occurances of the array element at given index: "
    newline: .asciiz "\n"
    
.text
Main:
    # Get the array size from the user
    la $a0, prompt1
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    add $s0, $0, $v0  # s0 = array size
    
    add $a0, $0, $s0
    jal CreateArray
    add $s1, $0, $v0  # s1 = array address
    
    # Get the index from user
    la $a0, prompt3
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    add $s2, $0, $v0  # s2 = index
    
    # Get the number at index s2
    add $a0, $0, $s1
    add $a1, $0, $s2
    jal GetNumberAtGivenIndex
    add $s3, $0, $v0  # s3 = number at the index
    
    # Get the number of occurances of s3 in the array
    add $a0, $0, $s1
    add $a1, $0, $s3
    add $a2, $0, $s0
    jal GetNumberOfOccurances
    add $s4, $0, $v0  # s4 = number of occurances
    
    # Print the result
    la $a0, prompt4
    li $v0, 4
    syscall
    move $a0, $s4
    li $v0, 1
    syscall
    
    # Exit the program
    li $v0, 10
    syscall
    
# input: a0 = array size
CreateArray:
    # Save s registers to the stack
    addi $sp, $sp -20
    sw $s4, 16($sp)
    sw $s3, 12($sp)
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)
    
    # Storing return address in s4
    move $s4, $ra
    
    # Multiplying array size with 4, since each int needs 4 bytes to allocate
    mul $a0, $a0, 4
    mflo $a0
    
    # Allocating memory for the array
    li $v0, 9
    syscall
    move $s0, $v0	# s0 = pointer to the allocated memory
    
    # Dividing array size by 4 to obtain its original value
    div $a0, $a0, 4
    
    jal InitializeArray
    
    # print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # Return the pointer to the allocated memory in $v0
    move $v0, $s0
    move $ra, $s4
    
    # Getting s registers' values back from stack
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    addi $sp, $sp, 20
    
    jr $ra  
    
InitializeArray:
    li $s1, 0
    move $s2, $a0  #s2 = size of the array
    move $s3, $s0  #s3 = array
    
loop:
    bge $s1, $s2, loop_exit
 
    # Prompt user for input
    la $a0, prompt2
    li $v0, 4
    syscall
    
    li $v0, 5
    syscall
    
    #Store input in array
    sw $v0, ($s3)
    
    addi $s3, $s3, 4
    addi $s1, $s1, 1
    j loop
    
loop_exit:
    jr $ra
    
#inputs: a0 = array, a1 = index
GetNumberAtGivenIndex:
    # Save s registers to the stack
    addi $sp, $sp -20
    sw $s4, 16($sp)
    sw $s3, 12($sp)
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)
    
    move $s0, $a0 # s0 = array
    move $s1, $a1 # s1 = index
    li $s2, 0 # s2 = loop var
    
loop2:
    beq $s2, $s1, loop_exit2
    addi $s0, $s0, 4
    addi $s2, $s2, 1
    j loop2
loop_exit2:
    lw $v0, 0($s0)
    
    # Getting s registers' values back from stack
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    addi $sp, $sp, 20
    
    jr $ra

#inputs: a0 = array, a1 = number, a2 = array size
GetNumberOfOccurances:
    # Save s registers to the stack
    addi $sp, $sp -24
    sw $s5, 20($sp)
    sw $s4, 16($sp)
    sw $s3, 12($sp)
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)
    
    move $s0, $a0  # s0 = array
    move $s1, $a1  # s1 = number
    move $s2, $a2  # s2 = array size
    li $s3, 0      # s3 = number of occurances
    li $s4, 0      # loop var

loop3:  
    beq $s2, $s4, loop_exit3
    # load the next element in the array
    lw $s5, 0($s0)
    
    # if the number at index is equal to the desired number, add it to number of occurances
    seq $s5, $s5, $s1
    add $s3, $s3, $s5
    
    addi $s0, $s0, 4
    addi $s4, $s4, 1
    j loop3
loop_exit3:
    move $v0, $s3
    
    # Getting s registers' values back from stack
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    addi $sp, $sp, 24
    
    jr $ra
    
    
