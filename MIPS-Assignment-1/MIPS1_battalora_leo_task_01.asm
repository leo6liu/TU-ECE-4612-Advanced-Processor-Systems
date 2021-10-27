#-------------------------------------------------------------------------------
#
# file: task_01.asm
# author: Leo Battalora
#
# Task 1: Copy a string of characters
#   Write MIPS code to copy the content of array Y which contains your full
#   name, to array X.
#
#-------------------------------------------------------------------------------

# initialize memory with data
.data 
array_y: .asciiz "Leo Battalora"	# stores string at 'array_y'
array_x: .space 256			# reserves a data segment of 256 bytes at 'array_x'

# program instructions
.text

# function: main
#
main:
	# copy string at array_y to array_x
	la $a0, array_y		# load addr of 'array_y' to $a0
	la $a1, array_x		# load addr of 'array_x' to $a1
	jal strcpy		# execute strcpy from array_y to array_x
	
	# exit
	li $v0, 10		# system call code for exit = 10
	syscall			# exit normally
	
# function: strcpy
# args: 
#   $a0 - address of first character of source string
#   $a1 - address for first character of destination string
#
strcpy:
	move $t0, $a0		# copy source string pointer to $t0
	move $t1, $a1		# copy destination string pointer to $t1
	
	copy_char:
	lbu $t2, ($t0)		# load character at source string pointer to $t2
	sb $t2, ($t1)		# store character from $t2 to destination string pointer
	
	addiu $t0, $t0, 1	# increment source string pointer
	addiu $t1, $t1, 1	# increment destination string pointer
	
	bne $t2, $zero, copy_char	# if null terminator is not yet reached, copy next char
	
	jr $ra			# return to function call

#
# end of file (task_01.asm)
