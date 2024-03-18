.data
input_f_prompt: .asciiz    "\nEnter the temperature (Fahrenheit): "
convert_another_prompt: .asciiz "\n\nDo you want to convert another? (y to continue): "
temp_in_celsius: .asciiz  "\nThe temperature in Celsius: "
buffer: .space 100      # Buffer to store input string
const5: .float 5.0
const9: .float 9.0
const32: .float 32.0

.text
main:
	j input_loop

input_loop:
    # Print input prompt
    li $v0, 4            # Print string syscall
    la $a0, input_f_prompt  # Load address of input prompt
    syscall

    # Read the temperature as a string
    li $v0, 6            # Read float syscall
    syscall              # Read the floating-point number
    mov.s $f12, $f0             # Convert string to floating point in $f0

    # Call the Fahrenheit to Celsius conversion subroutine
    jal f2c

    # Print the result
    li $v0, 4            # Print string syscall
    la $a0, temp_in_celsius
    syscall
    li $v0, 2            # Print float syscall
    mov.s $f12, $f0      # Load the result into $f12
    syscall

    # Prompt to continue or quit
    li $v0, 4            # Print string syscall
    la $a0, convert_another_prompt
    syscall

    # Read user's choice
    li $v0, 12           # Read character syscall
    syscall
    move $t0, $v0       # Load the character entered by the user

    # Check if user wants to continue (y) or quit (n)
    beq $t0, 121, input_loop  # Branch to input_loop if user enters 'y'
                              # ASCII value of 'y' is 121
    # Exit the program
    li $v0, 10           # Exit syscall
    syscall


f2c:
    lwc1 $f16, const5
    lwc1 $f18, const9
    div.s $f16, $f16, $f18
    lwc1 $f18, const32
    sub.s $f18, $f12, $f18
    mul.s $f0, $f16, $f18
    jr $ra
	