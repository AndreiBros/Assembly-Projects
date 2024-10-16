.data
    format_string: .asciz  "ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB"
    output_char: .asciz "%c"
    output_digit: .asciz "%d"
    valid: .asciz "valid"
    new_line: .asciz "\n"
    file: .asciz "file.bmp"
    leadTrail: .asciz "CCCCCCCCSSSSEE1111444400000000" # 30 characters
   

    image_buffer: .space 3126  # Reserve 3072 bytes (32 * 96) for the image + 54 bits for file header
    image_buffer2: .space 3126  # Reserve 3072 bytes (32 * 96) for the image + 54 bits for file header
    
.bss
    buffer: .skip 5000
    buffer2: .skip 5000
    buffer3: .skip 5000
    
.text
.global main
.global encrypt
.global decrypt

create_bar_code2:
# prologue
    pushq	%rbp 			# push the base pointer (and align the stack)
    movq	%rsp, %rbp		# copy stack pointer value to base pointer

    pushq %r12				# push callee-saved registers
	pushq %r13
	pushq %r14
	pushq %r15



    // 8*W 8*B 4*W  3*B 2*W  3*B 2*W 
    leaq image_buffer2, %r12
    # BM in ascii
    movb $'B', (%r12)
    inc %r12
    movb $'M', (%r12)
    inc %r12

    # reserve the file size
    movl  $3126, (%r12)
    add $4, %r12

    # reserve 4 bytes
     movl  $0, (%r12)
    add $4, %r12

    # reserve 4 bytes for the offset of the pixels inside
    movl  $54, (%r12)
    add $4, %r12

    # reserve 4 bytes for the header size
    movl  $40, (%r12)
    add $4, %r12


    # reserve 4 bytes for the width of the image
    movl  $32, (%r12)
    add $4, %r12

    # reserve 4 bytes for the height of the image
    movl  $32, (%r12)
    add $4, %r12


    # reserve 2 bytes, each one being 1
    movw $1, (%r12)
    add $2, %r12

    # reserve 2 bytes, for pixel size - 24 bits
    movw $24, (%r12)
    add $2, %r12
    
    # reserve 4 bytes for the compression method
    movl  $0, (%r12)
    add $4, %r12

    # reserve 4 bytes for pixel data
    movl  $3072, (%r12)
    add $4, %r12

    # reserve 4 bytes for the horizontal resolution
    movl  $2835, (%r12)
    add $4, %r12

    # reserve 4 bytes for the vertical resolution
    movl  $2835, (%r12)
    add $4, %r12

     # reserve 4 bytes for the colour pallete
    movl  $0, (%r12)
    add $4, %r12

     # reserve 4 bytes for the number of important colours
    movl  $0, (%r12)
    add $4, %r12

    
    movq $32, %r15
    for_loop_rows2:
    cmpq $0, %r15
    je end_for_loop_rows2

    movq $8, %r14
    for_white_12:
        cmpq $0, %r14
        je end_for_white_12

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_12

    end_for_white_12:

    movq $8, %r14
    for_black_12:
        cmpq $0, %r14
        je end_for_black_12

        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12

        dec %r14
        jmp for_black_12

    end_for_black_12:

    movq $4, %r14
    for_white_22:
        cmpq $0, %r14
        je end_for_white_22

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_22

    end_for_white_22:

    movq $4, %r14
    for_black_22:
        cmpq $0, %r14
        je end_for_black_22

        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12

        dec %r14
        jmp for_black_22

    end_for_black_22:


    movq $2, %r14
    for_white_32:
        cmpq $0, %r14
        je end_for_white_32

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_32

    end_for_white_32:

    movq $3, %r14
    for_black_32:
        cmpq $0, %r14
        je end_for_black_32

        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12

        dec %r14
        jmp for_black_32

    end_for_black_32:

    movq $2, %r14
    for_white_42:
        cmpq $0, %r14
        je end_for_white_42

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_42

    end_for_white_42:


    #get the red pixel

    movb $0, (%r12)
    inc %r12
    movb $0, (%r12)
    inc %r12
    movb $255, (%r12)
    inc %r12
    
    
    dec %r15
    jmp for_loop_rows2
    end_for_loop_rows2:



   	# pop callee-saved registers

	popq %r15
	popq %r14
	popq %r13
	popq %r12

    

     # epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret 




