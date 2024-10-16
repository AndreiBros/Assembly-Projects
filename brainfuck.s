# cd /mnt/c/Users/diana/ComputerOrganisation
# gcc -no-pie -o brainfuck brainfuck.s

# gcc -c instruction.s -o instruction.o
# objdump -d instruction.o


.global brainfuck

.data
start_time: .quad 0
format_str: .asciz "We should be executing the following code:\n%s"
debug: .asciz "ceva %c\n"
begin: .asciz "begin"
end: .asciz "end"
until: .asciz "here"
promptd: .asciz "%d %d\n"
character: .asciz "%c\n"
percent: .asciz "%"
buffer: .space 32
hz: .quad 2694859000
.text
# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

brainfuck:

        movq %rdi, %rbx # address of the brainfuck code (instruction pointer)
        movq %rdi, %r13 # store address

        /*rdtsc
        shlq $32, %rdx
        or %rdx, %rax
        movq %rax, start_time

        movq $0, %r12
        loop_count:
                cmpb $0, (%rbx)
                je end_loop_count

                inc %r12
                inc %rbx
                jmp loop_count
        end_loop_count:*/

        movq %r13, %rbx # recover address

        
        movq %r12, %rsi # length of file
        addq $2, %rsi # make sure there is enough space
        movq $0, %rdi
        shl $4, %rsi # suppose each instruction is 16 bytes
        movq $3, %rdx # put the proper flags for the memory PROT_READ | PROT_WRITE
        movq $0x22, %rcx
        movq $-1, %r8
        movq $0, %r9
        call mmap # memory
        
        movq %rax, %r14 # where we write 
        movq %r14, %r12 # remember the address of the buffer

        
        movq $0x55, (%r14) # pushq %rbp
        addq $1, %r14
        movq $0xe58948, (%r14) # movq %rsp, %rbp
        addq $3, %r14
        movq $0x5441, (%r14) # pushq %r12
        addq $2, %r14
        movq $0x5541, (%r14) # pushq %r13
        addq $2, %r14
        movq $0xfc8949, (%r14) # movq %rdi, %r12
        addq $3, %r14
        movq $0xc5c749, (%r14) # movq $0, %r13
        addq $7, %r14

        
        
        # in the assembly subroutine we use rbx as instruction pointer
        # in the machine language subroutine we use r12 as data pointer
        loop:   
                
                
                movb (%rbx), %sil # store the next character

                cmpb $0, %sil
                je end_loop

                cmpb $43, %sil
                je increment_byte

                cmpb $44, %sil
                je scan_character

                cmpb $45, %sil
                je decrement_byte

                cmpb $46, %sil
                je print_character

                cmpb $60, %sil
                je decrement_data_pointer

                cmpb $62, %sil
                je increment_data_pointer

                
                cmpb $91, %sil
                je begin_the_loop

                cmpb $93, %sil
                je end_the_loop
                

                # comment character
                jmp continue

                increment_byte:

                        movq $0, %rdi
                        loop_inc_byte:
                                
                                movb (%rbx), %sil # store the next character

                                cmpb $43, %sil
                                jne end_inc_byte

                                inc %rdi
                                inc %rbx
                                jmp loop_inc_byte
                        end_inc_byte:

                        dec %rbx

                        movq $0x24048041, (%r14) # addb $something, (%r12)
                        addq $4, %r14
                        movb %dil, (%r14) # the value of the byte for addb
                        incq %r14
                        

                        jmp continue

                scan_character:
                        # machine code 
                        movq $0xc0c748, (%r14) # movq $0, %rax # system read (0)
                        addq $7, %r14
                        movq $0xc7c748, (%r14) # movq $0, %rdi # standard input
                        addq $7, %r14
                        movq $0xe6894c, (%r14) # movq %r12, %rsi # address of the character
                        addq $3, %r14
                        movq $0x01c2c748, (%r14) # movq $1, %rdx # one byte
                        addq $7, %r14
                        movq $0x050f, (%r14) # syscall # the system call
                        addq $2, %r14
                        jmp continue

                decrement_byte:
                        
                        movq $0, %rdi
                        loop_dec_byte:
                                
                                movb (%rbx), %sil # store the next character

                                cmpb $45, %sil
                                jne end_dec_byte

                                inc %rdi
                                inc %rbx
                                jmp loop_dec_byte
                        end_dec_byte:

                        dec %rbx
                        
                        movq $0x242c8041, (%r14) # subb $something, (%r12)
                        addq $4, %r14
                        movb %dil, (%r14) # value
                        incq %r14

                        
                        jmp continue

                print_character:
                        # machine code 
                        movq $0x01c0c748, (%r14) # movq $1, %rax # sys_write
                        addq $7, %r14
                        movq $0x01c7c748, (%r14) # movq $1, %rdi # standard out
                        addq $7, %r14
                        movq $0xe6894c, (%r14) # movq %r12, %rsi # address of the character
                        addq $3, %r14
                        movq $0x01c2c748, (%r14) # movq $1, %rdx # one byte
                        addq $7, %r14
                        movq $0x050f, (%r14) # syscall
                        addq $2, %r14

                        
                        jmp continue

                decrement_data_pointer:
                        movq $0, %rdi
                        loop_dec_pointer:
                                
                                movb (%rbx), %sil # store the next character

                                cmpb $60, %sil
                                jne end_dec_pointer

                                inc %rdi
                                inc %rbx
                                jmp loop_dec_pointer
                        end_dec_pointer:

                        dec %rbx

                        movq $0xec8149, (%r14) # subq $something, %r12
                        addq $3, %r14
                        movq %rdi, (%r14) # value
                        addq $4, %r14 

                        
                        jmp continue

                increment_data_pointer:

                        movq $0, %rdi
                        loop_inc_pointer:
                                
                                movb (%rbx), %sil # store the next character

                                cmpb $62, %sil
                                jne end_inc_pointer

                                inc %rdi
                                inc %rbx
                                jmp loop_inc_pointer
                        end_inc_pointer:

                        dec %rbx

                        movq $0xc48149, (%r14) # addq $something, %r12
                        addq $3, %r14
                        movq %rdi, (%r14) # value
                        addq $4, %r14

                        jmp continue

                
                begin_the_loop:

                        # check if it is [-]
                        movq $0, %rax
                        movq $0, %rdi
                        movq $1, %rcx

                        cmpb $45, 1(%rbx)
                        cmove %rcx, %rax

                        cmpb $93, 2(%rbx)
                        cmove %rcx, %rdi

                        addq %rax, %rdi
                        cmpq $2, %rdi
                        je zero_value

                        
                        # check if it is [->>..>+<..<] or [-<<..<+>..>] or [->..>-<..<] or [-<..<->..>]
                        movq $1, %rcx
                        movq $0, %rax


                        cmpb $45, 1(%rbx)
                        jne continue_bracket # -

                        cmpb $62, 2(%rbx)
                        cmove 2(%rbx), %rax # >

                        cmpb $60, 2(%rbx)
                        cmove 2(%rbx), %rax # <

                        cmpq $0, %rax
                        je continue_bracket 

                        movq %rbx, %rsi
                        addq $3, %rsi
                        movq $1, %rdi # count how many
                        loop_arrow:
                                movq $0, %rcx
                                movb -1(%rsi), %cl
                                cmpb %cl, (%rsi) # compare
                                jne end_arrow

                                addq $1, %rdi

                                addq $1, %rsi
                                jmp loop_arrow
                        end_arrow:

                        movq $0, %r13

                        cmpb $43, (%rsi)
                        cmove (%rsi), %r13 # +

                        cmpb $45, (%rsi)
                        cmove (%rsi), %r13 # -

                        cmpq $0, %r13
                        je continue_bracket

                        addq $1, %rsi
                        movq $0, %rax
                        movb (%rsi), %al
                        addb 2(%rbx), %al # add value of current and first arrow

                        cmpq $122, %rax # < and >
                        jne continue_bracket

                        addq $1, %rsi
                        movq $1, %rdx # count 
                        loop_arrow2:
                                movq $0, %rax
                                movb -1(%rsi), %al
                                cmpb %al, (%rsi) # compare
                                jne end_arrow2

                                addq $1, %rdx

                                addq $1, %rsi
                                jmp loop_arrow2
                        end_arrow2:

                        cmpq %rdi, %rdx # same number of <>
                        jne continue_bracket

                        cmpb $93, (%rsi) # ]
                        jne continue_bracket

                        
                        movq %rdi, %rax
                        
                        
                        movq $0x0548, %r10 # addq $something, %rax
                        movq $0x2d48, %r11 # subq $something, %rax

                        cmpb $60, 2(%rbx) # < - we subtract (left)
                        cmove %r11, %r10 # else add


                        movq $0xe0894c, (%r14) # movq %r12, %rax
                        addq $3, %r14
                        movq %r10, (%r14) # addq $something, %rax; subq $something, %rax
                        addq $2, %r14
                        movq %rax, (%r14) # number of arrows - how much to move
                        addq $4, %r14
                        movq $0x243c8a41, (%r14) # movb (%r12), %dil
                        addq $4, %r14

                        movq $0, %rdi
                        movq $0, %rdx

                        movq $0x380040, %rdi # addb %dil, (%rax)
                        movq $0x382840, %rdx # subb %dil, (%rax)

                        cmpb $45, %r13b # -
                        je subtract

                        
                        movq %rdi, (%r14) # addb %dil, (%rax)
                        addq $3, %r14
                        movq $0x002404c641, (%r14) # movb $0, (%r12)
                        addq $5, %r14

                        movq %rsi, %rbx

                        jmp continue

                        subtract:
                        movq $0xdff640, (%r14) # negb %dil
                        addq $3, %r14
                        movq %rdi, (%r14) # addb %dil, (%rax)
                        addq $3, %r14
                        movq $0x002404c641, (%r14) # movb $0, (%r12)
                        addq $5, %r14

                        movq %rsi, %rbx

                        jmp continue
                        
                        

                        

                        continue_bracket:

                        pushq %r14 # remember the address of bracket
                        movq $0x00243c8041, (%r14) # cmpb $0, (%r12)
                        addq $5, %r14

                        movq $0x840f, (%r14) # je end_bracket - which will be written after (it is 840f because of the size of the file)
                        addq $6, %r14

                        
                        jmp continue

                        zero_value:
                                movq $0x002404c641, (%r14) # movb $0, (%r12)
                                addq $5, %r14
                                addq $2, %rbx
                                
                                jmp continue

                end_the_loop:

                        movq $0x00243c8041, (%r14) # cmpb $0, (%r12)
                        addq $5, %r14
                        movq $0x850f, (%r14) # jne begin_bracket - which will be written later 
                        addq $2, %r14

                        popq %rdx # get address of open bracket

                        
                        movq %r14, %rax
                        subq %rdx, %rax # difference in bytes between the adresses
                        subq $7, %rax # write after the je end_bracket
                        movl %eax, 7(%rdx) # write the address at end
                        movq $-1, %rcx
                        imulq %rcx # now the difference is negative
                        movl %eax, (%r14) # write at jne begin_bracket 
                        addq $4, %r14

                        

                        jmp continue
                        

                continue:

                incq %rbx
                jmp loop
        end_loop:

        
        movq $0x5d41, (%r14) # popq %r13
        addq $2, %r14
        movq $0x5c41, (%r14) # popq %r12
        addq $2, %r14
        movq $0xec8948, (%r14) # movq %rbp, %rsp
        addq $3, %r14
        movq $0x5d, (%r14) # popq %rbp
        addq $1, %r14
        movq $0xc3, (%r14) # ret
        addq $1, %r14

        

        movq %r14, %rbx
        subq %r12, %rbx # length of machine code

        movq %r12, %rdi # address of subroutine
        movq %rbx, %rsi # number of bytes
        movq $5, %rdx # flag PROT_READ | PROT_EXEC
        call mprotect

        movq $32768, %rdi 
        call malloc # allocate space


        movq %rax, %rdi # address of heap (the data pointer)
        addq $1024, %rdi # do not start at 0
        movq %r12, %rbx # address of code
        call *%rbx

        
        /*rdtsc
        shlq $32, %rdx
        or %rdx, %rax

        movq start_time, %rcx
        subq %rcx, %rax

        

		
						
		leaq buffer+29, %rdi # the address of end of buffer
		movb $0, -1(%rdi) # put null at the end 

		loop_d:
			movq $10, %rcx # divide by 10 every time
			movq $0, %rdx # clear rdx
			divq %rcx 
			addb $'0', %dl # convert to ascii
			decq %rdi # decrease buffer address
			movb %dl, (%rdi) # put the character  

			cmpq $0, %rax
			jne loop_d # when quotient is not 0

		
		movq %rdi, %r15 # rdi is the parameter of the subroutine, which is the address of the first char of the string

		loopstring:
			cmpb $0, (%r15) # checks if character is null
			je endstring

			movq $1, %rax # sys_write
			movq $1, %rdi # standard out
			movq %r15, %rsi # address of character
			movq $1, %rdx # one character
			syscall

			inc %r15
			jmp loopstring
		endstring:*/
        
        
	ret