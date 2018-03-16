#Yuqing (Sunny) Feng
#RUID: 170006296
#NetID: yf184
#Comp. Arch. Lab with Bangtian Liu

.data
  a1Str: .asciiz "Input integer a1: "
  nStr: .asciiz "\nInput nth term integer n: "
  dStr: .asciiz "\nInput common difference integer d: "
  outStr: .asciiz "\nThe answer is: "

.text
.globl main
main:

li $v0, 4		#command to print a1Str
la $a0, a1Str
syscall

li $v0, 5		#command to read a1
syscall
move $t0, $v0		#store input in $t0 (a1) register

li $v0, 4		#command to print nStr
la $a0, nStr
syscall

li $v0, 5		#command to read n
syscall
move $t1, $v0		#store input in $t1 (n) register

li $v0, 4		#command to print dStr
la $a0, dStr
syscall

li $v0, 5		#command to read n
syscall
move $t2, $v0		#store input in $t2 (d) register

#solving
sub $t1, $t1, 1   #n = n-1
mult $t1, $t2
mflo $t3          #$t3 = (n-1)*d
add $t4, $t0, $t3   #$t4 = a1 + (n-1)*d

li $v0, 4		#command to print outStr
la $a0, outStr
syscall

li $v0, 1		#print the answer (stored in $t4)
move $a0, $t4
syscall

li $v0, 10  #exit program
syscall
