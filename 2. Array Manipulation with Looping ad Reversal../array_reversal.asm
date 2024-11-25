; Array Reversal Program (64-bit)
; Purpose: Accepts 5 integers, reverses them in place, and displays the result
; Memory Efficiency: Uses in-place reversal without additional array storage

section .data
    prompt_msg db 'Enter 5 numbers (press Enter after each):', 0xa
    prompt_len equ $ - prompt_msg
    
    output_msg db 'Reversed array:', 0xa
    output_len equ $ - output_msg
    
    space db ' '
    newline db 0xa
    
section .bss
    ; Memory Challenge 1: handling both string input and numeric storage
    ; Solution: Reserve enough space for string representation and conversion
    array resb 40        ; 5 numbers, each could be up to 8 bytes (including sign and newline)
    input_buffer resb 8  ; Buffer for single number input
    number resq 1        ; 8-byte space for numeric conversion
    
section .text
    global _start

_start:
    ; Display input prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_msg
    mov rdx, prompt_len
    syscall
    
    ; Initialize array index in r12
    xor r12, r12    ; r12 will track array position
    
input_loop:
    ; Read a number from user
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, input_buffer
    mov rdx, 8          ; max 8 bytes per number
    syscall
    
    ; Store number in array
    ; Memory Challenge 2: Need to handle ASCII to numeric conversion
    mov al, [input_buffer]
    sub al, '0'         ; Convert ASCII to numeric
    mov byte [array + r12], al
    
    inc r12
    cmp r12, 5          ; Check if we've got 5 numbers
    jl input_loop
    
    ; Display output message
    mov rax, 1
    mov rdi, 1
    mov rsi, output_msg
    mov rdx, output_len
    syscall
    
    ; Reverse array in place
    ; Memory Challenge 3: Swapping without temporary storage
    ; Solution: Use registers for temporary storage during swap
    mov rcx, 0          ; Left index
    mov rdx, 4          ; Right index (5-1)
    
reverse_loop:
    cmp rcx, rdx
    jge print_array     ; If left >= right, reversal is complete
    
    ; Load values into registers
    movzx r8, byte [array + rcx]  ; Left value
    movzx r9, byte [array + rdx]  ; Right value
    
    ; Swap values
    mov byte [array + rcx], r9b
    mov byte [array + rdx], r8b
    
    inc rcx
    dec rdx
    jmp reverse_loop
    
print_array:
    ; Initialize print loop counter
    xor r12, r12
    
print_loop:
    ; Convert number back to ASCII
    movzx rax, byte [array + r12]
    add al, '0'
    mov [input_buffer], al
    
    ; Print number
    mov rax, 1
    mov rdi, 1
    mov rsi, input_buffer
    mov rdx, 1
    syscall
    
    ; Print space
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    inc r12
    cmp r12, 5
    jl print_loop
    
    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
exit:
    mov rax, 60
    mov rdi, 0
    syscall

;==================== MEMORY HANDLING DOCUMENTATION ====================
; This program handles several memory-related challenges:
;
; 1. Input Storage Challenge:
;    - Need to handle ASCII input but store as numbers
;    - Solution: Convert ASCII to numeric during input
;    - Impact: Requires careful handling of ASCII/numeric conversion
;
; 2. In-Place Reversal Challenge:
;    - Must swap values without using additional array
;    - Solution: Use registers as temporary storage
;    - Impact: Minimizes memory usage but requires careful register management
;
; 3. Array Bounds Challenge:
;    - Must track array boundaries during reversal
;    - Solution: Use two indices (left/right) moving toward center
;    - Impact: Prevents out-of-bounds access and ensures complete reversal
;
; 4. Memory Access Patterns:
;    - Direct memory access for array elements
;    - Byte-level operations for single-digit numbers
;    - Register-based temporary storage for swaps
;
; 5. Memory Efficiency:
;    - No additional array allocation
;    - Minimal temporary storage
;    - Direct manipulation of original array
;
;================================================================