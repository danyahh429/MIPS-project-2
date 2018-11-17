.data
    nullErrorMessage:	.asciiz "Input is empty."
    lengthErrorMessage: .asciiz "Input is too long."
    baseErrorMessage:   .asciiz "Invalid base-34 number."
    userInput:		.space 50
.text
    main:
	li $v0, 8       #get user input as txt 
	la $a0, userInput
	li $a1, 50
	li $a1, 50
	syscall
	
	removeLeading:  #Remove leading spaces
	li $t8, 32      #Save space char to t8
	beq $t8, $t9, removeFirst
	move $t9, $a0
	j checkLength

	removeFirst:
	addi $a0, $a0, 1
	j removeLeading

	checkLength:   #Count the number of chars in string
	addi $t0, $t0, 0  #Initialize count at zero
	addi $t1, $t1, 10  #Save line feed charr to t1
	add $t4, $t4, $a0  #Preserve the content of a0

	lengthLoop:
	lb $t2, 0($a0)   #Load the next char to t2
	beqz $t2, done   #End loop if null char is reached
	beq $t2, $t1, done   #End loop if end-of-line is detected
	addi $a0, $a0, 1   #Increment the string ptr
	addi $t0, $t0, 1
	j lengthLoop

	done:
	beqz $t0, nullError   #Branch to null error if length is 0 or null
	slti $t3, $t0, 5      #Check that count is less than 5
	beqz $t3, lengthError #Branch to length error if length is 5 or more
	move $a0, $t4
	j checkString

	nullError:
	li $v0, 4
	la $a0, nullErrorMessage
	syscall
	j exit
	
	lengthError:
	li $v0, 4
	la $a0, lengthErrorMessage
	syscall
	j exit

	checkString:
	lb $t5, 0($a0)
	beqz $t5, conversionInitializations  #End loop if null char is reached
	beq $t5, $t1, conversionInitializations  #End loop if end-of-line char is detected
	slti $t6, $t5, 48    #Check if the char is less than 0  or there is (Invalid input)
	bne $t6, $zero, baseError
	slti $t6, $t5, 58    #Check if the char is less than 58->9 (Valid input)
	bne $t6, $zero, Increment
	slti $t6, $t5, 65    #Check if the char is less than 65->A (Invalid input)
	bne $t6, $zero, baseError
	slti $t6, $t5, 89    #Check if the char is less than 89->Y(Valid input)
	bne $t6, $zero, Increment
	slti $t6, $t5, 97    #Check if the char is less than 97->a(Invalid input)
	bne $t6, $zero, baseError
	slti $t6, $t5, 121   #Check if the char is less than 121->y(Valid input)
	bne $t6, $zero, Increment
	bgt $t5, 120, baseError   #Check if the character is greater than 120->x(Invalid input)

	Increment:
	addi $a0, $a0, 1
	j checkString

	baseError:
	li $v0, 4
	la $a0, baseErrorMessage
	syscall
	j exit

	conversionInitializations:
	move $a0, $t4
	addi $t7, $t7, 0  #Initialize decimal sum to zero
	add $s0, $s0, $t0
	addi $s0, $s0, -1	
	li $s3, 3
	li $s2, 2
		li $s1, 1
	li $s5, 0

	convertString:
	lb $s4, 0($a0)