create_bar_code:

    # prologue
    pushq	%rbp 			# push the base pointer (and align the stack)
    movq	%rsp, %rbp		# copy stack pointer value to base pointer

    pushq %r12				# push callee-saved registers
	pushq %r13
	pushq %r14
	pushq %r15



    // 8*W 8*B 4*W  3*B 2*W  3*B 2*W 
    leaq image_buffer, %r12
    # BM in ascii
    movb $'B', (%r12)
    inc %r12
    movb $'M', (%r12)
    inc %r12

    # reserve the file size
    movl  $3126, (%r12)
    add $4, %r12

    # reserve 4 bytes
     movl  $0, (%r12)
    add $4, %r12

    # reserve 4 bytes for the offset of the pixels inside
    movl  $54, (%r12)
    add $4, %r12

    # reserve 4 bytes for the header size
    movl  $40, (%r12)
    add $4, %r12


    # reserve 4 bytes for the width of the image
    movl  $32, (%r12)
    add $4, %r12

    # reserve 4 bytes for the height of the image
    movl  $32, (%r12)
    add $4, %r12


    # reserve 2 bytes, each one being 1
    movw $1, (%r12)
    add $2, %r12

    # reserve 2 bytes, for pixel size - 24 bits
    movw $24, (%r12)
    add $2, %r12
    
    # reserve 4 bytes for the compression method
    movl  $0, (%r12)
    add $4, %r12

    # reserve 4 bytes for pixel data
    movl  $3072, (%r12)
    add $4, %r12

    # reserve 4 bytes for the horizontal resolution
    movl  $2835, (%r12)
    add $4, %r12

    # reserve 4 bytes for the vertical resolution
    movl  $2835, (%r12)
    add $4, %r12

     # reserve 4 bytes for the colour pallete
    movl  $0, (%r12)
    add $4, %r12

     # reserve 4 bytes for the number of important colours
    movl  $0, (%r12)
    add $4, %r12

    
    movq $32, %r15
    for_loop_rows:
    cmpq $0, %r15
    je end_for_loop_rows

    movq $8, %r14
    for_white_1:
        cmpq $0, %r14
        je end_for_white_1

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_1

    end_for_white_1:

    movq $8, %r14
    for_black_1:
        cmpq $0, %r14
        je end_for_black_1

        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12

        dec %r14
        jmp for_black_1

    end_for_black_1:

    movq $4, %r14
    for_white_2:
        cmpq $0, %r14
        je end_for_white_2

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_2

    end_for_white_2:

    movq $4, %r14
    for_black_2:
        cmpq $0, %r14
        je end_for_black_2

        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12

        dec %r14
        jmp for_black_2

    end_for_black_2:


    movq $2, %r14
    for_white_3:
        cmpq $0, %r14
        je end_for_white_3

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_3

    end_for_white_3:

    movq $3, %r14
    for_black_3:
        cmpq $0, %r14
        je end_for_black_3

        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12
        movb $0, (%r12)
        inc %r12

        dec %r14
        jmp for_black_3

    end_for_black_3:

    movq $2, %r14
    for_white_4:
        cmpq $0, %r14
        je end_for_white_4

        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12
        movb $255, (%r12)
        inc %r12

        dec %r14
        jmp for_white_4

    end_for_white_4:


    #get the red pixel

    movb $0, (%r12)
    inc %r12
    movb $0, (%r12)
    inc %r12
    movb $255, (%r12)
    inc %r12
    
    
    dec %r15
    jmp for_loop_rows
    end_for_loop_rows:


    


   				 # pop callee-saved registers
	popq %r15
	popq %r14
	popq %r13
	popq %r12

    

     # epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret 





