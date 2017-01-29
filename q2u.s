.data
c: .asciiz "yo Bro%tU tattI haI"
r: .asciiz ""
.text
.globl main
main:
        li $t0,'A'
        li $t1,'a'
        sub $s0,$t0,$t1
#lb $t7,c
loop:
        lb $t2,c($t8)
        bge $t2,'a',cs
        sb $t2,r($t8)
        addi $t8,$t8,1
        beq $t2,$zero,exit
        j loop

cs:
        ble $t2,'z',updat
        sb $t2,r($t8)
        addi $t8,$t8,1
        j loop

updat:
        add $s1,$s0,$t2
        sb $s1,r($t8)
        addi $t8,$t8,1
        j loop

exit:
        li $v0,4
        la $a0,r
        syscall

        li $v0,10
        syscall
.end main
