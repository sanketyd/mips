.data
binary: .asciiz "00000000000000000000000000000000"
.text
.globl main
main:
        li $v0,5
        syscall

        move $s1,$v0
        li $s2,2
        li $s3,31
        li $s4,31
        li $s5,0
        bgt $s1,$zero,positive
#sub $s1,$zero,$s1
#negative:
#       beq $s1,$zero,compliment
#       rem $t0,$s1,$s2
#       lb $t1,binary($s3)
#add $t2,$t0,$t1
#       sb $t2,binary($s3)
#       div $s1,$s1,$s2
#       addi $s3,$s3,-1
#       j negative

#compliment:
#       blt $s4,$zero,exit
#       beq $s5,$zero,check

#check:
#       beq binary($s4),$zero,update

#update:
# $
positive:
        beq $s1,$zero,exit
        rem $t0,$s1,$s2
        lb $t1,binary($s3)
        add $t2,$t0,$t1
        sb $t2,binary($s3)
        div $s1,$s1,$s2
        addi $s3,$s3,-1
        j positive

exit:
        la $a0,binary
        li $v0,4
        syscall

        li $v0,10
        syscall

.end main
