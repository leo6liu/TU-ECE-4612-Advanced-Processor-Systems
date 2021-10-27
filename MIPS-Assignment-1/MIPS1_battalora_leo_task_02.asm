#-------------------------------------------------------------------------------
#
# file: task_02.asm
# author: Leo Battalora
#
# Task 2: Find factorial of a number
#   - Display in the I/O window the prompt "Enter a number to find factorial: "
#   - Take a number from the I/O window
#   - Calculate the factorial of the number
#   - Display the result to the I/O window
#
#-------------------------------------------------------------------------------

# initialize memory with data
.data 
prompt: .asciiz "Enter a number to find factorial: "
result: .asciiz "Result: "

# program instructions
.text

# function: main
#
main:
	# display prompt
	la $a0, prompt		# load address of prompt string for syscall
	li $v0, 4		# system call code for print_string = 4
	syscall
	
	# read integer
	li $v0, 5		# system call code for read_int = 5
	syscall
	move $a0, $v0		# copy read int to $a0
	
	# calculate factorial
	jal factorial
	move $t0, $v0		# save factorial result to $t0
	
	# display result
	la $a0, result		# load address of result string for syscall
	li $v0, 4		# system call code for print_string = 4
	syscall
	move $a0, $t0		# load factorial result
	li $v0, 1		# system call code for print_int = 1
	syscall
	
	# exit
	li $v0, 10		# system call code for exit = 10
	syscall			# exit normally
	
# function: factorial
# args: 
#   $a0 - (int) integer to calculate factorial of
# return:
#   $v0 - (int) integer factorial
#
factorial:
	li $t0, 1		# initialize result to 1
	li $t1, 1		# initialize sentinal to 1
	
	factorial_loop:
	mul $t0, $t0, $t1	# calculate next factorial
	addiu $t1, $t1, 1	# increment sentinal
	ble $t1, $a0, factorial_loop	# repeat while sentinal is less or equal to input
	
	move $v0, $t0		# store result in function result register
	
	jr $ra			# return to function call
	
#
# end of file (task_02.asm)
