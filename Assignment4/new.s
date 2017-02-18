#s1=n->no. of rows of first matrix.
#s2=k->no. of columns of first matrix which obviously is colums of second matrix
#s4=m->no. of columns second matrix.
.data
A: .space 1000#First matrix
B: .space 1000#Second matrix
C: .space 1000#Third matrix
msg1: .asciiz "No. of rows\n"
msg2: .asciiz "No. of columns\n"
msg3: .asciiz "Enter elements of matrix double pecision\n"
msg4: .asciiz "Number of columns in matrix 2\n"
msg5: .asciiz "Matrix is\n"
newline: .asciiz "\n"
spac: .asciiz " "
.text
.globl main
main:
        li $v0,4
        la $a0,msg1
        syscall
        li $v0,5
        syscall
        move $s1,$v0#Take n as input
        li $v0,4
        la $a0,msg2
        syscall
        li $v0,5
        syscall
        move $s2,$v0#Input k
        mul $s3,$s1,$s2
        li $s4,0
        li $v0,4
        la $a0,msg3
        syscall
input1:#Take elements of matrix1 as input (row wise) , (Every element in newline)
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
        move $s4,$v0#Take number of columns of matrix2 as input. (No need to enter no. of rows of matrix 1. as no. of rows of matrix2=no. of columns in matrix 1)
        mul $s5,$s4,$s2
        li $s6,0
        li $v0,4
        la $a0,msg3
        syscall
input2:#Take elements of matrix 2 as input
        beq $s5,0,matmult
        li $v0,7
        syscall
        sdc1 $f0,B($s6)
        addi $s6,$s6,8
        addi $s5,$s5,-1
        j input2

matmult:
        li $t0,0
#t0 is i;t1 is j;t2 is k
loop1:
        beq $t0,$s1,x
        li $t1,0
loop2:
        beq $t1,$s4,flag2
        mtc1.d $zero,$f4
        cvt.d.w $f4,$f4
        li $t2,0
loop3:
        beq $t2,$s2,flag
        mul $t7,$t0,$s2
        add $t7,$t7,$t2
        sll $t7,$t7,3
        ldc1 $f0,A($t7)#Load double from data
        mul $t7,$t2,$s4
        add $t7,$t7,$t1
        sll $t7,$t7,3
        ldc1 $f2,B($t7)
        mul.d $f0,$f0,$f2
        add.d $f4,$f4,$f0
        addi $t2,$t2,1
        j loop3
flag:
        mul $t7,$t0,$s4
        add $t7,$t7,$t1
        sll $t7,$t7,3
        sdc1 $f4,C($t7)
        addi $t1,$t1,1
        j loop2
flag2:
        addi $t0,$t0,1
        j loop1

x:#Print Matrix
        la $a0,msg5
        li $v0,4
        syscall
        li $t1,0
print:
        beq $t1,$s1,exit
        li $t0,0
print2:
        beq $t0,$s4,print1
        mul $t2,$t1,$s4
        add $t2,$t2,$t0
        sll $t2,$t2,3
        ldc1 $f12,C($t2)
        li $v0,3
        syscall
        la $a0,spac
        li $v0,4
        syscall
        addi $t0,$t0,1
        j print2
print1:
        la $a0,newline
        li $v0,4
        syscall
        addi $t1,$t1,1
        j print

exit:
        li $v0,10
        syscall

.end main
