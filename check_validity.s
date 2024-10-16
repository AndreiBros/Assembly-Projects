.text
valid: .asciz  "valid"
invalid: .asciz "invalid"
output: .asciz "%s"
output2: .asciz "%ld"

.include "basic.s"

.global main

# *******************************************************************************************
# Subroutine: check_validity                                                                *
# Description: checks the validity of a string of parentheses as defined in Assignment 6.   *
# Parameters:                                                                               *
#   first: the string that should be check_validity                                         *
#   return: the result of the check, either "valid" or "invalid"                            *
# *******************************************************************************************
check_validity:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base poin ter


	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rbx
	pushq %rdi
	
	movq %rsp, %r15 #contains the initial place of rsp pointer
	

	
	movq %rdi, %rbx #contains the current address
	movq $1, %r14 # contains the valid variable

	for_loop:
		
		movq $0, %r12
		movb (%rbx), %r12b	#contains the last symbol
		cmpb $0, %r12b # check if the file is finished
		je for_loop_finish
		
			
			cmpb $40, %r12b # check for (
			je if_open_round_bracket
			jmp else_open_round_bracket

			if_open_round_bracket:

			pushq %r12  # push ( twice to keep the stack alligned
			pushq %r12
			jmp endopenround


			else_open_round_bracket:

				cmpb $41, %r12b # check for )
				je if_closed_round_bracket
				jmp else_closed_round_braket
				
				if_closed_round_bracket:
					 

					cmpq $1, %r14 # if the valid variable is not 1 anymore, jump to the loop finish
					je if_round_valid
					jmp for_loop_finish

					if_round_valid:

						cmpq %rsp, %r15 # check if the stack contains parantheses
						jg ok_round #pop the pair of the parantheses from the stack
						mov $0, %r14 #if the current rsp is equal to the rsp from the beginning terminate the loop 
						jmp for_loop_finish
						
						ok_round:
						
							popq %r13 
							popq %r13 

						
	
							cmpq $40, %r13 #look for (
							jne counter_round
							jmp endclosedround
						
							counter_round:
								mov $0, %r14
					
								jmp for_loop_finish

				else_closed_round_braket:

					cmpb $91, %r12b # check for [
					je if_open_square_bracket
					jmp else_open_square_bracket

					if_open_square_bracket:

						pushq %r12
						pushq %r12

						jmp endopensquare


					else_open_square_bracket:
						
						cmp $93, %r12b #look for ]
						
						je if_closed_square_bracket	
						jmp else_closed_square_braket
						
						if_closed_square_bracket:

									
							cmpq $1, %r14
							je if_square_valid
							jmp for_loop_finish

							if_square_valid:

								cmpq %rsp, %r15 # check if the stack contains parantheses
								jg ok_square
								mov $0, %r14
								jmp for_loop_finish
								
								ok_square:
									popq %r13
									popq %r13
									
									
    
									
									
									cmpq $91, %r13
									jne counter_square
									jmp endclosedsquare

									counter_square:
										mov $0, %r14
										jmp for_loop_finish

				    	else_closed_square_braket:

							cmpb $123, %r12b #check for {
							je if_open_accolade
							jmp else_open_accolade

							if_open_accolade:

								pushq %r12
								pushq %r12

								jmp endopenaccolade


							else_open_accolade:

								cmpb $125, %r12b # check for  }
								je if_closed_accolade
								jmp else_closed_accolade
								
								if_closed_accolade:

									cmpq $1, %r14
									je if_accolade_valid
									jmp for_loop_finish

									if_accolade_valid:

										cmpq %rsp, %r15 # check if the stack contains parantheses
										jg ok_accolade
										mov $0, %r14
										jmp for_loop_finish
										
										ok_accolade:
											popq %r13
											popq %r13
											 
											cmpq $123, %r13 # # check if the last one from the stack is {
											jne counter_accolade
											jmp endclosedaccolade
											
											counter_accolade:
												mov $0, %r14
												jmp for_loop_finish
								else_closed_accolade:

									cmpb $60, %r12b #check for <
									je if_open_other_bracket
									jmp else_open_other_bracket

									if_open_other_bracket:

										pushq %r12
										pushq %r12

										jmp endopenother


									else_open_other_bracket:

										cmpb $62, %r12b #check for >
										je if_closed_other_bracket
										jmp endclosedother
										
										if_closed_other_bracket:
											
											cmpq $1, %r14
											je if_other_valid
											jmp for_loop_finish

											if_other_valid:

												cmpq %rsp, %r15  # check if the stack contains parantheses
												jg ok_other
												mov $0, %r14
												jmp for_loop_finish
												
												ok_other:
													popq %r13
													popq %r13
									
													cmpq $60, %r13 # check if the last one from the stack is <
													jne counter_other
													jmp endclosedother
												
													counter_other:
					
														mov $0, %r14
														jmp for_loop_finish
										
									endclosedother:
								endopenother:
							endclosedaccolade:
						endopenaccolade:
					endclosedsquare:
				endopensquare:
			endclosedround:
		endopenround:
		
	
	
	
		
			
		inc %rbx #increment the pointer to the address		
		jmp for_loop
		

	 
	

	for_loop_finish:
	

	cmp %r15, %rsp # check if the stack is 
	jne if_stack
	jmp end_stack

  	if_stack:
	mov $0, %r14 
	movq %r15, %rsp # realign the stack
	jmp end_stack

	end_stack:
	
	
	cmp $1, %r14
	je final_if
	jmp else_code

	final_if:
		movq $valid, %rax
		jmp end
	

	else_code:
	    movq $invalid, %rax
		

end:
		

	popq %rdi
	popq %rbx
	popq %r15
	popq %r14
	popq %r13
	popq %r12

	

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi		# first parameter: address of the message
	call	check_validity		# call check_validity

	
	mov $output, %rdi
	mov %rax, %rsi
	mov $0, %rax
	call printf	
 
	
		
	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program

