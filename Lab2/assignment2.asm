#Yuqing Feng
#170006296 yf184

.data
  inputStr: .asciiz "Enter a positive integer <= 100: \n"
  outputStr: .asciiz "The closest prime number >= n is: "
  errorStr: .asciiz "Error. n is not between 1 and 100. Ending.\n"

.text
main:
  li $v0, 4		#command to print input str
  la $a0, inputStr
  syscall

  li $v0, 5		#command to read number
  syscall
  move $t0, $v0		#store input in $t0 register

  jal checkInRange

  li $t1, 102         #first prime number after 100 = 101

  PrimeLoop:
  beq $t0, $t1, endP       # if n == 102, end

    li $s0, 2
    InnerLoop:
    beq $s0, $t0, foundPrime
      div $t0, $s0       # n mod i
      mfhi $s1
      beq $s1, $zero, endI
      addi $s0, $s0, 1
    j InnerLoop
    endI:


  addi $t0, $t0, 1         # increment n by 1
  j PrimeLoop              # jump back to the top
  endP:

  li $v0, 10
  syscall

foundPrime:
  li $v0, 4		#command to print output str
  la $a0, outputStr
  syscall

  li $v0, 1		#print the answer (stored in $t0)
  move $a0, $t0
  syscall

  li $v0, 10  #exit program
  syscall


checkInRange:
  li $t1, 1
  slt $t3, $t0, $t1  #if n is less than 1
  beq $t3, $zero, ElseA

  #if n is less than 1
  li $v0, 4		#command to print error str
  la $a0, errorStr
  syscall

  li $v0, 10
  syscall

  ElseA:
  li $t1, 100
  slt $t3, $t1, $t0  #if 100 is less than n (if n > 100)
  beq $t3, $zero, ElseB

  #if n is greater than 100
  li $v0, 4		#command to print error str
  la $a0, errorStr
  syscall

  li $v0, 10
  syscall

  ElseB:
    jr $ra
