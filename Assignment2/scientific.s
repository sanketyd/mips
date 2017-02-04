.data
nega: .asciiz "-"
posi: .asciiz "+"
exp: .asciiz "e"
dot: .asciiz "."
expon: .asciiz "00"
.text
.globl main
main:
        li $v0,5
        syscall
        mtc1 $v0,$f0
        cvt.s.w $f0,$f0 #Take 1st numerator as input and convert it to float

        li $v0,5
        syscall
        mtc1 $v0,$f1
        cvt.s.w $f1,$f1  #Take 1st denominator as input and convert it to float

        li $v0,5
        syscall
        mtc1 $v0,$f2
        cvt.s.w $f2,$f2

        li $v0,5
        syscall
        mtc1 $v0,$f3
        cvt.s.w $f3,$f3

        div.s $f0,$f0,$f1
        div.s $f1,$f2,$f3
        add.s $f0,$f0,$f1 #Converts fractions to float and add them

        li $t0,10
        mtc1 $t0,$f2
        cvt.s.w $f2,$f2 

        li $t0,1
        mtc1 $t0,$f3
        cvt.s.w $f3,$f3

        li $t0,100
        mtc1 $t0,$f4
        cvt.s.w $f4,$f4

        li $t0,2
        mtc1 $t0,$f5
        cvt.s.w $f5,$f5
        div.s $f5,$f3,$f5 #There are some values we need again and again, they are declared here and stored in float registors

        li $s0,0

        li $t0,0
        mtc1 $t0,$f1
        cvt.s.w $f1,$f1
        c.lt.s $f0,$f1
        bc1t negative


positive: #Branch if no. is positive
        c.eq.s $f0,$f1
        bc1t round
        c.le.s $f0,$f2
        bc1f gtt
        c.lt.s $f0,$f3
        bc1t glo
        j round

gtt:
        div.s $f0,$f0,$f2
        addi $s0,$s0,1
        j positive

glo:
        mul.s $f0,$f0,$f2
        addi $s0,$s0,-1
        j positive

round: #Rounding of decimal to 2 decimal places.
#Algorithm :- Multiply 1<=float<10 by 100 and add 0.5 if positive(We are dealing with absolute value so always add) and change it to integer.
        mul.s $f0,$f0,$f4
        add.s $f0,$f0,$f5
        cvt.w.s $f0,$f0
        mfc1 $s1,$f0
        li $t8,100
        div $t1,$s1,$t8
        li $v0,1
        move $a0,$t1
        syscall
        mul $t1,$a0,$t8
        sub $s1,$s1,$t1
        la $a0,dot
        li $v0,4
        syscall
        li $t8,10
        div $t1,$s1,$t8
        move $a0,$t1
        li $v0,1
        syscall
        rem $s1,$s1,$t8
        move $a0,$s1
        li $v0,1
        syscall
        j exit

exit: #Formatted output if exponent is '-'ve
        la $a0,exp
        li $v0,4
        syscall
        bge $s0,0,flag
        sub $s0,$zero,$s0
        la $a0,nega
        li $v0,4
        syscall 
        lb $t6,expon($zero)
        li $t9,10
        div $t1,$s0,$t9
        add $t6,$t1,$t6
        sb $t6,expon($zero)
        li $t7,1
        lb $t6,expon($t7)
        rem $t1,$s0,$t9
        add $t6,$t1,$t6
        sb $t6,expon($t7)
        la $a0,expon
        li $v0,4
        syscall

        li $v0,10
        syscall

flag: #Formatted output if exponent part is '+'ve
        la $a0,posi
        li $v0,4
        syscall
        lb $t6,expon($zero)
        li $t9,10
        div $t1,$s0,$t9
        add $t6,$t1,$t6
        sb $t6,expon($zero)
        li $t7,1
        lb $t6,expon($t7)
        rem $t1,$s0,$t9
        add $t6,$t1,$t6
        sb $t6,expon($t7)
        la $a0,expon
        li $v0,4
        syscall
        li $v0,10
        syscall

negative: #Branch if number is negative
        la $a0,nega
        li $v0,4
        syscall
        abs.s $f0,$f0
        j positive


.end main
