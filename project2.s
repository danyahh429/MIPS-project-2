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
