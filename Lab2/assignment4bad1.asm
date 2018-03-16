#Yuqing (Sunny) Feng
#170006296 yf184

#read 2 strings
#compare strings and if match, end program
#if not, print mismatched characters of the second string
  #prompt user for another input and check again
  #print appropriate messages and terminate the program

.data
  inputStr: .asciiz "Enter two strings to be compared: \n"
  secondTryStr: .asciiz "Strings do not match. Enter second string again: \n"
  badStr: .asciiz "Strings still do not match. Ending Program.\n"
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
li $s0, 0   #matching counter - if 0, then twas a match
li $t1, 0
li $t2, 0

jal compare

beqz $s0, stringsMatched

li $s0, 0   #reset unmatched character counter

li $v0, 4		#command to print secondTry str
la $a0, secondTryStr
syscall

li $v0, 8   #read new second string
la $a0, secondStr
li $a1, 64
syscall

la $s2, secondStr   #$s2 = second string
li $t1, 0
li $t2, 0

jal compare

beqz $s0, stringsMatched

li $v0, 4		#command to print matched str
la $a0, badStr
syscall

li $v0, 10
syscall

#if strings match, terminate program
stringsMatched:
  li $v0, 4		#command to print matched str
  la $a0, goodStr
  syscall

  li $v0, 10
  syscall

#comparison
compare:
  lb $t1, 0($s1)    #t1 is the char of first string
  lb $t2, 0($s2)    #t2 is the char of second string
  add
  beqz $t1, printTrail     #if first string ends, end
  beqz $t2, printTrail     #if second string ends, end

  beq $t1, $t2, equalChar    #if same character, continue

  #here = not equal char --> print diff char
  add $s0, $s0, 1   #increment number of unmatched characters
  li $v0, 11
  lbu $a0, 0($t2)
  syscall

  add $t1, $t1, 1   #increment char of first string
  add $t2, $t2, 1   #increment char of second string
  j compare

#print trailing characters of second string
printTrail:
  beqz $t2, endTrail     #if second string ends, end

  li $v0, 11
  lbu $a0, 0($t2)
  syscall

  add $t2, $t2, 1   #increment char of second string
  j printTrail

endTrail:
  jr $ra


equalChar:
  add $t1, $t1, 1   #increment char of first string
  add $t2, $t2, 1   #increment char of first string
  add $t0, $t0, 1   #increment length counter
  j compare
