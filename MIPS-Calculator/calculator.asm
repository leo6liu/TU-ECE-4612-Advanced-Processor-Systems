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
.eqv VALUES_SIZE 123	# 4 bytes per float-32 * 64
.eqv OPERATORS_SIZE 65	# 1 byte per char * 64 + 1 for null terminator
.eqv SYS_PRINT_INT 1
.eqv SYS_PRINT_FLOAT 2
.eqv SYS_PRINT_STRING 4
.eqv SYS_READ_STRING 8
.eqv SYS_EXIT 10
.eqv PLUS 43	# ASCII value of '+'
.eqv MINUS 45	# ASCII value of '-'
.eqv TIMES 42	# ASCII value of '*'
.eqv DIVIDE 47	# ASCII value of '/'

# initialize memory with data
.data
prompt: .asciiz ">>> "				# expression input prompt
valid: .asciiz "Valid input\n"		# valid expression response
invalid: .asciiz "Invalid input\n"	# invalid expression response
input_buffer: .space 67				# reserve data segment of 64 bytes + null to store user input
values: .space VALUES_SIZE
operators: .space OPERATORS_SIZE
fp_positive: .float +1.0
fp_negative: .float -1.0
nl: .asciiz "\n"

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
	
	# if input is empty, it is valid but no evaluation is needed
	beq $v0, $zero, print_valid_no_eval	# $v0 has strlen after remove_newline()
	
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
	# evaluate expression
	la $a0, input_buffer
	jal eval
	# print result
	mtc1 $v0, $f12
	li $v0, SYS_PRINT_FLOAT
	syscall
	la $a0, nl
	li $v0, SYS_PRINT_STRING
	syscall
	b main
	
	# print Valid input with no expression evaluation then repeat REPL
	print_valid_no_eval:
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
	blt $t0, 48, check_symbols_found	# less than '0'
	bgt $t0, 57, check_symbols_found	# greater than '9'
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
	beq $t0, 42, check_syntax_error		# cannot begin with '*'
	beq $t0, 47, check_syntax_error		# cannot begin with '/'
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
	beq $t0, 42, check_syntax_td	# '*'
	beq $t0, 47, check_syntax_td	# '/'
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

