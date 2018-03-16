#Yuqing (Sunny) Feng
#170006296 yf184

#read 2 strings
#compare strings and if match, end program
#if not, print mismatched characters of the second string
  #prompt user for another input and check again
  #print appropriate messages and terminate the program

.data
  inputStr: .asciiz "Enter two strings to be compared: \n"
  badStr: .asciiz "\nStrings do not match.\n"
  secondTryStr: .asciiz "Enter second string again: \n"
  goodStr: .asciiz "Strings match! Program ending.\n"

  firstStr: .space 64
  secondStr: .space 64

.text
main:

li $v0, 4		#command to print input str
la $a0, inputStr
syscall

li $v0, 8   #read first string
la $a0, firstStr
li $a1, 64
syscall

li $v0, 8   #read second string
la $a0, secondStr
li $a1, 64
syscall

la $s1, firstStr   #$s1 = first string
la $s2, secondStr   #$s2 = second string
la $s3, firstStr
la $s4, secondStr
li $t1, 0
li $t2, 0
li $t0, 0   #counter i
li $s0, 0   #counter of number of different characters

li $t3, 1   #0 = second time it runs through compare, 1 = first time going through compare

j compare

#comparison - uses $s1-4, $t0-2
compare:
  lb $t1, 0($s3)    #t1 is the char of first string
  lb $t2, 0($s4)    #t2 is the char of second string

  beqz $t1, printTrail     #if first string ends, end
  beqz $t2, secondStringEnd     #if second string ends, end

  bne $t1, $t2, diffChar    #diff character

  add $s3, $s1, $t0   #increment char of first string
  add $s4, $s2, $t0   #increment char of second string
  addi $t0, $t0, 1    #increment i
  j compare

#print trailing characters of second string
printTrail:
  lb $t2, 0($s4)    #t2 is the char of second string
  beqz $t2, endTrail     #if second string ends, end

  addi $s0, $s0, 1   #increment number of different characters

  li $v0, 11
  la $a0, 0($t2)
  syscall

  add $s4, $s4, 1   #increment char of second string
  j printTrail

endTrail:
  beqz $s0, matches #if num of diff char = 0, matches and end
  j doesntMatch

#first string did not end and second string did = does not match
secondStringEnd:
  addi $s0, $s0, 1   #increment number of different characters to signify not matching
  j endTrail

matches:
  li $v0, 4		#command to print matches str
  la $a0, goodStr
  syscall

  li $v0, 10
  syscall

doesntMatch:

  li $v0, 4		#command to print bad str
  la $a0, badStr
  syscall

  beqz $t3, endProgram

  li $t3, 0 #second and last time going through compare

  li $v0, 4		#command to print second try str
  la $a0, secondTryStr
  syscall

  li $v0, 8   #read second string
  la $a0, secondStr
  li $a1, 64
  syscall

  la $s1, firstStr   #$s1 = first string
  la $s2, secondStr   #$s2 = second string
  la $s3, firstStr
  la $s4, secondStr
  li $t1, 0
  li $t2, 0
  li $t0, 1   #counter i
  li $s0, 0   #counter of number of different characters

  j compare

diffChar:
  li $v0, 11
  la $a0, 0($t2)
  syscall

  addi $s0, $s0, 1   #increment number of different characters

  add $s3, $s1, $t0   #increment char of first string
  add $s4, $s2, $t0   #increment char of second string
  addi $t0, $t0, 1    #increment i
  j compare

endProgram:
  li $v0, 10
  syscall
