.data
c: .space 100 #allocating 100bytes to variable c
r: .asciiz ""
.text
.globl main
main:
        li $t0,'A'
        li $t1,'a'
        sub $s0,$t0,$t1 #stores -32 in $0 (adding this to smaller case converts them to uppercase)
    
        li $v0,8
        la $a0,c
        li $a1,100
        syscall #qtspim command for string input $a0 is pointer to variable and $a1 is length of string

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
        syscall #qtspim command for printing string

        li $v0,10
        syscall
.end main
