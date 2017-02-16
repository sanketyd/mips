.data
array:  .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
len:    .word      12
.text
.globl main
main:
        li $v0,5
        syscall
        move $a0,$v0
        la $a1,array
        la $t0,len
        lw $t0,0($t0)
        sll $t0,$t0,2
        addi $t0,$t0,-4
        add $a2,$t0,$a1
        jal binsearch

        beq $v0,0,no
        la $t1,array
        subu $a0,$v0,$t1
        addi $a0,$a0,4
        sra $a0,$a0,2
        li $v0,1
        syscall
        li $v0,10
        syscall

no:
        move $a0,$v0
        li $v0,1
        syscall

        li $v0,10
        syscall
.end main

binsearch:
        addi $sp,$sp,-4
        sw $ra,4($sp)
        
        subu $t0,$a2,$a1
        bnez $t0,search

        move $v0,$a1
        lw $t0,($v0)
        beq $a0,$t0,exit
        li $v0,0
        b exit

search:
        sra $t0,$t0,3
        sll $t0,$t0,2
        addu $v0,$a1,$t0
        lw $t0,($v0)
        beq $t0,$a0,exit
        blt $a0,$t0,left

right:
        addu $a1,$v0,4
        jal binsearch
        b exit

left:
        move $a2,$v0
        jal binsearch

exit:
        lw $ra,4($sp)
        addi $sp,$sp,4
        jr $ra
