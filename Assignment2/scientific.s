.data
nega: .asciiz "-"
posi: .asciiz "+"
exp: .asciiz "e"
dot: .asciiz "."
.text
.globl main
main:
        li $v0,5
        syscall
        mtc1 $v0,$f0
        cvt.s.w $f0,$f0

        li $v0,5
        syscall
        mtc1 $v0,$f1
        cvt.s.w $f1,$f1

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
        add.s $f0,$f0,$f1

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
        div.s $f5,$f3,$f5

        li $s0,0

        li $t0,0
        mtc1 $t0,$f1
        cvt.s.w $f1,$f1
        c.lt.s $f0,$f1
        bc1t negative


positive:
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

round:
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

exit:
        la $a0,exp
        li $v0,4
        syscall
        bge $s0,0,flag
        li $v0,1
        move $a0,$s0
        syscall
        li $v0,10
        syscall

flag:
        la $a0,posi
        li $v0,4
        syscall
        li $v0,1
        move $a0,$s0
        syscall
        li $v0,10
        syscall

negative:
        la $a0,nega
        li $v0,4
        syscall
        abs.s $f0,$f0
        j positive


.end main
