#Yuqing Feng
#170006296 yf184

.data
  inputStr: .asciiz "Enter integer numbers A, B, and C:\n"
  outputStr: .asciiz "F =(A OR C)' AND (B AND C)' is: \n"

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

  li $v0, 5
  syscall
  move $t2, $v0  # c

  or $t0, $t0, $t2  # a = a or c
  not $t0, $t0     # a = a'

  and $t1, $t1, $t2 # b = b and c
  not $t1, $t1     # b = b'

  and $t1, $t0, $t1   # t1 = a and b

  li $v0, 4
  la $a0, outputStr
  syscall

  li $v0, 1
  move $a0, $t1
  syscall

  li $v0, 10
  syscall
