.data
    prompt1: .asciiz "Enter the size of the arrays: "
    prompt2: .asciiz ". Array next element: "
    prompt3: .asciiz "Hamming Distance: "
    newline: .asciiz "\n"
    space: .asciiz " "
    arrayNo: .asciiz ". Array: "

.text
main:
    # Prompt for the size of the array
    li $v0, 4
    la $a0, prompt1
    syscall

    # Read the size of the  array
    li $v0, 5
    syscall
    move $s0, $v0  # $s0 = size of the arrays

    move $a0, $s0
    li $a1, 1
    jal CreateArray
    move $s1, $v0 # $s1 = address of the first array
    
    move $a0, $s0
    li $a1, 2
    jal CreateArray
    move $s2, $v0 # $s2 = address of the second array
    
    move $a0, $s1
    move $a1, $s0
    li $a2, 1
    jal PrintArray
    
    move $a0, $s2
    move $a1, $s0
    li $a2, 2
    jal PrintArray
    
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal CalculateDistance
    move $s3, $v0 # s3 = distance
    
    # Print Distance
    li $v0, 4
    la $a0, prompt3
    syscall
    li $v0, 1
    move $a0, $s3
    syscall
    
    # Exit program
    li $v0, 10
    syscall
    
#input: $a0 = array size, $a1 = array number
CreateArray:
    # Saving s registers' values to stack
    addi $sp, $sp, -20
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
    
    # Print newline
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
    move $a0, $a1
    li $v0 1
    syscall
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

# input: $a0 = array, $a1 = size of the array, $a2 = array number
PrintArray:
    # Saving s registers' values to stack
    addi $sp, $sp, -12
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)
    
    move $s0, $a0  # t0 = array
    move $s1, $a1  # t1 = array size
    
    # Printing array number
    move $a0, $a2
    li $v0, 1
    syscall
    la $a0, arrayNo
    li $v0, 4
    syscall
    
    # Loop through the array and print each element
    li $s2, 0
    
loop2:
    bge $s2, $s1, loop_exit2
    
    lw $a0, ($s0)
    
    li $v0, 1
    syscall
    
    addi $s0, $s0, 4
    addi $s2, $s2, 1
    
    # print space
    la $a0, space
    li $v0, 4
    syscall
    
    j loop2
    
loop_exit2:
    # print newline
    la $a0, newline
    li $v0, 4
    syscall
    
    # Getting s registers' values back from stack
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    addi $sp, $sp, 12
    
    jr $ra
    
# a0 = size of arrays, a1 = first array, a2 = second array
CalculateDistance:
    # Saving s registers' values to stack
    addi $sp, $sp, -28
    sw $s6, 24($sp)
    sw $s5, 20($sp)
    sw $s4, 16($sp)
    sw $s3, 12($sp)
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)
    
    move $s0, $a0 # t0 = array size
    move $s1, $a1 # t1 = first array
    move $s2, $a2 # t2 = second array
    
    addi $s3, $0, 0 # iterator
    addi $s4, $0, 0 # t4 = distance
    
loop3:
    bge $s3, $s0, loop_exit3
    
    lw $s5, ($s1)
    lw $s6, ($s2)
    
    addi $s1, $s1, 4
    addi $s2, $s2, 4
    addi $s3, $s3, 1
    
    beq $s5, $s6, loop3
    addi $s4, $s4, 1
    j loop3
    
loop_exit3:
    move $v0, $s4
    # Getting s registers' values back from stack
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $s6, 24($sp)
    addi $sp, $sp, 28
    
    jr $ra
    
    

