; ------------------ PROJECT EULER PROBLEM NO. 001 - Multiples of 3 & 5 ---------------------;
;                                                                                            ;
;   If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5,   ;
;   6 and 9. The sum of these multiples is 23.                                               ;
;                                                                                            ;
;   Find the sum of all the multiples of 3 or 5 below 1000.                                  ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;

%include "euler.inc"

%define LIMIT 999  ; not 1000 because multiples should be "below 1000"

global  main

    section .data  
sum3:   dq 0
sum5:   dq 0
sum15:  dq 0


    section .text    
main:
    enter   0,0
    
    ; take the sum of multiples of 3
    mov     rdi, 3
    mov     rsi, LIMIT
    call    prob1_sum
    mov     qword [sum3], rax
    
    ; take the sum of multiples of 5
    mov     rdi, 5
    mov     rsi, LIMIT
    call    prob1_sum
    mov     qword [sum5], rax
    
    ; take the sum of multiples of 15
    mov     rdi, 15
    mov     rsi, LIMIT
    call    prob1_sum
    mov     qword [sum15], rax
    
    ; apply 'inclusion-exclusion' principle
    mov     rax, [sum3]
    add     rax, [sum5]
    sub     rax, [sum15] 
    
    print_answer "001", INTEGER, rax
    
    leave
    xor     rax, rax
    ret
