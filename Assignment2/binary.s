.data
binary: .asciiz "00000000000000000000000000000000" #Initialisation of array (32 bit representation)
.text
.globl main
#Algorithm used to calculate 2's compliment :
#   do nothing until first 1 is encountered(moving from left to right) after that flag is set one and flip all other 0's and 1's
main:
        li $v0,5
        syscall #Input integer

        move $s1,$v0
        li $s2,2
        li $s3,31
        li $s4,31 #s3 and s4 are for indexing.
        li $s5,0 #Flag for checking if 1 has encountered or not
        bge $s1,$zero,positive
        sub $s1,$zero,$s1
        blt $s1,$zero,negative

negative: #if the number is negative then binary form of the absolute value is calculated.
        beq $s1,$zero,compliment
        rem $t0,$s1,$s2
        lb $t1,binary($s3)
        add $t2,$t0,$t1
        sb $t2,binary($s3)
        div $s1,$s1,$s2
        addi $s3,$s3,-1
        j negative

compliment: #calculate 2's compliment
        blt $s4,$zero,exit
        beq $s5,$zero,check
        lb $t8,binary($s4)
        beq $t8,'1',flip
        addi $t9,$t8,1
        sb $t9,binary($s4)
        addi $s4,$s4,-1
        j compliment

flip: #Flip if it's value is 1
        lb $t8,binary($s4)
        addi $t9,$t8,-1
        sb $t9,binary($s4)
        addi $s4,$s4,-1
        j compliment

check: #set flag
        lb $t6,binary($s4)
        beq $t6,'0',update
        addi $s5,$s5,1
        addi $s4,$s4,-1
        j compliment

update: #update indexing
        addi $s4,$s4,-1
        j compliment

positive: #Calculate binary if number is positive
        beq $s1,$zero,exit
        rem $t0,$s1,$s2
        lb $t1,binary($s3)
        add $t2,$t0,$t1
        sb $t2,binary($s3)
        div $s1,$s1,$s2
        addi $s3,$s3,-1
        j positive

exit:
        la $a0,binary #qtspim command to print binary
        li $v0,4
        syscall

        li $v0,10 #qtspim command to exit 
        syscall

.end main
