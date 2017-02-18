.data
msg1: .asciiz "No. of rows\n"
msg2: .asciiz "No. of columns\n"
msg3: .asciiz "Enter no. of rows x no. of columns double pecision\n"
msg4: .asciiz "Number of columns in matrix 2\n"
hi:   .asciiz "HI"
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
    li $s4,8
    mul $a0,$s4,$s3
    li $v0,9
    syscall
    move $a1,$v0
    addi $s6,$a1,0
    addi $s5,$s3,0
    la $a0,msg3
    li $v0,4
    syscall
input1:
    beq $s5,0,next
    li $v0,7
    syscall
    s.d $f0,0($s6)
    l.d $f2,0($s6)
    addi $s6,$s6,8
    addi $s5,$s5,-1
    j input1

next:
    li $v0,4
    la $a0,msg4
    syscall
    li $v0,5
    syscall
    move $s5,$v0
    mul $a0,$s2,$s5
    sll $a0,$a0,3
    li $v0,9
    syscall
    move $a2,$v0
    addi $s7,$a2,0
    srl $a0,$a0,3
    addi $s6,$a0,0
    move $s0,$a0
input2:
    beq $s0,0,matmult
    li $v0,7
    syscall
    s.d $f0,0($s7)
    addi $s7,$s7,8
    addi $s0,$s0,-1
    j input2

matmult:
    mul $a0,$s1,$s5
    sll $a0,$a0,3
    li $v0,9
    syscall
    move $a3,$v0
    srl $a0,$a0,3
    li $t0,0
    li $t1,0
    li $t2,0
    
loop1:
    beq $t0,$s1,exit

loop2:
    addi $t0,$t0,1
    beq $t1,$s5,loop1
    l.d $f4,0
loop3:
    addi $t1,$t1,1
    beq $t2,$s2,flag
    mul $t4,$t0,$s2
    add $t4,$t4,$t2
    sll $t4,$t4,3
    add $t4,$a1,$t4
    l.d $f0,0($t4)
    mul $t4,$t2,$s5
    add $t4,$t4,$t1
    sll $t4,$t4,3
    add $t4,$t4,$a2
    l.d $f2,0($t4)
    mul.d $f0,$f0,$f2
    add.d $f4,$f4,$f0
    addi $t2,$t2,1
    j loop3
flag:
    mul $t4,$t0,$s5
    add $t4,$t4,$t1
    sll $t4,$t4,3
    add $t4,$t4,$a3
    s.d $f4,0($t4)
    j loop2
    


exit:
    li $v0,10
    syscall
.end main
