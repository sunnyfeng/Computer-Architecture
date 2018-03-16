#Yuqing (Sunny) Feng
#170006296 yf184

#read password
#compare strings and if match, end program
#if not, print mismatched characters of the second string
  #prompt user for another input and check again
  #print appropriate messages and terminate the program

.data
  setPasswordStr: .asciiz "Set a password:\n"
  firstFailedStr: .asciiz "\nFailed. Please enter a password with size 8 to 12 and with only upper and lower case letters.\n"
  badStr: .asciiz "\nFailure to input correctly. Program ending."
  reenterStr: .asciiz "\nPlease reenter the password:\n"
  TwoChanceStr: .asciiz "Incorrect, you have 2 more chances.\n"
  OneChanceStr: .asciiz "Incorrect, you have 1 more chance.\n"
  goodStr: .asciiz "Password is setup.\n"

  password: .space 64
  reenteredPassword: .space 13

.text
main:

li $v0, 4		#command to setPasswordStr
la $a0, setPasswordStr
syscall

li $v0, 8   #read password
la $a0, password
li $a1, 64
syscall

#initializing checkPassword
la $s0, password   #$s0 = password
la $s1, password  #$s1 = incrementing password
li $t1, 0   #stores byte (char)
li $t0, 0   #counter i

li $t2, 1   #number of tries to put password in right

li $t3, 0   #load with character range to check

j checkPassword

checkPassword:
  lb $t1, 0($s1)    #t1 is the char of first string
  beqz $t1, endPasswordCheck     #if string ends, endPasswordCheck
  beq $t1, '\n', endPasswordCheck #if string ends with new line, endPasswordCheck

  #make sure characters are only uppercase or lower case
  li $t3, 'A'
  bltu $t1, $t3, badEntryFirst    #if char $t1 less than A, definitely not a letter
  li $t3, 'z'
  bltu $t3, $t1, badEntryFirst    #if 'z' is less than char $t1, definitely not a letter
  li $t3, 'Z'
  bltu $t3, $t1, checkIfLowerCase  #if 'Z' is less than char $t1, could be lowercase

  addi $t0, $t0, 1    #increment i
  add $s1, $s0, $t0   #increment char of password string
  j checkPassword

checkIfLowerCase:
  li $t3, 'a'
  bltu $t1, $t3, badEntryFirst    #if char $t1 less than a but greater than Z, not a letter

  #char is lowercase letter here

  addi $t0, $t0, 1    #increment i
  add $s1, $s0, $t0   #increment char of password string
  j checkPassword

endPasswordCheck:

  #length count one too many
  li $t1, 1
  sub $t0, $t0, $t1     # t0 = $t0 - 1

  #check if length okay

  li $t1, 8
  bltu $t0, $t1, badEntryFirst
  li $t1, 12
  bltu $t1, $t0, badEntryFirst

  #right length
  j firstEntryCorrect

badEntryFirst:

  beqz $t2, badEntrySecond  #no more chances = go to second bad entry section

  li $t2, 0   #num of password entries left

  li $v0, 4		#tell user they failed first time
  la $a0, firstFailedStr
  syscall

  li $v0, 4		#command to setPasswordStr
  la $a0, setPasswordStr
  syscall

  li $v0, 8   #read password
  la $a0, password
  li $a1, 64
  syscall

  #initializing checkPassword
  la $s0, password   #$s0 = password
  la $s1, password  #$s1 = incrementing password
  li $t1, 0   #stores byte (char)
  li $t0, 0   #counter i

  j checkPassword

badEntrySecond:
  li $v0, 4		#tell user they failed first time
  la $a0, badStr
  syscall

  li $v0, 10
  syscall

firstEntryCorrect:
  #ask for reentry and check that
  li $v0, 4		#tell user to reenter correct password
  la $a0, reenterStr
  syscall

  li $v0, 8   #read reentered password
  la $a0, reenteredPassword
  li $a1, 13
  syscall

  li $t3, 2   #two more tries to enter it right

  la $s0, password   #$s0 = password
  la $s1, password  #$s1 = incrementing password
  la $s2, reenteredPassword
  la $s3, reenteredPassword   #s3 = incrementing reentered password
  li $t1, 0   #stores byte (char) of original password
  li $t2, 0   #stores byte (char) of reentered password
  li $t0, 0   #counter i

  j matchPasswords

matchPasswords:
  lb $t1, 0($s1)    #t1 is the char of original str
  lb $t2, 0($s3)    #t2 is char of reentered str

  #beq $t1, '\n', checkIfSameLengthOriginal
  #beq $t2, '\n', checkIfSameLengthReentered
  beqz $t1, checkIfSameLengthOriginal
  beqz $t2, checkIfSameLengthReentered

  bne $t1, $t2, reentryWrong    #mismatched = not correct

  addi $t0, $t0, 1    #increment i
  add $s1, $s0, $t0   #increment char of password string
  add $s3, $s2, $t0   #increment char of reentered string
  j matchPasswords

checkIfSameLengthOriginal:
  #beq $t2, '\n', reentryMatches
  beqz $t2, reentryMatches
  j reentryWrong

checkIfSameLengthReentered:
  #beq $t1, '\n', reentryMatches
  beqz $t1, reentryMatches
  j reentryWrong

reentryWrong:
  beqz $t3, noMoreRetries
  li $t4, 1
  beq $t3, $t4, oneMoreRetry
  sub $t3, $t3, $t4   #subtract by 1

  #two retries left
  li $v0, 4		#Does not matches, another try
  la $a0, TwoChanceStr
  syscall

  li $v0, 4		#tell user to reenter correct password
  la $a0, reenterStr
  syscall

  li $v0, 8   #read reentered password
  la $a0, reenteredPassword
  li $a1, 13
  syscall

  la $s0, password   #$s0 = password
  la $s1, password  #$s1 = incrementing password
  la $s2, reenteredPassword
  la $s3, reenteredPassword   #s3 = incrementing reentered password
  li $t1, 0   #stores byte (char) of original password
  li $t2, 0   #stores byte (char) of reentered password
  li $t0, 0   #counter i

  j matchPasswords

reentryMatches:
  li $v0, 4		#Matches, good!
  la $a0, goodStr
  syscall

  li $v0, 10
  syscall

oneMoreRetry:
  li $t3, 0

  #ask for reentry and check that
  li $v0, 4		#tell user one more chance
  la $a0, OneChanceStr
  syscall

  li $v0, 4		#tell user to reenter correct password
  la $a0, reenterStr
  syscall

  li $v0, 8   #read reentered password
  la $a0, reenteredPassword
  li $a1, 13
  syscall

  la $s0, password   #$s0 = password
  la $s1, password  #$s1 = incrementing password
  la $s2, reenteredPassword
  la $s3, reenteredPassword   #s3 = incrementing reentered password
  li $t1, 0   #stores byte (char) of original password
  li $t2, 0   #stores byte (char) of reentered password
  li $t0, 0   #counter i

  j matchPasswords

noMoreRetries:
  li $v0, 4		#no more retries, print and end program
  la $a0, badStr
  syscall

  li $v0, 10
  syscall
