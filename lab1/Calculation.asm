.data
    prompt1: .asciiz "Enter first integer value: "
    prompt2: .asciiz "Enter second integer value: "
    prompt3: .asciiz "Enter third integer value: "
    prompt4: .asciiz "Result: "

.text

main:
  # Getting first input
  li $v0, 4
  la $a0, prompt1
  syscall
  
  li $v0, 5
  syscall
  move $s0, $v0 #s0 = a
  
  # Getting second input
  li $v0, 4
  la $a0, prompt2
  syscall
  
  li $v0, 5
  syscall
  move $s1, $v0 #s1 = b
  
  # Getting third input
  li $v0, 4
  la $a0, prompt3
  syscall
  
  li $v0, 5
  syscall
  move $s2, $v0 #s2 = c
  
  # Calculating the result
  add $t0, $s0, $s1  # t0 = a + b
  div $s0, $s1
  mflo $t1  # t1 = a/b
  sub $t1, $t1, $s2  # t1 = (a/b) - c
  mul $t0, $t0, $t1  # t0 = (a+b)((a/b) -c)
  li $t2, 10
  div $t0, $t2
  mfhi $s3  # s3 = result
  
  
  # Printing the result
  li $v0, 4
  la $a0, prompt4
  syscall
  li $v0, 1
  move $a0, $s3
  syscall
