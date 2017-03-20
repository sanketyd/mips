.data
array:  .word 1, 2, 3, 3, 4, 4, 6
len:    .word      7
inu:    .asciiz "Enter a positive number you want to search.\n"
.text
.globl main
main:
        li $v0,4
        la $a0,inu
        syscall
        li $v0,5
        syscall
        move $a0,$v0
#a0->value to be searched.
        la $a1,array
#a1->address of array
        la $t0,len
        lw $t0,0($t0)
        sll $t0,$t0,2
        addi $t0,$t0,-4
        add $a2,$t0,$a1
#a2->adress of last word in array
        jal binsearch

        beq $v0,-1,no#Branch if number is not present in array
        la $t1,array
        subu $a0,$v0,$t1
        sra $a0,$a0,2#Above 4 lines calculate index of element. We got no. of bytes between first and that index=byte/4
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
        sw $ra,0($sp)
        
        subu $t0,$a2,$a1
        bnez $t0,search

        move $v0,$a1
        lw $t0,($v0)
        beq $a0,$t0,exit
        li $v0,-1
        b exit

search:
        sra $t0,$t0,3
        sll $t0,$t0,2#$t0->middle element, we didn't use $t0/2 because that can't be multiple of 4. e.g- 12/2=6 but (12/8)*4=4 multiple of 4.
#As we know in mips it's always a multiple of 4.
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
        lw $ra,0($sp)
        addi $sp,$sp,4
        jr $ra