encrypt:
    # prologue
    pushq	%rbp 			# push the base pointer (and align the stack)
    movq	%rsp, %rbp		# copy stack pointer value to base pointer
    
    pushq %rdi
    pushq %r12				# push callee-saved registers
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rbx

    leaq buffer, %r12 # data pointer 
    
    movq %rdi, %rbx

 #for_loops to put 8 × C, 4 × S, 2 × E, 4 × 1, 4 × 4, 8 × 0 for encrypt

    movq $leadTrail, %r13
    for_loop_put_lead:
    cmpb $0, (%r13)
    je end_for_loop_put_lead

    movq $0, %r15
    movb (%r13), %r15b
    movb %r15b, (%r12)
    
    inc %r12
    inc %r13
    jmp for_loop_put_lead
    end_for_loop_put_lead:


    
 #for_loop_to include the sequence 

    for_loop_include_the_sequence:
    cmpb $0, (%rbx) # rbx contains the address of where we are in the format string
    je end_for_loop_include_the_sequence

    
    movq $0, %r15

    # we copy the corresponding character to the buffer

    movb (%rbx), %r15b
    movb %r15b, (%r12) #r12 contains the address of where we are in the buffer

    inc %r12
    inc %rbx

    jmp for_loop_include_the_sequence

    end_for_loop_include_the_sequence:



    #for_loops to put 8 × C, 4 × S, 2 × E, 4 × 1, 4 × 4, 8 × 0 for encrypt

    movq $leadTrail, %r13
    for_loop_put_trail:
    cmpb $0, (%r13)
    je end_for_loop_put_trail

    movq $0, %r15
    movb (%r13), %r15b
    movb %r15b, (%r12)
    
    inc %r12
    inc %r13
    jmp for_loop_put_trail
    end_for_loop_put_trail:

    #put null at the end of the string in the buffer
    movb $0, (%r12)



 #start the encoding process
    leaq buffer, %r12 # the buffer containing the string
    leaq buffer2, %r14 # the buffer containing the run length encoding

    movq $0, %r13 # counter for the number of times a character repeats

    for_loop_rle:

    cmpb $0, (%r12)
    je end_rle
        
        # verify that the current element is equal to the next one
        # equal means that the counter increases
        # not equal means that we move the character and the repetitions in buffer2 and we reset the counter for the next element
        
        movq $0, %r15
        movb 1(%r12), %r15b # next element

        
            cmpb %r15b, (%r12)
            je if_equal_characters
            jmp else_if_equal_characters
        
            if_equal_characters:

                inc %r13

    #check if there is an overflow, counter larger than 255
                cmp $255, %r13  
                jl end_if_equal_characters

                movb $255, (%r14)
                inc %r14

                movq $0, %r11
                movb (%r12), %r11b # put the character in the new buffer
                movb %r11b, (%r14)
                inc %r14
                movq $0, %r13
                jmp end_if_equal_characters 


            else_if_equal_characters:

            inc %r13

            movb %r13b, (%r14) # put the number of times the character is repeated in a new buffer
            inc %r14

            movq $0, %r11
            movb (%r12), %r11b # put the character in the new buffer
            movb %r11b, (%r14)
            inc %r14
           
            movq $0, %r13
            
            end_if_equal_characters:
        

        
    inc %r12
    jmp for_loop_rle

    end_rle:

    movb $0, (%r14) # put a null at the end of the string
    
    /*leaq buffer2, %r14

    print_buffer_2:
    
    cmpb $0, (%r14)
    je end_printf

    movq $0, %r11
    movb (%r14), %r11b
    movq $0, %rax
    movq $output_digit, %rdi
    movq %r11, %rsi
    call printf
    inc %r14
    
    movq $0, %r11
    movb (%r14), %r11b
    movq $0, %rax
    movq $output_char, %rdi
    movq %r11, %rsi
    call printf
    inc %r14

    jmp print_buffer_2
    end_printf:
    */

 
    
    call create_bar_code


    leaq image_buffer + 54, %r12
    leaq buffer2, %r14

    movq $0, %r13
    xor_loop:
    cmpq $3072, %r13
    je end_xor_loop

    movq $0, %r15
    movb (%r14), %r15b
    xorb %r15b, (%r12)    

    inc %r13
    inc %r14
    inc %r12

    jmp xor_loop

    end_xor_loop:



    movq $2, %rax                     # syscall number for sys_open (2)
    movq $file, %rdi               # filename (pointer to string)
    movq $1, %rsi                      # flags (O_WRONLY | O_CREAT)
    movq $0666, %rdx                   # mode (file permissions: rw-rw-rw-)
    syscall                            # invoke system call
    movq %rax, %rdi                    # save returned file descriptor in %rdi

    # sys_write(fd, message, msglen)
    movq $1, %rax                      # syscall number for sys_write (1)
    movq $image_buffer, %rsi                # pointer to message
    movq $3126, %rdx                     # message length (15 bytes)
    syscall                            # invoke system call

    # sys_close(fd)
    movq $3, %rax                      # syscall number for sys_close (3)
    syscall                            # invoke system call



   movq $image_buffer, %rax

    popq %rbx				 # pop callee-saved registers
	popq %r15
	popq %r14
	popq %r13
	popq %r12
    popq %rdi

    # epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret 



