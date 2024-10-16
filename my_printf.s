# as -no-pie -g -o printf.o mprintf.s && ld --fatal-warnings --entry main -o mprintf printf.o
# ./printf
.data
format_string: .asciz "My name is %s. I think I'll get a %u for my exam. What does %r do? And %%? %s %d %s %d %u"
name: .asciz "Andrei"
name2: .asciz "Danut"
new_line: .asciz "\n"
minus: .asciz "-"
zero: .asciz "0"
buffer: .space 300
.text
output: .asciz "%c"
.global main


my_printf:
    #prologue
    pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer
    
    pushq %r12				# push callee-saved registers
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rbx
	
    #offset 56
    pushq %r9
    pushq %r8
    pushq %rcx
    pushq %rdx
    pushq %rsi

    

    movq $0, %r14 #counter for string length when printing a string
    movq $0, %r13 #keeps track of the address inside the buffer
    movq $0, %r12 #counter for registers and stack, keep track of parameters
    movq %rdi, %rbx # With rbx we parse through the format string
    for_loop:
        cmpb $0, (%rbx) # check if we have reached the end of the string
        je for_loop_finish


        cmpb $37, (%rbx) # see if there is a special case %
        je special_cases
        jmp print_regular

        special_cases:
           
            inc %rbx

            cmpb $37, (%rbx) # %
            je print_regular

            cmpb $100, (%rbx) # d
            je see_offset

            cmpb $115, (%rbx) # s
            je see_offset

            cmpb $117, (%rbx) # u
            je see_offset

                     
            #otherwise, normal character is printed
            dec %rbx
            jmp print_regular

            see_offset:

                cmpq $5, %r12
                jl print_without_offset
                jmp print_with_offset

                print_without_offset:
                    
                    mov $8, %rax
                    mul %r12

                    inc %r12 # keep track of the number of parameters
                    
                    mov $0, %rcx #clean rcx
                    mov %rsp, %rcx # save the address of rsp
                    add %rax, %rcx #  add the offset to the address where rsp is pointing
                    movq $0, %r14 
                    mov (%rcx), %r14 #mov the value of the parameter in r14

                    
                    jmp start_cases

                print_with_offset:
                    
                    mov $8, %rax
                    mul %r12  #number of registers that i have already visited

                    inc %r12 # keep track of the number of parameters
                    
                    mov $0, %rcx
                    mov %rsp, %rcx 
                    add %rax, %rcx
                    add $56, %rcx
                    movq $0, %r14
                    mov (%rcx), %r14
                    jmp start_cases

            start_cases:
                cmpb $100, (%rbx) # d
                je print_signed

                cmpb $115, (%rbx) # s
                je print_string

                cmpb $117, (%rbx) # u
                je print_unsigned




#print string
            
            print_string:

                    for_print_string:
                      
                        cmpb $0, (%r14) # check if the string-parameter is finished
                         je for_print_string_end

                         movq $1, %rax # sys_write
                         movq $1, %rdi # standard out
                         movq %r14, %rsi # address of character
                         movq $1, %rdx # one byte
                         syscall
                    
                         inc %r14

                            
                         jmp for_print_string

                    for_print_string_end:

                    
            jmp continue

#print unsigned
            print_unsigned:
              # we create the number from right to left using the remainders from the division with 10
              mov (%rcx), %rdi
              lea buffer + 250, %r13
              movb $0, (%r13) # move null to the end of the buffer so we can check where the number finishes
              movq $10, %r15
            
             cmpq $0, %rdi
             je print_zero_unsigned
             jmp end_print_zero_unsigned

             print_zero_unsigned:
                movq $1, %rax # sys_write
                movq $1, %rdi # standard out
                movq $zero, %rsi # address of character
                movq $1, %rdx # one byte
                syscall

                jmp continue
                        

             end_print_zero_unsigned:
              
              create_number:
                   
                    cmpq $0, %rdi
                    je end_create_number
                    movq $0, %rax
                    movq $0, %rdx

                    movq %rdi, %rax # move the number to rax, the divident
                    divq %r15  #divide by ten, the rest is the last digit of the number

                    addq $48, %rdx #convert the rest to string 
                    dec %r13 #move on the next position in the buffer (from right to left)
                    movb %dl, (%r13) #move the last byte of rdx to the buffer (the remainder converted to char)
                    
                    movq %rax, %rdi # move the quotient back to rdi

                    
                    jmp create_number

             end_create_number:

             print_number_loop:

                    cmpb $0, (%r13) #print the number from right to left
                    je end_print_number_loop

                    movq $1, %rax # sys_write
                    movq $1, %rdi # standard out
                    movq %r13, %rsi # address of character
                    movq $1, %rdx # one byte
                    syscall
                    
                    
                    
                    inc %r13

                    
                    jmp print_number_loop
            
             end_print_number_loop:


            jmp continue


