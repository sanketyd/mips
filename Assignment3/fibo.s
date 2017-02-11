.data
fibo: .space 84
space: .asciiz " "
.text
.globl main

main:
        li $v0,5
        syscall

        addi $a1,$v0,1
        addi $s3,$a1,0

        la $a3,fibo
        add $s4,$a3,$zero
        li $s1,0
        sw $s1,0($a3)
        addi $a3,$a3,4
        li $s2,1
        sw $s2,0($a3)

fib:
        ble $a1,2,print
        add $t0,$s1,$s2
        move $s1,$s2
        move $s2,$t0
        addi $a3,$a3,4
        sw $s2,0($a3)
        addi $a1,$a1,-1
        j fib

print:
        beq $s3,0,exit
        lw $a0,0($s4)
        li $v0,1
        syscall
        la $a0,space
        li $v0,4
        syscall
        addi $s4,$s4,4
        addi $s3,$s3,-1
        j print

exit:
        li $v0,10
        syscall
.end main
