%include "sysio64.inc"
%include "functions.inc"
%include "structures.inc"

; ---- answer printing ----

%define INTEGER "%lld"
%define UNTEGER "%llu"
%define STRING "%s"

%macro print_answer 3   ; prints a Project Euler problem answer to the screen in format
    SECTION .data
        %%header  db "--- Project Euler Problem #", %1, " Answer --------", 0
        %%fmt   db  %2
    SECTION .text
        write_nl
        write_str %%header
        %rep 2 
            write_nl
        %endrep
        %rep 5 
            write_sp
        %endrep
        %ifidn __OUTPUT_FORMAT__, win64
            mov     rcx, %%fmt
            mov     rdx, %3
            sub     rsp, 40
            call    printf
            add     rsp, 40
        %elifidn __OUTPUT_FORMAT__, elf64
            mov     rdi, %%fmt
            mov     rsi, %3
            call    printf
        %endif
        write_nl
%endmacro

; ---- problem #1 functions ----

prob1_sum:
    mov     r13, rsi    ; stores the limit
    mov     r14, rdi    ; stores the divisor
    mov     rax, r13    ; moves the limit to 'rax'
    xor     rdx, rdx    ; prepares for division
    div     r14         ; divides limit with divisor
    mov     r15, rax    ; stores the quotient
    mov     rdi, r15    ; prepares to run 'sum_consec' function
    call    sum_consec
    mul     r14         ; multiplies the result of 'sum_consec' by the divisor
    ret

; ---- problem #4 functions ----

make_pal4:              ; makes a 4-digit palindrome
    mov     rax, rdi
    mov     rdi, 1001
    mul     rdi
    mov     rdi, rax
    mov     rax, rsi
    mov     rsi, 110
    mul     rsi
    add     rax, rdi
    ret
    
make_pal5:              ; makes a 5-digit palindrome
    mov     rax, rdi
    mov     r13, 10001
    mul     r13
    mov     r13, rax
    mov     rax, rsi
    mov     r14, 1010
    mul     r14
    add     r13, rax
    mov     rax, r9
    mov     r15, 100
    mul     r15
    add     rax, r13
    ret 
       
make_pal6:              ; makes a 6-digit palindrome
    mov     rax, rdi
    mov     r13, 100001
    mul     r13
    mov     r13, rax
    mov     rax, rsi
    mov     r14, 10010
    mul     r14
    add     r13, rax
    mov     rax, r9
    mov     r15, 1100
    mul     r15
    add     rax, r13
    ret 

prob4_testdiv:          ; test divisibility of numbers for problem #4
    mov     r13, rdi
    call    isqrt
    mov     rbx, rax
    inc     rbx
.testdiv4:
    dec     rbx
    cmp     rbx, 100
    jl      .ndiv4
    mov     rax, r13
    xor     rdx, rdx
    div     rbx
    cmp     rax, 100
    jl      .testdiv4
    cmp     rax, 999
    jg      .ndiv4 
    cmp     rdx, 0
    jne     .testdiv4
    mov     rax, 1
    jmp     .enddiv4
.ndiv4:
    mov     rax, 0
    jmp     .enddiv4
.enddiv4:
    ret
    
; ---- problem #8 functions ----

prod_13:
    ; rdi will contain the address of the first digit to be multiplied
    mov     r15, rcx
    mov     rax, 1
    dec     rdi
    mov     rcx, 13
.start:
    inc     rdi
    movsx   rbx, byte [rdi]
    mul     rbx
    cmp     rax, 0
    je      .end
    loop    .start
.end:
    mov     rcx, r15
    ret

; ---- problem #22 functions ----

%macro add_byte_array 3
SECTION     .data
    %%_rax   dq 0
    %%_rdx   dq 0
SECTION     .text
    mov     [%%_rax], rax
    mov     [%%_rdx], rdx
    xor     rax, rax
    mov     r8, %3
%%start:
    dec     r8
    cmp     r8, 0
    jl      %%end
    mov     r9, %2
    add     r9, r8
    movsx   rdx, byte [r9]
    add     rax, rdx
    jmp     %%start
%%end:
    mov     %1, rax
    mov     rdx, [%%_rdx]
    mov     rax, [%%_rax]
%endmacro