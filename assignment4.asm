.data
  inputStr: .asciiz "Input an integer from 1 to 20: "
  calcStr: .asciiz "Calculating the cube’s volume with sides of "
  inchStr: .asciiz " inches"
  outputStr: .asciiz "\nThe volume of the cube is: "

.text
.globl main
main:
  li $v0, 4		#command to print input string
  la $a0, inputStr
  syscall

  li $v0, 5		#command to read integer
  syscall
  move $t0, $v0		#store side in $t0 register

  li $v0, 4		#print calculating string
  la $a0, calcStr
  syscall

  li $v0, 1		#print user input
  move $a0, $t0
  syscall

  li $v0, 4		#finish printing calculating string
  la $a0, inchStr
  syscall

  mult $t0, $t0		#multiply by itself and stores in $t1
  mflo $t1

  mult $t1, $t0		#multiply the square by $t0 again
  mflo $t2

  li $v0, 4		#print output string
  la $a0, outputStr
  syscall

  li $v0, 1		#print result of cubing
  move $a0, $t2
  syscall

  li $v0, 10
  syscall
