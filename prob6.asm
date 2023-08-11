; ----------------- PROJECT EULER PROBLEM NO. 006 - Sum square difference -------------------;
;                                                                                            ;
;   The sum of the squares of the first ten natural numbers is,                              ;
;   1^2 + 2^2 + ... + 10^2 = 385                                                             ;
;                                                                                            ;                                                             ;
;   The square of the sum of the first ten natural numbers is,                               ;
;   (1 + 2 + ... + 10)^2 = 55^2 = 3025                                                       ;
;                                                                                            ;
;   Hence the difference between the sum of the squares of the first ten natural numbers     ;
;   and the square of the sum is 3025 − 385 = 2640.                                          ;
;                                                                                            ;
;   Find the difference between the sum of the squares of the first one hundred natural      ;
;   numbers and the square of the sum.                                                       ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
 
; NOTE: we have already created a function to sum up consecutive numbers. in this problem
;       we created a new function to sum up consecutive squares.

%include "euler.inc"

%define NUMBER 100

global  main

    section .text    
main:
    enter   0,0

    ; calculate sum of squares
    mov rdi, NUMBER
    call sum_conssq
    mov rbx, rax
    
    ; calculate square of sums
    mov rdi, NUMBER
    call sum_consec
    mul rax
    
    ; take the difference
    sub rax, rbx
                
    print_answer "006", INTEGER, rax
    
    leave 
    xor     rax, rax
    ret