# function: eval
#
# temporary registers:
#   $t0 - char *str (variable)
#   $t1 - char str[i]
#   $t2 - char str[i+1]
#   $t3 - int str index
#   $t4 - int current value start index
#   $t5 - int current value end index
#   $t6 - char *str (original)
#
#   $s0 - float *values (variable)
#   $s1 - float values[i]
#   $s2 - int values index
#
#   $s3 - char *operands (variable)
#   $s4 - char operands[i]
#   $s5 - int operands index
#
# args: 
#   $a0 - char *str
# return:
#   $v0 - float result
#
eval:
	# save return address to the stack
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	# initialize str pointers
	move $t0, $a0  # $t0 - char *str (variable)
	move $t6, $a0  # $t6 - char *str (original)
	
	# initialize str indexes
	li $t3, 0	# $t3 - int str index
	move $t4, $t3	# $t4 - int current value start index
	move $t5, $t3	# $t5 - int current value end index
	
	# initialize values pointer and index
	la $s0, values	# $s0 - float *values (variable) &values[i+1]
	li $s2, 0	# $s2 - int values index + 1 (# values in stack)
	
	# initialize operators pointer and index
	la $s3, operators	# $s3 - char *operators (variable) &operators[i+1]
	li $s5, 0	# $s5 - int operators index + 1 (# operators in stack)
	
	# expects "+-0123456789("
	# loop over value in str
	eval_value:
	# read current and next char
	lb $t1, 0($t0)						# $t1 - char str[i]
	lb $t2, 1($t0)						# $t2 - char str[i+1]
	# if sign, check for open parenthesis
	beq $t1, 43, eval_check_next_open			# '+'
	beq $t1, 45, eval_check_next_open			# '-'
	# if numeral, check for operator or close parenthesis
	beq $t1, 48, eval_check_next_operator_or_close	# '0'
	beq $t1, 49, eval_check_next_operator_or_close	# '1'
	beq $t1, 50, eval_check_next_operator_or_close	# '2'
	beq $t1, 51, eval_check_next_operator_or_close	# '3'
	beq $t1, 52, eval_check_next_operator_or_close	# '4'
	beq $t1, 53, eval_check_next_operator_or_close	# '5'
	beq $t1, 54, eval_check_next_operator_or_close	# '6'
	beq $t1, 55, eval_check_next_operator_or_close	# '7'
	beq $t1, 56, eval_check_next_operator_or_close	# '8'
	beq $t1, 57, eval_check_next_operator_or_close	# '9'
	# if open parenthesis, save to operator stack
	beq $t1, 40, eval_read_open				# '('
	# if null terminator, calculate result (probably will never reach)
	beq $t1, $zero, eval_deplete_operators
	
	# move to next character of value
	eval_continue_reading_value:
	addi $t5, $t5, 1	# increment end index
	addi $t3, $t3, 1	# increment current index
	addi $t0, $t0, 1	# move to next char
	b eval_value		# continue looping over operand
	
	# when currently evaluating signs, check if next char is '('
	eval_check_next_open:
	bne $t2, 40, eval_continue_reading_value	# branch if str[i+1] != '('
	# if '(' follows "+-" then record signs as sign * () (e.g. -+--(4) becomes -1 * (4))
	move $a0, $t6		# load $a0 - char *str
	move $a1, $t4		# load $a1 - int value_index_start
	move $a2, $t5		# load $a2 - int value_index_end
	jal str_to_float	# execute str_to_float conversion
	move $s1, $v0		# store float at values[i]
	sw $s1, 0($s0)		# store float at values[i]
	addi $s0, $s0, 4	# increment values pointer
	addi $s2, $s2, 1	# increment values index
	li $s4, 42		# store '*' at operators[i]
	sb $s4, 0($s3)		# store '*' at operators[i]
	addi $s3, $s3, 1	# increment operators pointer
	addi $s5, $s5, 1	# increment operators index
	# move to next character
	addi $t3, $t3, 1	# increment current index
	addi $t0, $t0, 1	# move to next char
	b eval_read_open	# read open parenthesis
	
	# if currently evaluating numerals, check if next char is "+-*/)\0"
	eval_check_next_operator_or_close:
	beq $t2, 43, eval_check_next_operator_or_close_found	# '+'
	beq $t2, 45, eval_check_next_operator_or_close_found	# '-'
	beq $t2, 42, eval_check_next_operator_or_close_found	# '*'
	beq $t2, 47, eval_check_next_operator_or_close_found	# '/'
	beq $t2, 41, eval_check_next_operator_or_close_found	# ')'
	beq $t2, $zero, eval_check_next_operator_or_close_found	# '\0'
	b eval_continue_reading_value # next char is "0123456789"
	eval_check_next_operator_or_close_found:
	# read in current value and store to values stack
	move $a0, $t6		# load $a0 - char *str
	move $a1, $t4		# load $a1 - int value_index_start
	move $a2, $t5		# load $a2 - int value_index_end
	jal str_to_float	# execute str_to_float conversion
	move $s1, $v0		# store float at values[i]
	sw $s1, 0($s0)		# store float at values[i]
	addi $s0, $s0, 4	# increment values pointer
	addi $s2, $s2, 1	# increment values index
	# move to next character
	addi $t3, $t3, 1	# increment current index
	addi $t0, $t0, 1	# move to next char
	# check if close, null, or operator
	beq $t2, 41, eval_read_close	# special logic for ')'
	beq $t2, $zero, eval_deplete_operators # special logic for '\0' (all tokens are read)
	b eval_read_operator		# special logic for "+-*/"
	
	# process '(' by pushing it to operator stack
	# expects str[i] == '(' and registers $t0,$t3 to be set
	eval_read_open:
	# read current and next char
	lb $t1, 0($t0)		# $t1 - char str[i]
	lb $t2, 1($t0)		# $t2 - char str[i+1]
	# store open parenthesis in operators stack
	move $s4, $t1		# store '(' at operators[i]
	sb $s4, 0($s3)		# store '(' at operators[i]
	addi $s3, $s3, 1	# increment operators pointer
	addi $s5, $s5, 1	# increment operators index
	# move to next character
	addi $t3, $t3, 1	# increment current index
	addi $t0, $t0, 1	# move to next char
	# reset current value indexes
	move $t4, $t3		# $t4 - current value start
	move $t5, $t3		# $t5 - current value end
	# read next value
	b eval_value
	
	# calculate value between parenthesis until open parenthesis reached in operator stack
	eval_read_close:
	# read current and next char
	lb $t1, 0($t0)		# $t1 - char str[i]
	lb $t2, 1($t0)		# $t2 - char str[i+1]
	# check if '(' is at top of operator stack
	beq $s4, 40, eval_read_close_open_found
	# load operator and two operands for execution
	move $a1, $s1		# operand right
	subi $s0, $s0, 4	# decrement values pointer
	subi $s2, $s2, 1	# decrement values index
	lw $s1, -4($s0)		# load values[i]
	move $a0, $s1		# operand left
	subi $s0, $s0, 4	# decrement values pointer
	subi $s2, $s2, 1	# decrement values index
	lw $s1, -4($s0)		# load values[i]
	move $a2, $s4		# operator
	subi $s3, $s3, 1	# decrement operators pointer
	subi $s5, $s5, 1	# decrement operators pointer
	lb $s4, -1($s3)		# load operators[i]
	jal execute_operation
	move $s1, $v0		# store result at values[i]
	sw $s1, 0($s0)		# store result at values[i]
	addi $s0, $s0, 4	# increment values pointer
	addi $s2, $s2, 1	# increment values index
	b eval_read_close
	# pop the '(' off the operators stack
	eval_read_close_open_found:
	subi $s3, $s3, 1	# decrement operators pointer
	subi $s5, $s5, 1	# decrement operators pointer
	lb $s4, -1($s3)		# load operators[i]
	# move to next character
	addi $t3, $t3, 1	# increment current index
	addi $t0, $t0, 1	# move to next char
	# reset current value indexes
	move $t4, $t3		# $t4 - current value start
	move $t5, $t3		# $t5 - current value end
	# if end is not reached, assume an operator next
	beq $t2, $zero, eval_deplete_operators
	b eval_read_operator
	
	# process current operator and check operator precedence
	eval_read_operator:
	# read current and next char
	lb $t1, 0($t0)		# $t1 - char str[i]
	lb $t2, 1($t0)		# $t2 - char str[i+1]
	# check if operator on stack has same or greater precedence as current operator
	# if operator stack is empty, save operator and continue
	# if * or / is on stack, perform an operation
	# if + or - is on stack, only perform an operation of current operator is also + or -
	# else, since ( is on stack, save operator and continue
	beq $s2, 0, eval_read_operator_save
	beq $s4, TIMES, eval_read_operator_perform_operation
	beq $s4, DIVIDE, eval_read_operator_perform_operation
	beq $s4, PLUS, eval_read_operator_save
	beq $s4, MINUS, eval_read_operator_save
	b eval_read_operator_save
	# + or - is on stack, only perform an operation of current operator is also + or -
	# if + or - is current operator, perform operation
	# else since current operator is of higher precedence, save operator and continue
	eval_read_operator_check_current:
	beq $t1, PLUS, eval_read_operator_perform_operation
	beq $t1, MINUS, eval_read_operator_perform_operation
	b eval_read_operator_save
	# execute an operation using 2 operands from values stack and 1 operator from operators stack
	eval_read_operator_perform_operation:
	move $a1, $s1		# operand right
	subi $s0, $s0, 4	# decrement values pointer
	subi $s2, $s2, 1	# decrement values index
	lw $s1, -4($s0)		# load values[i]
	move $a0, $s1		# operand left
	subi $s0, $s0, 4	# decrement values pointer
	subi $s2, $s2, 1	# decrement values index
	lw $s1, -4($s0)		# load values[i]
	move $a2, $s4		# operator
	subi $s3, $s3, 1	# decrement operators pointer
	subi $s5, $s5, 1	# decrement operators pointer
	lb $s4, -1($s3)		# load operators[i]
	jal execute_operation
	move $s1, $v0		# store result at values[i]
	sw $s1, 0($s0)		# store result at values[i]
	addi $s0, $s0, 4	# increment values pointer
	addi $s2, $s2, 1	# increment values index
	b eval_read_operator
	# save current operator to stack
	eval_read_operator_save:
	move $s4, $t1		# store current operator at operators[i]
	sb $s4, 0($s3)		# store current operator at operators[i]
	addi $s3, $s3, 1	# increment operators pointer
	addi $s5, $s5, 1	# increment operators index
	# move to next character
	addi $t3, $t3, 1	# increment current index
	addi $t0, $t0, 1	# move to next char
	# reset current value indexes
	move $t4, $t3		# $t4 - current value start
	move $t5, $t3		# $t5 - current value end
	# read next value
	b eval_value
	
	# calculate result using remaining operators
	eval_deplete_operators:
	# if operator stack is empty, return result
	beq $s5, $zero, eval_result
	# else, execute an operation using 2 operands from values stack and 1 operator from operators stack
	move $a1, $s1		# operand right
	subi $s0, $s0, 4	# decrement values pointer
	subi $s2, $s2, 1	# decrement values index
	lw $s1, -4($s0)		# load values[i]
	move $a0, $s1		# operand left
	subi $s0, $s0, 4	# decrement values pointer
	subi $s2, $s2, 1	# decrement values index
	lw $s1, -4($s0)		# load values[i]
	move $a2, $s4		# operator
	subi $s3, $s3, 1	# decrement operators pointer
	subi $s5, $s5, 1	# decrement operators pointer
	lb $s4, -1($s3)		# load operators[i]
	jal execute_operation
	move $s1, $v0		# store result at values[i]
	sw $s1, 0($s0)		# store result at values[i]
	addi $s0, $s0, 4	# increment values pointer
	addi $s2, $s2, 1	# increment values index
	b eval_deplete_operators
	
	# load result from values stack
	eval_result:
	move $v0, $s1

	# retrieve return address from the stack
	lw $ra, ($sp)
	addi $sp, $sp, 4
	
	# return to function call
	jr $ra