decrypt:
 # prologue
    pushq	%rbp 			# push the base pointer (and align the stack)
    movq	%rsp, %rbp		# copy stack pointer value to base pointer
    
    pushq %rdi
    pushq %r12				# push callee-saved registers
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rbx

    movq %rdi, %rbx

    call create_bar_code2

    addq $54, %rbx
    leaq image_buffer2 + 54  , %r12

    movq $0, %r13 # use a counter to get throough the image buffer 2 and the encrypted message
    for_xor_decrypt:
    cmpq $3072, %r13
    je end_for_xor_decrypt

    movq $0, %r15
    movb (%rbx), %r15b
    xor %r15b, (%r12)    

    
    inc %r13
    inc %rbx
    inc %r12

    jmp for_xor_decrypt
    end_for_xor_decrypt:


    leaq image_buffer2 + 66, %r14 # skip the lead as well, which is 12 characters
    
    for_get_size:
    cmpb $0, (%r14)
    je end_get_size

    inc %r13
    inc %r14
    jmp for_get_size
    end_get_size:

    # skip the trail as well
    sub $12, %r14
    movb $0, (%r14)
     
    /*
    leaq image_buffer2+66, %r14
    print_buffer_3:
    cmpb $0, (%r14)
    je end_print3

    movq $0, %r11
    movb (%r14), %r11b
    movq $0, %rax
    movq $output_digit, %rdi
    movq %r11, %rsi
    call printf
    inc %r14

       
    movq $0, %r11
    movb (%r14), %r11b
    movq $0, %rax
    movq $output_char, %rdi
    movq %r11, %rsi
    call printf
    inc %r14

    jmp print_buffer_3
    end_print3:
*/


    # reconstruct the original string 
    leaq image_buffer2 + 66, %r14
    leaq buffer3, %r12

    for_get_the_initial_string: 
    cmpb $0, (%r14)
    je end_for_get_the_initial_string

    movq $0, %r13
    movq $0, %r15

    movb (%r14), %r13b # get the number of repetitions
    inc %r14
    movb (%r14), %r15b # get the character
    inc %r14

        for_transfer_the_character:
        cmpq $0, %r13
        je for_get_the_initial_string
        
        movb %r15b, (%r12)
        inc %r12

        dec %r13
        jmp for_transfer_the_character
    
    jmp for_get_the_initial_string
    end_for_get_the_initial_string:

    movb $0, (%r12)

    /*
    leaq buffer3+66, %r14

    print_buffer_3:
    cmpb $0, (%r14)
    je end_print3

    /*movq $0, %r11
    movb (%r14), %r11b
    movq $0, %rax
    movq $output_digit, %rdi
    movq %r11, %rsi
    call printf
    inc %r14

    
    movq $0, %r11
    movb (%r14), %r11b
    movq $0, %rax
    movq $output_char, %rdi
    movq %r11, %rsi
    call printf
    inc %r14

    jmp print_buffer_3
    end_print3:
   */

    leaq buffer3, %rax

    popq %rbx				 # pop callee-saved registers
	popq %r15
	popq %r14
	popq %r13
	popq %r12
    popq %rdi

# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret 


   

main:
# prologue
pushq	%rbp 			# push the base pointer (and align the stack)
movq	%rsp, %rbp		# copy stack pointer value to base pointer

movq $format_string, %rdi
call encrypt


movq %rax, %rdi 
call decrypt



 
	
# epilogue		
popq	%rbp			# restore base pointer location 
movq	$0, %rdi		# load program exit code
call	exit			# exit the program
