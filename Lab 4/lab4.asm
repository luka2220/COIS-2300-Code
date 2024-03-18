.data
### Declare myArray, an array of length 20 and initialize with 0. ###
array: .word 0:20

### Declare appropriate strings and the space character for I/O prompts ###
intAmountPrompt: .asciiz "How many integers? (Maximum 20) "
numbersListPrompt: .asciiz "Enter the integers: "
sortedResultPrompt: .asciiz "Here is the sorted list: "
space: .asciiz " "

.text
main:
    ### call the procedure for reading the array ###
    jal read_array
    ### Save the size of the array as returned in v0 from the read_array procedure to s0 ###
    move $s0, $v0
    ### Assign appropriate values to a0 and a1 that will be the arguments for the sort procedure. ###
    move $a0, array
    move $a1, $s0
    ### Check the description of the sort procedure ###
    ### call the sort procedure ###
    jal sort
    ### move s0 to a1. a1 will be used by the print_array procedure ###
    move $a1, $s0
    ### call the print_array procedure ###
    jal print_array
    j exit

read_array:
    ### Read value of n and then read n integers to myArray. Use appropriate input prompts ###
    li $v0, 4
    la $a0, intAmountPrompt
    syscall

    ### you need to create a while loop ###
    ### Use t registers for counters and array indices ###
    li $t0, 0  # Counter for loop
    move $t1, array  # Address of myArray

    read_loop:
        ### the size of the array (n) will be saved to v0 before returning to main ###
        ### Read an integer from the user ###
        li $v0, 5
        syscall
        ### Store the integer in myArray[$t0] ###
        sw $v0, 0($t1)
        ### Increment the loop counter and array index ###
        addi $t0, $t0, 1
        addi $t1, $t1, 4
        ### Compare the counter with the size of the array ###
        blt $t0, $v0, read_loop
        ### Return with the size of the array in v0 ###
        move $v0, $t0
        jr $ra

sort:
        addi $sp,$sp,-20      # make room on stack for 5 registers
        sw $ra, 16($sp)        # save $ra on stack
        sw $s3,12($sp)         # save $s3 on stack
        sw $s2, 8($sp)         # save $s2 on stack
        sw $s1, 4($sp)         # save $s1 on stack
	      sw $s0, 0($sp)         # save $s0 on stack
        move $s2, $a0           # save $a0 into $s2
        move $s3, $a1           # save $a1 into $s3
        move $s0, $zero         # i = 0

print_array:
    ### print the sorted array, myArray. The size of the array will be in a1. Use appropriate output text. ###
    ### you need to create a while loop ###
    ### Use t registers for counters and array indices ###
    li $t0, 0  # Counter for loop
    move $t1, array  # Address of myArray

    print_loop:
        ### Print an integer from myArray[$t0] ###
        lw $a0, 0($t1)
        li $v0, 1
        syscall
        ### Print a space character ###
        li $v0, 4
        la $a0, space
        syscall
        ### Increment the loop counter and array index ###
        addi $t0, $t0, 1
        addi $t1, $t1, 4
        ### Compare the counter with the size of the array ###
        blt $t0, $a1, print_loop
        ### Print a newline character ###
        li $v0, 4
        la $a0, space
        syscall
        jr $ra

exit:
    li $v0, 10
    syscall