# function: execute_operation
# $v0 = $a0 operator $a1
# args:
#   $a0 - float left operand
#   $a1 - float right operand
#   $a2 - char operator "+-*/"
# return:
#   $v0 - float result
execute_operation:
	# move operands to coprocessor 1
	mtc1 $a0, $f0		# move value in $a0 to coprocessor 1 $f0
	mtc1 $a1, $f1		# move value in $a1 to coprocessor 1 $f1
	
	# determine operation
	beq $a2, 43, execute_operation_add		# '+'
	beq $a2, 45, execute_operation_subtract	# '-'
	beq $a2, 42, execute_operation_multiply	# '*'
	beq $a2, 47, execute_operation_divide		# '/'
	
	# add
	execute_operation_add:
	add.s $f0, $f0, $f1
	b execute_operation_result
	
	# subtract
	execute_operation_subtract:
	sub.s $f0, $f0, $f1
	b execute_operation_result
	
	# multiply
	execute_operation_multiply:
	mul.s $f0, $f0, $f1
	b execute_operation_result
	
	# divide
	execute_operation_divide:
	div.s $f0, $f0, $f1
	b execute_operation_result
	
	# set return value
	execute_operation_result:
	mfc1 $v0, $f0		# move float from $f0 to $v0
	
	# return to function call
	jr $ra

