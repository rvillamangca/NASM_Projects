;----------------- PROJECT EULER PROBLEM NO. 025 - 1000-digit Fibonacci number --------------;
;                                                                                            ;  
;   The Fibonacci sequence is defined by the recurrence relation:                            ;
;                                                                                            ;
;       Fn = Fn-1 + Fn-2, where F1 = 1 and F2 = 1.                                           ;
;                                                                                            ;
;   Hence the first 12 terms will be:                                                        ;
;                                                                                            ;
;       F1 = 1                                                                               ;
;       F2 = 1                                                                               ;
;       F3 = 2                                                                               ;                                                                 ;
;       F4 = 3                                                                               ;
;       F5 = 5                                                                               ;
;       F6 = 8                                                                               ;
;       F7 = 13                                                                              ;
;       F8 = 21                                                                              ;    
;       F9 = 34                                                                              ;
;       F10 = 55                                                                             ;
;       F11 = 89                                                                             ;
;       F12 = 144                                                                            ;
;                                                                                            ;
;   The 12th term, F12, is the first term to contain three digits.                           ;
;                                                                                            ;
;   What is the index of the first term in the Fibonacci sequence to contain 1000 digits?    ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   in this exercise we modified the fibonacci number function we developed in problem 2 to
;   yield the number of digits instead of the fibonacci numbers themselves. taking note that:
;
;       1.  log(a^b) = b * log(a)
;       2.  log (a/b) = log(a) - log(b) 
;       3.  we will use the formula found in https://en.wikipedia.org/wiki/Fibonacci_number#Computation_by_rounding
;       4.  deriving from that formula we have:
;
;               rank = ((length-1) + 0.5 * log10(5)) / log10 (phi)
;
;               where:
;                       rank = the fibonacci index
;                       length = the number of digits
;                       phi = the golden ratio
;
;       5.  we need to round-up floating point "rank" before converting to integer. 
;           merely truncating would be wrong because that would mean the integer answer
;           would be less than the first rank to have 1000-digit.

%include "euler.inc"    

%define TARGET 1000

global  main

    section .data 

    section .text    
main:
    enter       0,0
    
    ; load the number of digits less 1
    mov         rax, TARGET
    dec         rax
    cvtsi2sd    xmm2, rax
    
    ; calculate "0.5 * log10(5)
    mov         rax, __float64__(10.00)
    movq        xmm0, rax
    mov         rax, __float64__(5.00)
    movq        xmm1, rax
    call        logb
    mov         rax, __float64__(0.50)
    movq        xmm1, rax
    mulsd       xmm1, xmm0
    
    ; calculate "(length - 1) + 0.5 * log10(5)"
    addsd       xmm2, xmm1
    
    ; calculate "log10 (phi)"
    mov         rax, __float64__(1.6180339887498948482045868343656) ; loads the 'golden ratio' constant 'phi'
    movq        xmm1, rax
    mov         rax, __float64__(10.00)
    movq        xmm0, rax
    call        logb
    
    ; calculate the rank
    divsd       xmm2, xmm0
    roundsd     xmm0, xmm2, 2   ; imm arg "2" is for round-up
    cvttsd2si   rax, xmm0 

end:
    
    print_answer "025", INTEGER, rax
    
    leave
    xor     rax, rax
    ret