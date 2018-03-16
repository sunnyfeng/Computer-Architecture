#Yuqing Feng
#170006296 yf184

.data
  inputStr: .asciiz "Enter a positive integer <= 1000: \n"
  outputStr: .asciiz "The sum of even num up to n - sum of odd num up to n is: "
  errorStr: .asciiz "Error. n is not between 1 and 1000. Ending.\n"

.text
main:
  li $v0, 4		#command to print input str
  la $a0, inputStr
  syscall

  li $v0, 5		#command to read number
  syscall
  move $t0, $v0		#store input in $t0 register

  jal checkInRange

  jal sumEven   #sum even - stored in $s0

  jal sumOdd    #sum odd - stored in $s1

  sub $s0, $s0, $s1   #$s0 = evens - odds

  li $v0, 4		#command to print output str
  la $a0, outputStr
  syscall

  li $v0, 1		#print the answer (stored in $s0)
  move $a0, $s0
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
  li $t1, 1000
  slt $t3, $t1, $t0  #if 100 is less than n (if n > 1000)
  beq $t3, $zero, ElseB

  #if n is greater than 100
  li $v0, 4		#command to print error str
  la $a0, errorStr
  syscall

  li $v0, 10
  syscall

  ElseB:
    jr $ra

sumEven:    #sum even - stored in $s0
  li $s0, 0
  li $t2, 2         # to mod 2
  li $t3, 0
  addi $t3, $t0, 1   #$t3 = n + 1
  li $t4, 1         #$t4 = the "i"
  EvenLoop:
  beq $t4, $t3, endEven
    div $t4, $t2      # n mod 2
    mfhi $t5
    beq $t5, $zero, evenAdd
  addi $t4, $t4, 1
  j EvenLoop
  endEven:

  jr $ra

  evenAdd:
    add $s0, $s0, $t4
    addi $t4, $t4, 1
    j EvenLoop

sumOdd:
  li $s1, 0
  li $t2, 2         # to mod 2
  li $t3, 0
  addi $t3, $t0, 1   #$t3 = n + 1
  li $t4, 1         #$t4 = the "i"
  OddLoop:
  beq $t4, $t3, endOdd
    div $t4, $t2      # n mod 2
    mfhi $t5
    beq $t5, $zero, oddAdd
    add $s1, $s1, $t4
  addi $t4, $t4, 1
  j OddLoop
  endOdd:

  jr $ra

oddAdd:
  addi $t4, $t4, 1
  j OddLoop
