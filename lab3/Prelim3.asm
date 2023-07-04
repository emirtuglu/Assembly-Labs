.data
	prompt1: .asciiz "Enter size of the linked list: "
	prompt2: .asciiz "\nEnter number to be removed: "
	prompt3: .asciiz "Enter next value of the linked list: "
	
.text
	
main:
	la $a0, prompt1
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s0, $v0 # s0 = size of the linked list
	
	move $a0, $s0
	jal createLinkedList
	move $s2, $v0 # s2 = head of the linked list to be copied
	
	la $a0, prompt2
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s1, $v0 # s1 = number to be removed
	
	move $a0, $s2
	move $a1, $s0
	move $a2, $s1
	jal CopyAllExcept_x
	move $s3 $v0  # s3 = new list
	
	move $a0, $s3
	jal printLinkedList
	
	li $v0, 10
	syscall
	
	
CopyAllExcept_x:
	addi	$sp, $sp, -40
	sw	$s0, 32($sp)
	sw	$s1, 28($sp)
	sw	$s2, 24($sp)
	sw	$s3, 20($sp)
	sw	$s4, 16($sp)
	sw	$s5, 12($sp)
	sw	$s6, 8($sp)
	sw	$s7, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move $s0, $a0  # s0 = head of the list to be copied
	move $s1, $a1  # s1 = size of list
	move $s2, $a2  # number to be removed
	li $s3, 0 # s3 = current index
	
	li $a0, 8
	li $v0, 9
	syscall
	move $s5, $v0 # s5 = head of new list
	sw $s5, 40($sp) # store return value
	
	loop:
		beq $s3, $s1, loopExit
		lw $s4, 4($s0)  # s4 = current element 
		beq $s4, $s2, removeElement   #if current element is the element to be removed, branch
		
		# Allocate new node
		li $a0, 8
		li $v0, 9
		syscall
		move $s6, $v0 
		
		sw $s4, 4($s5)
		sw $s6, 0($s5)
		
		move $s7, $s5 #prev node
		move $s5, $s6
		addi $s3, $s3, 1
		lw $s0, 0($s0)
		j loop
		
	removeElement:
		lw $s0, 0($s0)
		addi $s3, $s3, 1
		j loop
		
	loopExit:
		move $v0, $s7
		addi $s3, $s3, -1
		sw $zero, 0($s5)
		sw $zero, 0($s7)
		lw $v0, 40($sp)
		lw $ra, 0($sp)
		lw $s7, 4($sp)
		lw $s6, 8($sp)
		lw $s5, 12($sp)
		lw $s4, 16($sp)
		lw $s3, 20($sp)
		lw $s2, 24($sp)
		lw $s1, 28($sp)
		lw $s0, 32($sp)
		addi $sp, $sp, 40
		jr $ra
		
	
createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
	la $a0, prompt3
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s4, $v0
	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	la $a0, prompt3
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $s4, $v0
	sw	$s4, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================		
	.data
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "

	
