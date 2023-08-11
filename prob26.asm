;--------------------- PROJECT EULER PROBLEM NO. 026 - Reciprocal cycles --------------------;
;                                                                                            ;  
;   A unit fraction contains 1 in the numerator. The decimal representation of the unit      ;
;   fractions with denominators 2 to 10 are given:                                           ;
;                                                                                            ;
;   1/2     =   0.5                                                                          ;
;   1/3     =   0.(3)                                                                        ;
;   1/4     =   0.25                                                                         ;
;   1/5     =   0.2                                                                          ;
;   1/6     =   0.1(6)                                                                       ;
;   1/7     =   0.(142857)                                                                   ;
;   1/8     =   0.125                                                                        ;
;   1/9     =   0.(1)                                                                        ;
;   1/10    =   0.1                                                                          ;
;                                                                                            ;
;   Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can be seen        ;
;   that 1/7 has a 6-digit recurring cycle.                                                  ;
;                                                                                            ;
;   1Find the value of d < 1000 for which 1/d contains the longest recurring cycle in its    ;
;   decimal fraction part.                                                                   ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;

;   in this exercise we will use the methods presented in https://en.wikipedia.org/wiki/Repeating_fraction
;   we take note of the following:
;
;       1.  we shall call the repeated digits as "repetend".
;       2.  there is no need to evaluate integers that are not coprime with 10. the reason for
;           this is that for numbers divisible by 2 and/or 5, the repetend length of "n = 2^a * 5^b * k"
;           where 'k' is the remaining factor which is coprime with 10, is either "0" or the length
;           of repetend of 'k'. therefore some, value 'k' less than 'n' will have the same length as 'n'
;       3.  the length of repetend of a prime 'p', coprime with 10, is equal to multiplicative order of 10
;           to the base 'p'. we therefore, need to develop a function to calculate multiplicative order.
;       4.  the length of repetend of a power of a prime 'p^k', coprime with 10 is given by "p^(k-1) * (length of p)
;       5.  the length of repetend of an integer 'n = p^k * p^j...', is equal the LCM of lengths of all
;           powers of its prime factors (i.e. len(n) = LCM(len(p^k), len(p^j)...)). we therefore need an LCM function           

%include "euler.inc"

%define LIMIT 1000

global  main

    section .data
primes:         times LIMIT+1 dq 0
rep_lengths:    times LIMIT+1 dq 0

    section .text    
main:
    enter   0,0
    
    ; find all primes below 1000 that are coprime to 10
    mov     qword [primes+3*8], 3
    mov     rbx, LIMIT+1
prstart:
    sub     rbx, 2
    cmp     rbx, 5
    jle     prend
    mov     rdi, rbx
    call    is_prime
    cmp     rax, TRUE
    jne     prstart
    mov     qword [primes+rbx*8], rbx
    jmp     prstart
prend:

    ; find the repetend length of powers of primes coprime with 10
    mov     rbx, 1
    mov     rsi, 10
ppstart:
    inc     rbx
    cmp     rbx, LIMIT
    jge     ppend
    cmp     qword [primes+rbx*8], 0
    je      ppstart
    mov     rdi, [primes+rbx*8]
    call    mult_order
    mov     qword [rep_lengths+rbx*8], rax
    mov     r11, rbx
    mov     r12, rbx
    mov     r13, rax
powstart:
    imul    r12, rbx
    cmp     r12, LIMIT
    jge     ppstart
    imul    r11, r13
    mov     qword [rep_lengths+r12*8], r11
    mov     r11, r12
    jmp     powstart
ppend:

    ; find the repetend lengths of all numbers coprime to 10
    mov     rbx, LIMIT+1
allstart:
    sub     rbx, 2
    cmp     rbx, 1
    jle     allend
    cmp     qword [rep_lengths+rbx*8], 0
    jne     allstart
    mov     rax, rbx
    xor     rdx, rdx
    mov     r9, 5
    div     r9
    cmp     rdx, 0
    je      allstart
    mov     rdi, 1
    mov     rcx, rbx
    mov     r15, rbx
repstart:
    cmp     r15, 1
    je      repend
    dec     rcx
    cmp     qword [rep_lengths+rcx*8], 0
    je      repstart
    mov     rax, r15
    xor     rdx, rdx
    div     rcx
    cmp     rdx, 0
    jne     repstart
    mov     r15, rax
    mov     rsi, qword [rep_lengths+rcx*8]
    call    lcm
    mov     rdi, rax
    jmp     repstart
repend:
    mov     qword [rep_lengths+rbx*8], rdi
    jmp     allstart
allend:

    ; find the maximum repetend length
    mov     rax, 0
    mov     rdx, 0
    mov     rcx, LIMIT
maxstart:
    cmp     qword [rep_lengths+rcx*8], rdx
    jle     maxloop
    mov     rax, rcx
    mov     rdx, [rep_lengths+rcx*8]
maxloop:
    loop    maxstart         
    
    print_answer "026", INTEGER, rax  
    leave
    xor     rax, rax
    ret