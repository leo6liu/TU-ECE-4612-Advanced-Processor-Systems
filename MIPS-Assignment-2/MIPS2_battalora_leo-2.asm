#-------------------------------------------------------------------------------
#    ____
#  /     \              file: MIPS2_battalora_leo.asm
#  vvvvvvv  /|__/|    author: Leo Battalora
#     I   /O,O   |
#     I /_____   |      /|/|
#    J|/^ ^ ^ \  |    /00  |    _//|
#     |^ ^ ^ ^ |W|   |/^^\ |   /oo |
#      \m___m__|_|    \m_m_|   \mm_|
#
# description:
#   A program which checks the validity of user-inputted numerical expressions.
#   Syntax rules for expressions should follow MATLAB convention. The program 
#   displays the prompt ">>>" for entering an expression of up to 64 symbols. 
#   Expressions should include only "()0123456789+-*/ ". If there is an error in
#   an expression, "Invalid input" will be written to the I/O window; if there 
#   is no error, "Valid input" will be written instead. The program will loop so
#   that users can enter new expressions without re-running the program.
#
#-------------------------------------------------------------------------------

# define constants
.eqv READ_LEN 65 		# read_string reads n-1 characters
.eqv SYS_PRINT_INT 1
.eqv SYS_PRINT_STRING 4
.eqv SYS_READ_STRING 8
.eqv SYS_EXIT 10

# initialize memory with data
.data
prompt: .asciiz ">>> "			# expression input prompt
valid: .asciiz "Valid input\n"		# valid expression response
invalid: .asciiz "Invalid input\n"	# invalid expression response
input_buffer: .space READ_LEN		# reserve data segment of 64 bytes + null to store user input

# program instructions
.text

# function: main
#
main:	
	# display prompt
	la $a0, prompt			# load address of input string for syscall
	li $v0, SYS_PRINT_STRING	# load system call code
	syscall
	
	# read input string
	la $a0, input_buffer		# load address of input buffer for syscall
	li $a1, READ_LEN		# length of string buffer
	li $v0, SYS_READ_STRING		# load system call code
	syscall
	
	# remove newline from input string
	la $a0, input_buffer
	jal remove_newline
	
	# if input is empty, it is valid
	beq $v0, $zero, print_valid	# $v0 has strlen after remove_newline()
	
	# if there are any disallowed symbols, it is invalid
	la $a0, input_buffer
	jal check_symbols
	bne $v0, $zero, print_invalid # $v0 is 0 after check_symbols() found no disallowed symbols
	
	# if there are any space separated numbers, it is invalid
	la $a0, input_buffer
	jal check_ssn
	bne $v0, $zero, print_invalid	# $v0 is 0 after check_ssn() found no SSNs
	
	# remove spaces from input string
	la $a0, input_buffer
	jal remove_spaces
	
	# if there are unbalanced parentheses, it is invalid
	la $a0, input_buffer
	jal check_parentheses
	bne $v0, $zero, print_invalid	# $v0 is 0 after check_parenthesis() found no unbalanced parentheses
	
	# check for remaining syntax rules
	la $a0, input_buffer
	jal check_syntax
	bne $v0, $zero, print_invalid	# $v0 is 0 after check_syntax() found no syntax errors
	
	# print Valid input then repeat REPL
	print_valid:
	la $a0, valid
	li $v0, SYS_PRINT_STRING	# load system call code
	syscall
	b main
	
	# print Invalid input then repeat REPL
	print_invalid:
	la $a0, invalid
	li $v0, SYS_PRINT_STRING	# load system call code
	syscall
	b main
	
	# exit (should never reach)
	li $v0, SYS_EXIT	# load syscall code for exit
	syscall			# exit normally
	
# function: remove_newline
# args: 
#   $a0 - char *str
# return:
#   $v0 - int strlen
#
remove_newline:
	# loop until newline or null terminator is found
	li $v0, 0				# int $v0 = 0 // strlen
	remove_newline_loop:
	lb $t1, ($a0)				# char $t1 = str[i] // current char
	beq $t1, 10, remove_newline_found	# branch if str[i] != '\n'
	beq $t1, $zero, remove_newline_return	# branch if str[i] == '\0'
	addi $a0, $a0, 1			# i++
	addi $v0, $v0, 1			# strlen++
	b remove_newline_loop
	
	# replace newline with null terminator
	remove_newline_found:
	sb $zero, ($a0)				# str[i] = '\0' // replace newline with null
	
	# return to function call
	remove_newline_return:
	jr $ra
	