#print signed 

            print_signed:

             mov (%rcx), %rdi
             movq $0, %r15 # put the number in r15
             movq %rdi, %r15

             cmpq $0, %rdi
             je print_zero_signed
             jmp end_print_zero_signed

             print_zero_signed:
                movq $1, %rax # sys_write
                movq $1, %rdi # standard out
                movq $zero, %rsi # address of character
                movq $1, %rdx # one byte
                syscall

                jmp continue
                        

             end_print_zero_signed:


                cmpq $0, %rdi
                jl print_minus #if the number is negative, print a minus and then construct the 
                jmp end_minus

            print_minus:

                movq $1, %rax # sys_write
                movq $1, %rdi # standard out
                movq $minus, %rsi # address of character
                movq $1, %rdx # one byte
                syscall

                movq $-1, %rax # convert the number to positive
                mul %r15

                movq %rax, %rdi 
            
                jmp end_minus

            end_minus:

           

             lea buffer + 250, %r13
             movb $0, (%r13)
             movq $10, %r15
              
              create_signed:
                   
                    cmpq $0, %rdi
                    je end_create_signed

                    movq $0, %rax 
                    movq $0, %rdx

                    movq %rdi, %rax  # move the number to rax, the divident
                    divq %r15 #divide by ten, the rest is the last digit of the number

                    addq $48, %rdx #convert the rest to string
                    dec %r13 #move on the next position in the buffer (from right to left)
                    movb %dl, (%r13) #move the last byte of rdx to the buffer (the remainder converted to char)
                    
                    movq %rax, %rdi  # move the quotient back to rdi


                    
                    jmp create_signed

             end_create_signed:

             print_signed_loop:
                    
                    cmpb $0, (%r13)
                    je end_print_signed_loop
                    movq $1, %rax # sys_write
                    movq $1, %rdi # standard out
                    movq %r13, %rsi # address of character
                    movq $1, %rdx # one byte
                    syscall
                    
                    
                    
                    inc %r13

                    
                    jmp print_signed_loop
            
             end_print_signed_loop:


            jmp continue


        print_regular:

            movq $1, %rax # sys_write
            movq $1, %rdi # standard out
            movq %rbx, %rsi # address of character
            movq $1, %rdx # one byte
            syscall

            jmp continue
       
    

    

    continue:

        inc %rbx
        jmp for_loop
    for_loop_finish:



    popq %rsi
    popq %rdx
    popq %rcx
    popq %r8
    popq %r9
    
	popq %rbx				 # pop callee-saved registers
	popq %r15
	popq %r14
	popq %r13
	popq %r12
    #epilogue
    movq %rbp, %rsp # clear local variables from stack
    popq %rbp # restore base pointer location
    ret

main:
    #prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer


    
  
    
    movq $format_string ,%rdi
    movq $name, %rsi
    movq $10, %rdx
    movq $name, %rcx
    movq $256, %r8
    movq $name2, %r9
   
    
    push $29
    push $-21
	call	my_printf			# call decode	
 

	
	

    #epilogue
    movq %rbp, %rsp # clear local variables from stack
    popq %rbp # restore base pointer location
    
    movq $60, %rax
    movq $0, %rdi		# exit the program
    syscall
