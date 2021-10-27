#-------------------------------------------------------------------------------
#
# file: task_03.asm
# author: Leo Battalora
#
# Task 3: Print a diamond shape to I/O window
#   - take an integer input (1 < n < 11) from I/O window 
#   - display in the I/O window a diamond using *. Each side of the diamond 
#     contain number of * specified by the input.
#
#-------------------------------------------------------------------------------

# initialize memory with data
.data
input: .asciiz "Input [1,11]: "
output: .asciiz "Output:\n"
star: .asciiz "*"
space: .asciiz " "
newline: .asciiz "\n"

# program instructions
.text

# function: main
#
main:
	# display prompt
	la $a0, input		# load address of input string for syscall
	li $v0, 4		# system call code for print_string = 4
	syscall
	
	# read side_len
	li $v0, 5		# system call code for read_int = 5
	syscall
	move $a0, $v0		# copy read int to $a0
	
	# print diamond
	jal print_diamond
	
	# exit
	li $v0, 10		# system call code for exit = 10
	syscall			# exit normally
	
# function: print_diamond
# args: 
#   $a0 - (int) side_len of diamond
#
print_diamond:
	# save return address to the stack
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	# set $v0 to print_string system call
	li $v0, 4		# system call code for print_string = 4
	
	# initialize row counter to 0
	li $a3, 0	
	
	top_loop:
	# calculate index of star_1 and store in $a1 = side_len - 1 - row
	addi $a1, $a0, -1
	sub $a1, $a1, $a3
	
	# calculate index of star_2 and store in $a2 = side_len - 1 + row
	addi $a2, $a0, -1
	add $a2, $a2, $a3
	
	# print line
	jal print_line
	
	# continue top_loop until row >= side_len
	addiu $a3, $a3, 1	# increment row counter
	blt $a3, $a0, top_loop	# loop again if row < side_len
	
	# initialize row counter to side_len - 2
	addi $a3, $a0, -2
	
	bottom_loop:
	# calculate index of star_1 and store in $a1 = side_len - 1 - row
	addi $a1, $a0, -1
	sub $a1, $a1, $a3
	
	# calculate index of star_2 and store in $a2 = side_len - 1 + row
	addi $a2, $a0, -1
	add $a2, $a2, $a3
	
	# print line
	jal print_line
	
	# continue bottom_loop until row < 0
	addiu $a3, $a3, -1	# decrement row counter
	bge $a3, $zero, bottom_loop	# loop again if row >= 0
	
	# retrieve return address from the stack
	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	# return to function call
	jr $ra
	
# function: print_line
# args: 
#   $a0 - (int) side_len of diamond
#   $a1 - (int) star_1 index
#   $a2 - (int) star_2 index
#   $a3 - (int) row counter
#
print_line:
	# save side_len ($a0) to the stack
	addi $sp, $sp, -4
	sw $a0, ($sp)

	# initialize line index ($t0) to 0
	li $t0, 0
	
	loop:
	# if index == star_1 index, skip to print_star
	beq $t0, $a1, print_star
	
	# if index != star_2 index, skip to print_space
	bne $t0, $a2, print_space

	print_star:
	la $a0, star		# load address of star string for syscall
	syscall			# execute print
	j loop_check		# skip print_space
	
	print_space:
	la $a0, space		# load address of space string for syscall
	syscall			# execute print
	
	loop_check:
	# loop again if index <= star_2 index
	addiu $t0, $t0, 1	# increment line index
	ble $t0, $a2, loop
	
	# print new line
	la $a0, newline		# load address of input string for syscall
	syscall			# execute print
	
	# retrieve side_len ($a0) from the stack
	lw $a0, ($sp)
	addi $sp, $sp, 4

	# return to function call
	jr $ra

#
# end of file (task_03.asm)