# function: check_symbols
# args: 
#   $a0 - char *str
# return:
#   $v0 - int status (0 = no disallowed symbols found, 1 = disallowed symbols found)
#
check_symbols:
	# loop until disallowed symbol or null terminator is found
	check_symbols_loop0:
	lb $t0, 0($a0)		# char $t0 = str[i] // current char
	addi $a0, $a0, 1	# i++
	
	# if (*str != '\0') { return 0; }
	beq $t0, $zero, check_symbols_not_found
	
	# if (*str == one from "0123456789+-*/() ") loop again
	beq $t0, 43, check_symbols_loop0	# '+'
	beq $t0, 45, check_symbols_loop0	# '-'
	beq $t0, 42, check_symbols_loop0	# '*'
	beq $t0, 47, check_symbols_loop0	# '/'
	beq $t0, 40, check_symbols_loop0	# '('
	beq $t0, 41, check_symbols_loop0	# ')'
	beq $t0, 32, check_symbols_loop0	# ' '
	blt $t0, 48, check_symbols_found # less than '0'
	bgt $t0, 57, check_symbols_found # greater than '9'
	b check_symbols_loop0
	
	# return 0; // (no disallowed symbols found)
	check_symbols_not_found:
	li $v0, 0	# status = 0
	jr $ra
	
	# return 1; // (disallowed symbols found)
	check_symbols_found:
	li $v0, 1	# status = 1
	jr $ra

# function: check_ssn
# NOTE: SSN == space separated number
# args: 
#   $a0 - char *str
# return:
#   $v0 - int status (0 = no SSNs found, 1 = SSN found)
#
check_ssn:
	# loop until SSN or null terminator is found
	check_ssn_loop0:
	lb $t0, 0($a0)		# char $t0 = str[i] // current char
	lb $t1, 1($a0)		# char $t1 = str[i+1] // next char
	addi $a0, $a0, 1	# i++
	
	# if (*str != '\0') { return 0; }
	beq $t0, $zero, check_ssn_not_found
	
	# if (*str >= '0' && *str <= '9' && *(str+1) == ' ') continue
	blt $t0, 48, check_ssn_loop0
	bgt $t0, 57, check_ssn_loop0
	bne $t1, 32, check_ssn_loop0
	
	# loop until next non-space char found
	check_ssn_loop1:
	lb $t0, 0($a0)		# char $t0 = str[i] // current char
	addi $a0, $a0, 1	# i++
	beq $t0, 32, check_ssn_loop1
	
	# if (*str >= '0' && *str <= '9') { return 1; }
	blt $t0, 48, check_ssn_loop0
	bgt $t0, 57, check_ssn_loop0
	b check_ssn_found
	
	# return 0; // (no SSNs found)
	check_ssn_not_found:
	li $v0, 0	# status = 0
	jr $ra
	
	# return 1; // (SSN found)
	check_ssn_found:
	li $v0, 1	# status = 1
	jr $ra

# function: remove_spaces
# args: 
#   $a0 - char *str
#
remove_spaces:
	# start scan and result heads at the beginning of str
	move $t0, $a0	# char *scan = str;
	
	# loop over each character
	remove_spaces_loop0:
	lb $t1, 0($t0)	# char $t1 = *scan;
	beq $t1, $zero, remove_spaces_return
	
	# skip scanner pointer over spaces
	remove_spaces_loop1:
	bne $t1, 32, remove_spaces_copy		# while (*scan == ' ')
	addi $t0, $t0, 1			# scan++;
	lb $t1, 0($t0)				# $t1 = *scan;
	b remove_spaces_loop1
	
	# copy each char from the scanner head
	remove_spaces_copy:
	sb $t1, 0($a0)		# *str = *scan;
	
	# adavance scanner and result heads
	addi $t0, $t0, 1	# scan++;
	addi $a0, $a0, 1	# str++;
	b remove_spaces_loop0
	
	# return to function call
	remove_spaces_return:
	sb $zero, 0($a0)	# *str = '\0'; // null-terminate result
	jr $ra
	
# function: check_parenthesis
# args: 
#   $a0 - char *str
# return:
#   $v0 - int status (0 = no unbalanced parentheses found, 1 = unbalanced parentheses found)
#
check_parentheses:
	li $t0, 0	# int count = 0;
	
	# loop over each character
	check_parentheses_loop0:
	lb $t1, 0($a0)	# char $t1 = *str;
	beq $t1, $zero, check_parentheses_return
	
	beq $t1, 40, check_parentheses_open	# branch if '(' found
	beq $t1, 41, check_parentheses_close	# branch if ')' found
	addi $a0, $a0, 1			# str++;
	b check_parentheses_loop0
	
	# increment count on open parenthesis
	check_parentheses_open:
	addi $t0, $t0, 1	# count++;
	addi $a0, $a0, 1	# str++;
	b check_parentheses_loop0
	
	# decrement count on close parenthesis, also check if count goes negative
	check_parentheses_close:
	subi $t0, $t0, 1				# count--;
	blt $t0, $zero, check_parentheses_found	# if a closing if found before opening, there is an unbalanced parenthesis
	addi $a0, $a0, 1				# str++;
	b check_parentheses_loop0
	
	# after scanning entire string, check if parenthesis were balanced
	check_parentheses_return:
	bne $t0, $zero, check_parentheses_found	# branch if count != 0
	
	# return 0; // (no unbalanced parentheses found)
	check_parentheses_not_found:
	li $v0, 0	# status = 0
	jr $ra
	
	# return 1; // (unbalanced parentheses found)
	check_parentheses_found:
	li $v0, 1	# status = 1
	jr $ra
	
