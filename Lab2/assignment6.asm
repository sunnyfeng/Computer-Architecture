#Yuqing (Sunny) Feng
#170006296 yf184

.data
  sortedArrayStr: .asciiz "Sorted array:\n"
  enterNumStr: .asciiz "Enter a number to search: \n"
  endStr: .asciiz "Program ending.\n"
  numAtIndexStr: .asciiz "Number at index "
  spaceStr: .asciiz " "
  newLineStr: .asciiz "\n"
  array: .word 45, 85, 34, 79, 13, 20, 20, 5, 0xF

.text
main:

  #initializing sorting
  li $t0, 0     #counter i
  li $t1, 0     #counter j
  li $t2, 0xF   #store end of array 0xF = 15
  li $t3, 0     #char for counter i
  li $t4, 0     #char for counter j
  li $t5, 0     #temp storage

  la $s0, array   #base address
  la $s1, array   #incrementing address for i
  la $s2, array   #incrementing address for j

  jal sortArrayOuter

  li $v0, 4
  la $a0, sortedArrayStr
  syscall

  #initializing printing
  li $t0, 0     #counter i
  li $t1, 0     #stores element
  li $t2, 0xF   #store end of array 0xF = 15
  la $s0, array   #base address
  la $s1, array   #incrementing address

  jal printArray

  j getNumLoop

  li $v0, 10
  syscall

sortArrayOuter:
  lw $t3, 0($s1)
  beq $t3, $t2, endOuter    #if at end, exit loop

  addi $t1, $t0, 4    #j = i + 1
  add $s2, $s0, $t1   # get jth element

  sortArrayInner:
    lw $t3, 0($s1)  #reload after swap
    lw $t4, 0($s2)
    beq $t4, $t2, endInner    #if at end, exit loop

    bltu $t3, $t4, swapElements   #if array[i] < array[j], swap

    addi $t1, $t1, 4    # j++
    add $s2, $s0, $t1   # get jth element
    j sortArrayInner
  endInner:

  addi $t0, $t0, 4      # word is 4 bytes
  add $s1, $s0, $t0     # get ith element
  j sortArrayOuter
endOuter:
  jr $ra

swapElements:
  sw $t4, 0($s1)  #put value of arr[j] into arr[i] location
  sw $t3, 0($s2)  #put value of arr[i] into arr[j] location

  #go back to loop
  addi $t1, $t0, 4    # j = i + 1 element
  add $s2, $s0, $t1   # get jth element
  j sortArrayInner

printArray:
  lw $t1, 0($s1)
  beq $t1, $t2, endPrint

  li $v0, 1
  move $a0, $t1
  syscall

  li $v0, 4
  la $a0, spaceStr
  syscall

  addi $t0, $t0, 4  #4 because word = 4 bytes
  add $s1, $s0, $t0
  j printArray

endPrint:
  li $v0, 4
  la $a0, newLineStr
  syscall
  jr $ra

getNumLoop:
  li $v0, 4
  la $a0, enterNumStr
  syscall

  li $v0, 5
  syscall
  move $t1, $v0   # t1 = target num

  blt $t1, $zero, endGetNumLoop    #negative number  = end program

  li $t0, 0     #counter i
  li $t2, 0xF   #store end of array 0xF = 15
  li $t3, 0     #char for counter i
  la $s0, array   #base address
  la $s1, array   #incrementing address for i

  #search for that number and then either report index or insert into array
  searchLoop:
    lw $t3, 0($s1)
    beq $t3, $t2, addAtEndOfArray
    beq $t3, $t1, numFound        ##if t3 = target num $t1,, found!
    bltu $t3, $t1, foundAtIndex     #if t3 element < target num $t1, go

    addi $t0, $t0, 4  #increment i
    add $s1, $s0, $t0 #increment element location
  j searchLoop
  endSearchLoop:

  #initializing printing
  li $t0, 0     #counter i
  li $t1, 0     #stores element
  li $t2, 0xF   #store end of array 0xF = 15
  la $s0, array   #base address
  la $s1, array   #incrementing address

  jal printArray

  j getNumLoop
endGetNumLoop:
  li $v0, 4
  la $a0, endStr
  syscall

  li $v0, 10
  syscall

foundAtIndex:
  #at index $t0 in element address $s1, element $t3 is either equal or less than target
  beq $t3, $t1, numFound

  #initial insert
  lw $t4, 0($s1)
  sw $t1, 0($s1)
  add $t0, $t0, 4
  add $s1, $s0, $t0
  j insertNum

insertNum:
  #at index $t0 in element address $s1, element $t3 less than target
  lw $t5, 0($s1)
  sw $t4, 0($s1)
  beq $t5, $t2, endInsertNum

  move $t4, $t5

  addi $t0, $t0, 4
  add $s1, $s0, $t0
endInsertNum:
  addi $t0, $t0, 4
  add $s1, $s0, $t0
  sw $t5, 0($s1)
  j endSearchLoop

numFound:
  li $v0, 4
  la $a0, numAtIndexStr
  syscall

  #divide $t0 by 4 to get the index by shifting right 2^2
  sra $t0, $t0, 2

  li $v0, 1
  move $a0, $t0
  syscall

  li $v0, 4
  la $a0, newLineStr
  syscall

  j getNumLoop

addAtEndOfArray:
  #if it gets to the end and is greater than all those numbers, add at end
  sw $t1, 0($s1)
  addi $t0, $t0, 4  #increment i
  add $s1, $s0, $t0 #increment element location
  sw $t3, 0($s1)

  j endSearchLoop
