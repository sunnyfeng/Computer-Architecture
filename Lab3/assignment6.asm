#Yuqing Feng
#170006296 yf184
#Bubble sort floating point array

.data
  unsortedArrayStr: .asciiz "Unsorted array:\n"
  sortedArrayStr: .asciiz "Sorted array:\n"
  spaceStr: .asciiz " "
  newLineStr: .asciiz "\n"
  swapStr: .asciiz " swapped with "

  #10 elements
  #array: .float 4.5, 10.5, 3.0, 1.0, -4.8, -3.7, 20.4, 1.5, 2.5, 6.4
  array: .float 7.9, 1.4, 3.3, 9.4, -2.0, -3.7, 30.7, 12.3, 2.5, 2.0

.text
main:

  li $v0, 4
  la $a0, unsortedArrayStr
  syscall

  #set up printing array
  li $t0, 0     #counter i
  li.s $f1, 0.0     #stores value of item
  li $t2, 40    #stores only 10 items (8*10)
  la $s0, array   #base address
  la $s1, array   #incrementing address

  jal printArray

  #set up sorting array
  li $t0, 0         #counter i
  li $t1, 0         #counter j
  li.s $f1, 0.0     #float for arr[j]
  li.s $f2, 0.0     #float for arr[j+1]
  li $t2, 1         #number of swaps
  li $t3, 36        #n-1
  li $t4, 0         #n-1-i for j
  la $s0, array     #base address
  la $s1, array     #incrementing address
  la $s2, array     #will be always $s1 + 4 --> arr[j+1]

  jal sortOuter

  li $v0, 4
  la $a0, sortedArrayStr
  syscall

  #set up printing array
  li $t0, 0     #counter i
  li.s $f1, 0.0     #stores value of item
  li $t2, 40    #stores only 10 items (8*10)
  la $s0, array   #base address
  la $s1, array   #incrementing address

  jal printArray

  li $v0, 10
  syscall

sortOuter:

  beqz $t2, endOuter  #end when num swaps = 0

  #reinitialize
  li $t1, 0   #j = 0
  li $t2, 0   #num swaps = 0
  sub $t4, $t3, $t0       #t1 = $t3 - $t0 --> n-1-i
  la $s1, array     #incrementing address for j
  la $s2, array     #will be always $s1 + 4 --> arr[j+1]

  sortInner:
    beq $t1, $t4, endInner  #if j = n-1-i, end inner loop

    lwc1 $f1, 0($s1)        #arr[j]
    addi $s2, $s1, 4        #j+1 of array
    lwc1 $f2, 0($s2)        #arr[j+1]

    c.le.s $f1, $f2
    bc1t continueInner           #if arr[j] <= arr[j+1], skip swap
    nop

    #here, arr[j] > arr[j+1] --> do swap
    swc1 $f2, 0($s1)      #arr[j] = arr[j+1] value
    swc1 $f1, 0($s2)      #arr[j+1] = arr[j] value
    addi $t2, $t2, 1      #increment number of swaps

    continueInner:
    addi $t1, $t1, 4  #j++
    add $s1, $s0, $t1
    j sortInner
  endInner:

  addi $t0, $t0, 4  #i++
  j sortOuter

endOuter:
  jr $ra

printArray:
  #load with floating point -> reference: http://www.ece.lsu.edu/ee4720/2014/lfp.s.html

  lwc1 $f1, 0($s1)
  beq $t0, $t2, endPrint #counter

  mov.s $f12, $f1
  li $v0, 2
  syscall

  li $v0, 4
  la $a0, spaceStr
  syscall

  addi $t0, $t0, 4  #4 because float = 4 bytes
  add $s1, $s0, $t0
  j printArray
endPrint:
  li $v0, 4
  la $a0, newLineStr
  syscall
  jr $ra
