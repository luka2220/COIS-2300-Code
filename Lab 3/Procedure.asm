#This is a MIPS program to print first n numbers fo the fibonacci sequence. n will be user input. 
#As the first two number of the sequence are given (0 and 1), n must be >=3
#Two restrictions: 
#$s0 must store the value of n in the main program. 
#$s0 must also be used as the register for storing the temporary/local result of the addition in the procedure

	.text
main:
	# Print input prompt
	li	$v0,4		# syscall code = 4 for printing a string
	la	$a0, in_prompt	# assign the prompt string to a0 for printing
	syscall
	# Read the value of n from user and save to t0
	li	$v0,5		# syscall code = 5 for reading an integer from user to v0
	syscall	

### Set s0 with the user input & if invalid (<=2) jumpt to exit_error ###
	move 	$s0, $v0		# move the input number into register $t0
	li 	$t0, 3			# load register $t1 with 3 to check user input
	blt	$s0, $t0, exit_error	# branch to exit_error if user input ($t0) is less than 3 ($t1)

### Set proper argument register and call the procedure print_numnber to show the first two numbers of the sequence (0 & 1)###

	li $t0, 2		# initialize counter register t0
	# Load the first number (0) into $a0
	li $a0, 0

	# Call the print_number procedure
	jal print_number

	# Load the second number (1) into $a0
	li $a0, 1

	# Call the print_number procedure again
	jal print_number
	
### Load the first two numbers (0 & 1) to s1 & s2 ###	
	li $s1, 0
	li $s2, 1

loop:	

### set the argument registers (a0 and a1) to the last two values in the sequence for addition, and then call proedure add_two###
	move	$a0, $s1	# $a0 now stores the last value in the sequence
	move	$a1, $s2	# $a1 now stores the second-to-last value in the sequence
	jal	add_two


	move $s1, $s2		# s1 now stores the last value in the sequence
	move $s2, $v0		# s2 now new value as returned from the addition procedure
	move $a0, $v0		# update a0 for printing the returned value
	jal print_number

### Increment the counter and compare it with user input. If equal, jumpt to exit.###
	bgt	$t0, $s0, exit
	addi    $t0, $t0, 1   # Increment $t0 by 1
	
	j loop			# Go to the start of the loop

add_two:

### Push the value of s0 in the stack ###	
	addi $sp, $sp, -4
	sw   $s3, 0($sp) 
	
	add $s3, $a0, $a1	# s0 now holds the result of the addition
	
### Set the register that will hold the reutrn value	with the result of the addition ###
	move $v0, $s3

### Pop the value of s0 from the stack ###
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# return to the caller
			# segement for printing an integer
print_number:	

### Write the syscall code for printing the integer ###
	li $v0, 1	# syscall code for printing an integer
	syscall

	# syscall for printing a space character
	li	$v0,4		
	la	$a0, space	
	syscall
	jr $ra 		#return to the caller
	
	# exit block for wrong value of the input 
exit_error:
	li	$v0, 4		# syscall code = 4 for printing the error message
	la	$a0, error_string
	syscall
	li	$v0,10		# syscall code = 10 for terminate the execution of the program
	syscall
	# exit block for the program 
exit:
	li	$v0,10		# syscall code = 10 for terminate the execution of the program
	syscall
	
	.data
in_prompt:	.asciiz	"how many numbers in the sequence you want to see (must be at least 3): "
error_string:	.asciiz "The number ust be greater than or equal to 3"
space:		.asciiz " "
