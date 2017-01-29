.data
x: .word 0
y: .word 0
.text
.globl main
main:
        li $v0,5
        syscall
        sw $v0,x #takes input from user and store it in x
        li $v0,5
        syscall
        sw $v0,y #takes second numbe and store it in y
        lw $t0,x
        lw $t1,y
        li $t7,-5
        li $t8,-7
        mul $t2,$t0,$t7
        mul $t3,$t1,$t8
        add $t4,$t2,$t3 #calculate required sum
        blt $t4,-35,Neg
        bgt $t4,35,Pos
        move $v1,$t4
        j exit

Neg:
        li $v1,-35
        j exit

Pos:
        li $v1,35
        j exit
        
exit:
        li $v0,1
        move $a0,$v1
        syscall #qtspim code for printing integer

        li $v0,10 
        syscall #qtspim code for termination
.end main
