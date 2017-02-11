.data
space: .asciiz " "
.text
.globl main
main:
        li $v0,5
        syscall
        move $a0,$v0
        sll $a0,$a0,2
        li $v0,9
        syscall#Qtspim command to Dynamically allot memory. Number of bytes=$a0
        move $a1,$v0
        srl $a0,$a0,2
        addi $s0,$a0,0
        addi $s1,$a1,0
input:#Input array
        beq $s0,0,s
        li $v0,5
        syscall
        sw $v0,0($s1)
        addi $s1,$s1,4
        addi $s0,$s0,-1
        j input

s:#Call function sort and save value stored in $a0(which is n) to $s7 because we need $a0 for printing.
        jal sort
        move $s7,$a0
print:#Prints array
        beq $s7,0,exit
        lw $a0,0($a1)
        li $v0,1
        syscall
        la $a0,space
        li $v0,4
        syscall
        addi $a1,$a1,4
        addi $s7,$s7,-1
        j print
        

exit:
        li $v0,10
        syscall

.end main

swap:#Function swap. swap if A[i]>A[i+1].
        bgt $a2,$a3,swp
        jr $ra

swp:
        move $t8,$a2
        move $a2,$a3
        move $a3,$t8
        jr $ra

sort:#Sort function
        addi $sp,$sp,-4
        sw $ra,0($sp)#Storing value of $ra in stack because we will lose $ra while calling swap
        addi $s1,$a0,0#i
loop1:#$s1 is i and $s2 is j
        beq $s1,0,yo
        addi $s2,$s1,0
        addi $s1,$s1,-1
        addi $s0,$a1,0
        j loop2
        
loop2:
        beq $s2,1,loop1
        lw $a2,0($s0)
        lw $a3,4($s0)
        jal swap
        sw $a2,0($s0)
        sw $a3,4($s0)
        addi $s0,$s0,4
        addi $s2,$s2,-1
        j loop2
#Algorithm:-
#       for(i=n;i>0;i--){
#           for(j=i;j>1;j--){
#               if A[j]>A[j+1] swap
#           }
#       }

yo:#Returning to main
        lw $ra,0($sp)
        addi $sp,$sp,4
        jr $ra
