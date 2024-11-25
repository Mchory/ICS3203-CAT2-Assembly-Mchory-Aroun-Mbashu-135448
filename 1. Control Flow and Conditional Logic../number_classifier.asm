; Number Classification Program (64-bit)
; Purpose: Classifies input numbers as positive, negative, or zero
; using various jump instructions for control flow

section .data
    prompt_msg db 'Enter a number: '
    prompt_len equ $ - prompt_msg
    
    pos_msg db 'POSITIVE', 0xa
    pos_len equ $ - pos_msg
    
    neg_msg db 'NEGATIVE', 0xa
    neg_len equ $ - neg_msg
    
    zero_msg db 'ZERO', 0xa
    zero_len equ $ - zero_msg

section .bss
    num resb 6    ; Reserve 6 bytes for input (5 digits + sign)

section .text
    global _start

;==================== JUMP INSTRUCTIONS DOCUMENTATION ====================
; This program uses three types of jumps for control flow:
;
; 1. Conditional Jumps (je, jg, jne):
;    - je (Jump if Equal): Used when we need exact matching
;      Impact: Creates specific paths for exact values (zero, minus sign)
;      Why: Perfect for detecting specific characters like '0' or '-'
;
; 2. Comparison Jumps (jg - Jump if Greater):
;    - Used for relative value comparisons
;    - Impact: Helps establish ranges (positive numbers)
;    - Why: Natural for checking if a value exceeds a threshold
;
; 3. Unconditional Jumps (jmp):
;    - Used to force program flow in a specific direction
;    - Impact: Ensures clean separation between different code sections
;    - Why: Prevents fall-through and maintains clean control flow
;
;================================================================

_start:
    ; Display prompt
    mov rax, 1          ; syscall number for write
    mov rdi, 1          ; stdout file descriptor
    mov rsi, prompt_msg ; message to write
    mov rdx, prompt_len ; message length
    syscall

    ; Read user input
    mov rax, 0          ; syscall number for read
    mov rdi, 0          ; stdin file descriptor
    mov rsi, num        ; buffer to store input
    mov rdx, 6          ; maximum bytes to read
    syscall

    ; Begin number classification
    mov al, [num]       ; Load first character

    ;== CONTROL FLOW DECISION TREE ==
    
    ; First check: Is it negative?
    cmp al, '-'
    je check_negative   ; Jump if Equal - Why: Need exact match for minus sign
                       ; Impact: Creates separate path for negative number processing
    
    ; Second check: Is it zero?
    cmp al, '0'
    je print_zero      ; Jump if Equal - Why: Need exact match for zero
                      ; Impact: Provides direct path to zero handling
    
    ; Third check: Is it positive?
    cmp al, '0'
    jg print_positive  ; Jump if Greater - Why: Identifies any value > '0'
                      ; Impact: Captures all positive numbers efficiently
    
    ; Default case: Assume positive for any other valid input
    jmp print_positive ; Unconditional Jump - Why: Provides default behavior
                      ; Impact: Ensures program handles unexpected input gracefully

check_negative:
    ; Verify if actually negative (not just a minus sign)
    mov al, [num + 1]   ; Check character after minus
    cmp al, '0'         ; Compare with '0'
    jne print_negative  ; Jump if Not Equal - Why: Confirms actual number follows
                       ; Impact: Prevents misclassification of sole minus sign
    
print_negative:
    mov rax, 1
    mov rdi, 1
    mov rsi, neg_msg
    mov rdx, neg_len
    syscall
    jmp exit           ; Unconditional Jump - Why: Prevent fall-through
                      ; Impact: Ensures clean exit after printing

print_positive:
    mov rax, 1
    mov rdi, 1
    mov rsi, pos_msg
    mov rdx, pos_len
    syscall
    jmp exit           ; Unconditional Jump - Why: Prevent fall-through
                      ; Impact: Ensures clean exit after printing

print_zero:
    mov rax, 1
    mov rdi, 1
    mov rsi, zero_msg
    mov rdx, zero_len
    syscall
    jmp exit           ; Unconditional Jump - Why: Prevent fall-through
                      ; Impact: Ensures clean exit after printing

exit:
    mov rax, 60         ; syscall number for exit
    mov rdi, 0          ; exit code 0
    syscall

