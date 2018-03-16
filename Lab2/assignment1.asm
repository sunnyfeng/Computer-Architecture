#Yuqing (Sunny) Feng
#170006296 yf184

#read 2 non-negative int n and m
#sum all values between m and n (inclusive)
#print result with message
#print error message when negative number entered

.data
  inputStr: .asciiz "Enter two non-negative integers: \n"
  outputStr: .asciiz "The sum of numbers between m and n inclusive is: "
  errorStr: .asciiz "Error. Can't enter a negative number. Ending.\n"

.text
main:
# $t0 = m , $t1 = n

li $v0, 4		#command to print input str
la $a0, inputStr
syscall

li $v0, 5		#command to read first number
syscall
move $t0, $v0		#store input in $t0 register

li $v0, 5		#command to read first number
syscall
move $t1, $v0		#store input in $t1 register

j ifStateA

#### FUNCTIONS ####

#check if negative
ifStateA:
  slt $t3, $t0, $zero  #if m is less than 0
  beq $t3, $zero, ifStateB
  li $v0, 4		#command to print error str
  la $a0, errorStr
  syscall
  li $v0, 10  #exit program
  syscall

ifStateB:
  slt $t3, $t1, $zero  #if $t0 is less than 0
  beq $t3, $zero, findSmaller
  li $v0, 4		#command to print error str
  la $a0, errorStr
  syscall
  li $v0, 10  #exit program
  syscall

findSmaller:
slt $t3, $t0, $t1  #if m is less than n
beq $t3, $zero, Else
move $a0, $t0
move $a1, $t1
j loopSum
Else:
  #if n is greater than m
  move $a0, $t1
  move $a1, $t0
  j loopSum

loopSum:
  # $a0 = smaller number, $a1 = larger number
  # $v0 = stores sum result

  move $t0, $a0
  move $t1, $a1

  addi $t1, $t1, 1      # set n+1

  li $v0, 0
  loopA:
  beq $t0, $t1, end       # if m == n+1, end
  add $v0, $v0, $t0
  addi $t0, $t0, 1        # add 1 to m
  j loopA                  # jump back to the top
  end:
  j printAnswer

printAnswer:

  add $s0, $zero, $v0

  li $v0, 4		#command to print output str
  la $a0, outputStr
  syscall

  li $v0, 1		#print the answer (stored in $s0)
  move $a0, $s0
  syscall

  li $v0, 10  #exit program
  syscall
