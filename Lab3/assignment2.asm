#Yuqing Feng
#170006296 yf184

.data
  inputStr: .asciiz "Enter two integer numbers a and b (from 1 - 1000):\n"
  outputStr: .asciiz "a/b = "
  badStr: .asciiz "At least one input not between 1 and 1000 inclusive. Ending."

.text
main:

  li $v0, 4
  la $a0, inputStr
  syscall

  li $v0, 5
  syscall
  move $t0, $v0 # a

  li $v0, 5
  syscall
  move $t1, $v0  # b

  #check ranges and make sure within the range
  li $t2, 1
  bltu $t0, $t2, badInput
  bltu $t1, $t2, badInput
  li $t2, 1000
  bltu $t2, $t0, badInput
  bltu $t2, $t1, badInput

  #divide using subtraction
  li $t2, 0 #number of divisions
  j loop

loop:
  blt $t0, $t1, endLoop #if a less than b, endLoop
  sub $t0, $t0, $t1
  addi $t2, $t2, 1
  j loop
endLoop:

  li $v0, 4
  la $a0, outputStr
  syscall

  li $v0, 1
  move $a0, $t2
  syscall

  li $v0, 10
  syscall

badInput:
  li $v0, 4
  la $a0, badStr
  syscall

  li $v0, 10
  syscall
