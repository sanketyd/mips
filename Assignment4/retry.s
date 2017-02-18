.data
msg1: .asciiz "No. of rows\n"
msg2: .asciiz "No. of columns\n"
msg3: .asciiz "Enter no. of rows x no. of columns double pecision\n"
msg4: .asciiz "Number of columns in matrix 2\n"
.text
.globl main
main:
        la $a0,msg1
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $s1,$v0
        la $a0,msg2
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $s2,$v0
        mul $s3,$s1,$s2
        sll $a0,$s3,3
        li $v0,9
        syscall
        move $a1,$v0
        addi $s4,$a1,0
        addi $s5,$s3,0
        la $a0,msg3
        li $v0,4
        syscall
input1:
        beq $s5,0,next
        li $v0,7
        syscall
        sdc1 $f0,0($s4)
        addi $s4,$s4,8
        addi $s5,$s5,-1
        j input1

next:
        li $v0,4
        la $a0,msg4
        syscall
        li $v0,5
        syscall
        move $s4,$v0
        mul $a0,$s2,$s4
        sll $a0,$a0,3
        li $v0,9
        syscall
        addi $a2,$v0,0
        addi $s5,$a2,0
        mul $s6,$s2,$s4
input2:
        beq $s6,0,matmult
        li $v0,7
        syscall
        sdc1 $f0,0($s5)
        addi $s5,$s5,8
        addi $s6,$s6,-1
        j input2

matmult:
        ldc1 $f12,0($a2)
        li $v0,2
        syscall

        li $v0,10
        syscall

.end main

