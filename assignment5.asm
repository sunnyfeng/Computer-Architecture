.text
.globl main
main:


loopA:
beq $t0, $s0, end       # if i == a, end

  loopB:
  beq $t1, $s1, end       # if j == b, end

  mult $t0, $t0         #$t2 = i^2
  mflo $t2

  mult $t1, $t1         #$t3 = j^2
  mflo $t3

  add $t2, $t2, $t3    #$t2 = i^2 + j^2

  li $t3, 4             #can't use mult with just immediate
  mult $t1, $t3
  mflo $t3              #$t3 = j*4 (4 bytes assumed)

  add $a0, $s2, $t3     #get the address of the jth element in array D

  sw $t2, 0($a0)        #save i^2+j^2 into $a0, which is the jth element of D

  addi $t1, $t1, 1        # add 1 to j
  j loopB                  # jump back to the top
  end:

addi $t0, $t0, 1        # add 1 to i
j loopA                  # jump back to the top
end:
