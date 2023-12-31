;------------- PROJECT EULER PROBLEM NO. 012 - Highly divisible triangular number -----------;
;                                                                                            ;
;                                                                                            ;   
;   The sequence of triangle numbers is generated by adding the natural numbers.             ;
;   So the 7th triangle number would be 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28. The first ten        ; 
;   terms would be:                                                                          ;
;                                                                                            ;
;                       1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...                             ;
;                                                                                            ;
;   Let us list the factors of the first seven triangle numbers:                             ;
;                                                                                            ;
;     1: 1                                                                                   ;
;     3: 1,3                                                                                 ;
;     6: 1,2,3,6                                                                             ;
;    10: 1,2,5,10                                                                            ;
;    15: 1,3,5,15                                                                            ;
;    21: 1,3,7,21                                                                            ;
;    28: 1,2,4,7,14,28                                                                       ;
;                                                                                            ;
;   We can see that 28 is the first triangle number to have over five divisors.              ;
;                                                                                            ;
;   What is the value of the first triangle number to have over five hundred divisors?       ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   for this problem we will make use of two functions: "triangular", to generate triangular
;   numbers and "num_divs", to get the number of divisors of a number. the function "triangular"
;   is just the same as the function "sum_consec" that we used in prob-01. for "num_divs"
;   we used trial division, which is not very efficient but sufficient for this problem.

%include "euler.inc"

%define LIMIT 500  

global  main

    section .data  
cand:   dq 0

    section .text    
main:
    enter   0,0
    
    mov     rbx, 0
start:
    inc     rbx
    mov     rdi, rbx
    call    triangular
    mov     qword [cand], rax
    mov     rdi, rax
    call    num_divs
    cmp     rax, LIMIT
    jl      start
    
    print_answer "012", INTEGER, [cand]
    
    leave
    xor     rax, rax
    ret