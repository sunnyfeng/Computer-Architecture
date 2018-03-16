#Yuqing Feng
#170006296 yf184

.data
  inputFullStr: .asciiz "How full is the tank, between 0 and 1? (ex: 0.45)\n"
  inputGalStr: .asciiz "How many gallons of gas can the tank hold? \n"
  inputPriceStr: .asciiz "What is the price of gas per gallon is USD? \n"
  outputStr: .asciiz "The price you should pay to fill the tank is: "
  errorStr: .asciiz "At least one input is improperly formatted. Ending."

.text
main:

  li $v0, 4
  la $a0, inputFullStr
  syscall

  li $v0, 6
  syscall
  mov.s $f1, $f0  #f1 = how full tank is

  li $v0, 4
  la $a0, inputGalStr
  syscall

  li $v0, 6
  syscall
  mov.s $f2, $f0  #f2 = total gal tank can hold

  li $v0, 4
  la $a0, inputPriceStr
  syscall

  li $v0, 6
  syscall
  mov.s $f3, $f0  #f3 = price per gallon

  #error checking --> referenced https://chortle.ccsu.edu/AssemblyTutorial/Chapter-32/ass32_3.html
  li.s $f4, 1.0
  c.lt.s $f4, $f1
  bc1t inputError #if fullness of tank greater than 1, bad
  nop

  li.s $f4, 0.0
  c.lt.s $f1, $f4
  bc1t inputError #if fullness of tank less than 0, bad
  nop

  c.lt.s $f2, $f4
  bc1t inputError #is total gas tank is less than 0, bad
  nop

  c.lt.s $f3, $f4
  bc1t inputError #if price is less than or equal to 0, bad
  nop

  #calculations
  li.s $f4, 1.0
  sub.s $f1, $f4, $f1   #f1 = 1-f1 --> how empty tank is

  mul.s $f1, $f1, $f2   #how empty tank is * total gal = gallons needed
  mul.s $f12, $f1, $f3  #gal needed * price per gallon = total price

  li $v0, 4
  la $a0, outputStr
  syscall

  li $v0, 2
  syscall

  li $v0, 10
  syscall

inputError:
  li $v0, 4
  la $a0, errorStr
  syscall

  li $v0, 10
  syscall
