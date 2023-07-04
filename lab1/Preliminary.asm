.data
    array: .space 80 # Allocate 80 bytes = space enough to hold 20 words
    noOfElementsMessage: .asciiz "Enter the number of elements: "
    nextElementMessage: .asciiz "Enter the next element: "
    newline: .asciiz "\n"
    integerMessage: .asciiz "Enter an integer number (N): "
    eqMessage: .asciiz "Number of array members equal to N: "
    ltMessage: .asciiz "Number of array members less than N: "
    gtMessage: .asciiz "Number of array members greater than N: "
    dvMessage: .asciiz "Number of elements evenly divisible by N: "


.text
main:
li $v0, 4
la $a0, noOfElementsMessage
syscall

li $v0, 5
syscall
move $t0, $v0  	# t0 = number of elements

li $t1, 0 	# t1 = loop variable
la $t2, array 	# t2 = array address

loop1:
  li $v0, 4
  la $a0, nextElementMessage
  syscall

  li $v0, 5
  syscall

  sw $v0, ($t2)

  addi $t1, $t1, 1
  addi $t2, $t2, 4
  bne $t1, $t0, loop1

li $v0, 4
la $a0, newline
syscall

# Ask user to enter N
li $v0, 4
la $a0, integerMessage
syscall

li $v0, 5
syscall
move $t3, $v0  # t3 = N

li $t1, 0 	# t1 = loop variable
la $t2, array 	# t2 = array address
li $t4, 0	# t4 = number of array members equal to N
li $t5, 0	# t5 = number of array members less than N
li $t6, 0	# t6 = number of array members greater than N
li $t7, 0	# t7 = number of elements evenly divisible by N

loop2:
  lw $t8, ($t2)	# t8 = i'th element in the array
  bne $t3, $t8 less_than
  addi $t4, $t4, 1
  j divisible
    less_than:
      bgt $t3, $t8, greater_than
      addi $t5, $t5, 1
      j divisible
    greater_than:
      addi $t6, $t6, 1

  divisible:
  div $t8, $t3
  mfhi $t9	# t9 = remainder
  bne $t9 $0 rest
  addi $t7, $t7, 1
  
  rest:
  addi $t1, $t1, 1
  addi $t2, $t2, 4
  bne $t1, $t0, loop2
  
# Print the number of elements equal to N
li $v0, 4
la $a0, eqMessage
syscall
li $v0, 1
move $a0, $t4
syscall
li $v0, 4
la $a0, newline
syscall

# Print the number of elements less than N
li $v0, 4
la $a0, ltMessage
syscall
li $v0, 1
move $a0, $t5
syscall
li $v0, 4
la $a0, newline
syscall

# Print number of elements greater than N
li $v0, 4
la $a0, gtMessage
syscall
li $v0, 1
move $a0, $t6
syscall
li $v0, 4
la $a0, newline
syscall

# Print number of elements evenly divisible by N
li $v0, 4
la $a0, dvMessage
syscall
li $v0, 1
move $a0, $t7
syscall
li $v0, 4
la $a0, newline
syscall
