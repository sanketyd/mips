.data
msg1: .asciiz "No. of rows\n"
msg2: .asciiz "No. of columns\n"
msg3: .asciiz "Enter no. of rows x no. of columns double pecision\n"
msg4: .asciiz "Number of columns in matrix 2\n"
A: .space 1000
B: .space 1000
C: .space 1000
.text
.globl main
main:
        li $v0,4
        la $a0,msg1
        syscall
        li $v0,5
        syscall
        move $s1,$v0
        li $v0,4
        la $a0,msg2
        syscall
        li $v0,5
        syscall
        move $s2,$v0
        mul $s3,$s1,$s2
        li $s4,0
        li $v0,4
        la $a0,msg3
        syscall
input1:
        beq $s3,0,next
        li $v0,7
        syscall
        sdc1 $f0,A($s4)
        addi $s4,$s4,8
        addi $s3,$s3,-1
        j input1

next:
        li $v0,4
        la $a0,msg4
        syscall
        li $v0,5
        syscall
        move $s4,$v0
        mul $s5,$s4,$s2
        li $s6,0
        li $v0,4
        la $a0,msg3
        syscall
input2:
        beq $s5,0,matmult
        li $v0,7
        syscall
        sdc1 $f0,B($s6)
        addi $s6,$s6,8
        addi $s5,$s5,-1
        j input2

matmult:
        li $v0,10
        syscall
.end main
