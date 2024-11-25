; Factorial Calculator Program (64-bit)
section .data
    prompt_msg db 'Enter a number (1-8): '
    prompt_len equ $ - prompt_msg
    
    result_msg db 'Factorial result: '
    result_len equ $ - result_msg
    
    newline db 0xa
    
section .bss
    input resb 2   ; Space for input character and newline
    output resb 20 ; Buffer for output number string

section .text
    global _start

_start:
    ; Print prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall

    ; Read input
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 2
    syscall

    ; Convert ASCII to number
    movzx rdi, byte [input]
    sub rdi, '0'        ; RDI now contains our input number

    ; Call factorial subroutine
    call factorial
    
    ; Save factorial result before conversion
    push rax
    
    ; Print result message
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_len
    syscall
    
    ; Restore factorial result and convert to string
    pop rax
    mov rdi, rax
    call number_to_string
    
    ; Print the result number
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, r10        ; R10 contains length from number_to_string
    syscall
    
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    ; Exit
    mov rax, 60
    mov rdi, 0
    syscall

factorial:
    push rbp
    mov rbp, rsp
    push rcx            ; Save counter
    
    mov rax, 1          ; Start with 1
    mov rcx, rdi        ; Copy input to counter
    
factorial_loop:
    cmp rcx, 1          ; Check if we're done
    jle factorial_done  ; If counter <= 1, we're done
    
    mul rcx             ; RAX = RAX * RCX
    dec rcx
    jmp factorial_loop
    
factorial_done:
    pop rcx
    pop rbp
    ret

number_to_string:
    push rbp
    mov rbp, rsp
    push rbx            ; We'll use rbx for temporary storage
    
    mov rax, rdi        ; Number to convert
    mov rsi, output     ; Point to start of output buffer
    mov rcx, 0          ; Initialize length counter
    mov rbx, 10         ; Divisor
    
    ; First, handle special case of zero
    test rax, rax
    jnz convert_start
    mov byte [rsi], '0'
    mov r10, 1
    jmp convert_end

convert_start:
    ; First pass: get digits in reverse order
convert_loop:
    mov rdx, 0          ; Clear high part of dividend
    div rbx             ; Divide by 10
    add dl, '0'         ; Convert remainder to ASCII
    push rdx            ; Save digit on stack
    inc rcx             ; Increment length counter
    test rax, rax       ; Check if more digits
    jnz convert_loop
    
    ; Second pass: pop digits in correct order
    mov r10, rcx        ; Save length
store_loop:
    pop rdx             ; Get digit
    mov [rsi], dl       ; Store in buffer
    inc rsi             ; Next buffer position
    dec rcx             ; Decrement counter
    jnz store_loop

convert_end:
    pop rbx
    pop rbp
    ret