# function: check_syntax
# args: 
#   $a0 - char *str
# return:
#   $v0 - int status (0 = no syntax errors, 1 = syntax error encountered)
#
check_syntax:
	# evaluate first character
	lb $t0, 0($a0)	# load str[i]
	lb $t1, 1($a0)	# load str[i+1]
	beq $t0, 42, check_syntax_error	# cannot begin with '*'
	beq $t0, 47, check_syntax_error	# cannot begin with '/'
	beq $t0, $zero, check_syntax_noerror # when null-terminator encountered there are no synax errors
	beq $t0, 43, check_syntax_pmo	# '+'
	beq $t0, 45, check_syntax_pmo	# '-'
	beq $t0, 40, check_syntax_pmo	# '('
	beq $t0, 41, check_syntax_c		# ')'
	b check_syntax_num				# "0123456789"
	
	# loop over remaining chars in str
	check_syntax_loop0:
	addi $a0, $a0, 1		# str++;
	lb $t0, 0($a0)	# load str[i]
	lb $t1, 1($a0)	# load str[i+1]
	beq $t0, $zero, check_syntax_noerror # when null-terminator encountered there are no synax errors
	beq $t0, 43, check_syntax_pmo	# '+'
	beq $t0, 45, check_syntax_pmo	# '-'
	beq $t0, 42, check_syntax_td		# '*'
	beq $t0, 47, check_syntax_td		# '/'
	beq $t0, 40, check_syntax_pmo	# '('
	beq $t0, 41, check_syntax_c		# ')'
	b check_syntax_num				# "0123456789"
	
	# plus, minus, open parenthesis
	# if str[i] == "+-(" then must be followed by "+-0123456789(" but not "*/)\0"
	check_syntax_pmo:
	beq $t1, 43, check_syntax_loop0	# '+'
	beq $t1, 45, check_syntax_loop0	# '-'
	beq $t1, 48, check_syntax_loop0	# '0'
	beq $t1, 49, check_syntax_loop0	# '1'
	beq $t1, 50, check_syntax_loop0	# '2'
	beq $t1, 51, check_syntax_loop0	# '3'
	beq $t1, 52, check_syntax_loop0	# '4'
	beq $t1, 53, check_syntax_loop0	# '5'
	beq $t1, 54, check_syntax_loop0	# '6'
	beq $t1, 55, check_syntax_loop0	# '7'
	beq $t1, 56, check_syntax_loop0	# '8'
	beq $t1, 57, check_syntax_loop0	# '9'
	beq $t1, 40, check_syntax_loop0	# '('
	b check_syntax_error		# if none of the allowed chars were found, return error
	
	# times divide
	# if str[i] == "*/" then must be followed by "01234567890(" but not "+-*/)\0"
	check_syntax_td:
	beq $t1, 48, check_syntax_loop0	# '0'
	beq $t1, 49, check_syntax_loop0	# '1'
	beq $t1, 50, check_syntax_loop0	# '2'
	beq $t1, 51, check_syntax_loop0	# '3'
	beq $t1, 52, check_syntax_loop0	# '4'
	beq $t1, 53, check_syntax_loop0	# '5'
	beq $t1, 54, check_syntax_loop0	# '6'
	beq $t1, 55, check_syntax_loop0	# '7'
	beq $t1, 56, check_syntax_loop0	# '8'
	beq $t1, 57, check_syntax_loop0	# '9'
	beq $t1, 40, check_syntax_loop0	# '('
	b check_syntax_error		# if none of the allowed chars were found, return error
	
	# close parenthesis
	# if str[i] == ")" then can be followed by "+-*/)\0" but not "0123456789("
	check_syntax_c:
	beq $t1, 48, check_syntax_error	# '0'
	beq $t1, 49, check_syntax_error	# '1'
	beq $t1, 50, check_syntax_error	# '2'
	beq $t1, 51, check_syntax_error	# '3'
	beq $t1, 52, check_syntax_error	# '4'
	beq $t1, 53, check_syntax_error	# '5'
	beq $t1, 54, check_syntax_error	# '6'
	beq $t1, 55, check_syntax_error	# '7'
	beq $t1, 56, check_syntax_error	# '8'
	beq $t1, 57, check_syntax_error	# '9'
	beq $t1, 40, check_syntax_error	# '('
	b check_syntax_loop0
	
	# numerals
	# if str[i] == "0123456789" then can only be followed by "+-*/0123456789)\0" but not "("
	check_syntax_num:
	beq $t1, 40, check_syntax_error	# '('
	b check_syntax_loop0
	
	# return 0: no syntax errors
	check_syntax_noerror:
	li $v0, 0
	jr $ra
	
	# return 1: syntax error found
	check_syntax_error:
	li $v0, 1
	jr $ra
	
#
# end of file: MIPS2_battalora_leo.asm
