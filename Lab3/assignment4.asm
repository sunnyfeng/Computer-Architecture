#Yuqing Feng
#170006296 yf184

.data
  inputRadStr: .asciiz "Enter the radius:\n"
  inputAngStr: .asciiz "Enter the angle in degrees:\n"
  outputStr: .asciiz "The area is the circular sector is: "

.text
main:

  li $v0, 4
  la $a0, inputRadStr
  syscall

  li $v0, 6
  syscall
  mov.s $f1, $f0  #f1 = radius

  li $v0, 4
  la $a0, inputAngStr
  syscall

  li $v0, 6
  syscall
  mov.s $f2, $f0  #f2 = angle

  li.s $f3, 360.0  #f3 = 360
  li.s $f4, 3.14159265359  #f4 = pi

  div.s $f2, $f2, $f3   # angle = angle/360
  mul.s $f1, $f1, $f1   # r = r^2
  mul.s $f1, $f1, $f4   # r = r^2 * pi
  mul.s $f12, $f1, $f2   # f12 = pi*r^2 * angle/360

  li $v0, 4
  la $a0, outputStr
  syscall

  li $v0, 2
  syscall

  li $v0, 10
  syscall