# function: str_to_float
# args: 
#   $a0 - char *str
#   $a1 - int value_index_start
#   $a2 - int value_index_end (indicates exponent in *10^x)
# return:
#   $v0 - float result
#
str_to_float:
	# push $t0-$t3 to stack
	addi $sp, $sp, -4
	sw $t0, ($sp)
	addi $sp, $sp, -4
	sw $t1, ($sp)
	addi $sp, $sp, -4
	sw $t2, ($sp)
	addi $sp, $sp, -4
	sw $t3, ($sp)

	l.s $f0, fp_positive	# $f0 - float sign
	li $t0, 0		# $t0 - int value
	l.s $f2, fp_positive	# $f2 - float +1
	l.s $f3, fp_negative	# $f3 - float -1
	li $t3, 10		# $t3 - int 10
	
	# move str to first character of operand
	str_to_float_loop0:
	beq $a1, 0, str_to_float_loop1
	addi $a0, $a0, 1	# increment str pointer
	subi $a1, $a1, 1	# decrement value_index_start
	subi $a2, $a2, 1	# decrement value_index_end
	b str_to_float_loop0	# repeat until index reached

	# loop over sign operators
	str_to_float_loop1:
	blt $a2, $zero, str_to_float_no_numerals	# if end of number reached in this loop, there were no numberals
	lb $t1, 0($a0)					# $t1 - char str[i]
	beq $t1, 43, str_to_float_plus			# '+'
	beq $t1, 45, str_to_float_minus			# '-'
	b str_to_float_numeral				# if "+-\0" not found, assume a number

	# multiply sign by +1 when + encountered
	str_to_float_plus:
	mul.s $f0, $f0, $f2
	addi $a0, $a0, 1	# increment str pointer
	subi $a2, $a2, 1	# decrement value_index_end
	b str_to_float_loop0

	# multiply sign by -1 when - encountered
	str_to_float_minus:
	mul.s $f0, $f0, $f3
	addi $a0, $a0, 1	# increment str pointer
	subi $a2, $a2, 1	# decrement value_index_end
	b str_to_float_loop0

	# if no numberals were found, assume a value of 1 then calculate result
	str_to_float_no_numerals:
	li $t0, 1
	b str_to_float_result

	# once a numeral is found, stop checking for signs
	str_to_float_numeral:
	blt $a2, $zero, str_to_float_result	# once all numerals are processed, calculate result
	lb $t1, 0($a0)		# $t1 - char str[i]
	move $t2, $a2		# $t2 - int exponent
	subi $t1, $t1, 48	# convert ascii value to integer equiv by subtracting 48 ('0' == 48)
	# calculate value of current character
	str_to_float_numeral_loop0:
	beq $t2, 0, str_to_float_numeral_add
	mult $t1, $t3	# multiply value by 10
	mflo $t1	# only store lower byte (could cause problems)
	subi $t2, $t2, 1	# decrement exponent
	b str_to_float_numeral_loop0
	# add calculated value to current result
	str_to_float_numeral_add:
	add $t0, $t0, $t1
	addi $a0, $a0, 1	# increment str pointer
	subi $a2, $a2, 1	# decrement value_index_end
	b str_to_float_numeral	# process next char

	# convert to float then apply sign
	str_to_float_result:
	mtc1 $t0, $f1		# move value in $t0 to coprocessor 1 $f1
	cvt.s.w $f1, $f1	# convert word in $f1 to float
	mul.s $f1, $f1, $f0	# multiply value by sign and store in $f1
	mfc1 $v0, $f1		# move float from $f1 to $v0
	
	# pop $t0-$t3 to stack
	lw $t3, ($sp)
	addi $sp, $sp, 4
	lw $t2, ($sp)
	addi $sp, $sp, 4
	lw $t1, ($sp)
	addi $sp, $sp, 4
	lw $t0, ($sp)
	addi $sp, $sp, 4
	
	# return to function call
	jr $ra
#
# end of file: mips_calc.asm
