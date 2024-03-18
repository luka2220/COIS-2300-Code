.data
x_string:  .space 40
y_string:  .space 40
in_prompt: .asciiz "Input the y string (max 40 characters) and then press enter: "
length_message: .asciiz "The length of the string is: "
out_message: .asciiz "\nThis is the content of x string after copying: "

.text
main:
	### Print the input prompt###
	li $v0, 4
	la $a0, in_prompt
	syscall
    
	### Read y string from the user using syscall ###
	li $v0, 8
	la $a0, y_string
	li $a1, 40
	syscall
	

	### Calcualte length of y string.### 
	### Calculate length of y string ###
    	addi $s0, $zero, 0  # Initialize counter for string length to 0
    
    	calc_length:
        	lbu $t0, ($a0)         # Load byte from memory at address $a0
        	beq $t0, $zero, end_calc  # If null terminator is encountered, exit loop
        	addi $s0, $s0, 1       # Increment counter for string length
        	addi $a0, $a0, 1       # Move to the next character
        	j calc_length          # Repeat the loop
        	
        
   end_calc:

    ### Output the message for showing length ###
    li $v0, 4
    la $a0, length_message
    syscall
    
    ### Output the length of the string ###
    subi $s0, $s0, 1        # Exclude the null terminator from the length
    move $a0, $s0            # Move string length to $a0 for printing
    li $v0, 1
    syscall

    ### Call strcpy to copy y_string to x_string ###
    la $a0, x_string        # Load address of x_string
    la $a1, y_string        # Load address of y_string
    jal strcpy              # Jump and link to strcpy subroutine
    
    ### Output the message for showing the x string ###
    li $v0, 4
    la $a0, out_message
    syscall
    
    ### Output x string ###
    la $a0, x_string       # Load address of x_string
    li $v0, 4
    syscall
	
### You have use a loop. Count the total no of cahracters until you find 0 in the string that incdicates the null terminator###
### Note, you need to use lbu for loading a Byte. ###
### Also, to access the next character in memory, increment the Byte number by 1 unlike array of words where you incremented by 4###


### Output the message for showing length  ###

### Output the length of the string. Before printing, subtract 1 from the length as we do not want to count the newline character.###

### load the base addresses of the strings to a0 and a1 for the procedure call. a0 for x and a1 for y###  

         
### Output the message for showing the x string  ###
   
### Output x string###         

    
    j exit

#strcpy contains the code for copying y_string to x_string. 
#Base addresses of x_string and y_string are in $a0 and $a1 respectively    

strcpy:
    addi $sp, $sp, -4      # adjust stack for 1 item
    sw   $s0, 0($sp)       # save $s0
    add  $s0, $zero, $zero # i = 0
L1: add  $t1, $s0, $a1     # addr of y[i] in $t1
    lbu  $t2, 0($t1)       # $t2 = y[i]
    add  $t3, $s0, $a0     # addr of x[i] in $t3
    sb   $t2, 0($t3)       # x[i] = y[i]
    beq  $t2, $zero, L2    # exit loop if y[i] == 0  
    addi $s0, $s0, 1       # i = i + 1
    j    L1                # next iteration of loop
L2: lw   $s0, 0($sp)       # restore saved $s0
    addi $sp, $sp, 4       # pop 1 item from stack
    jr   $ra               

exit:
	li $v0, 10
	syscall