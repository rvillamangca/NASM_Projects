;--------------------- PROJECT EULER PROBLEM NO. 023 - Non-abundant sums --------------------;
;                                                                                            ;  
;   A perfect number is a number for which the sum of its proper divisors is exactly equal   ;
;   to the number. For example, the sum of the proper divisors of 28 would be 1 + 2 + 4      ;
;   + 7 + 14 = 28, which means that 28 is a perfect number.                                  ;
;                                                                                            ;
;   A number n is called deficient if the sum of its proper divisors is less than n and      ;
;   it is called abundant if this sum exceeds n.                                             ;
;                                                                                            ;
;   As 12 is the smallest abundant number, 1 + 2 + 3 + 4 + 6 = 16, the smallest number that  ;
;   can be written as the sum of two abundant numbers is 24. By mathematical analysis, it    ;
;   can be shown that all integers greater than 28123 can be written as the sum of two       ;
;   abundant numbers. However, this upper limit cannot be reduced any further by analysis    ;
;   even though it is known that the greatest number that cannot be expressed as the sum of  ;
;   two abundant numbers is less than this limit.                                            ;
;                                                                                            ;
;   Find the sum of all the positive integers which cannot be written as the sum of two      ;
;   abundant numbers.                                                                        ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;  

;   for this problem we will use the function 'sum_divs' which we developed in problem 21
;   to get our target we start first with the sum of all integers from 1 to 28123 and then
;   deduct the sum of all numbers that can be written as the sum of pairs of abundants

%include "euler.inc"

%define LIMIT 28123 

global  main

    section .data
abunds:         times LIMIT dq 0
sums_abunds:    times LIMIT dq 0  
total:          dq 0

    section .text    
main:
    enter   0,0
    
    ; determine abundant numbers
    mov     rcx, -1
    mov     rbx, 0
abun_start:
    inc     rcx
    cmp     rcx, LIMIT
    jge     abun_end
    mov     rdi, rcx
    call    sum_divs
    cmp     rax, rcx
    jle     abun_start
    mov     qword [abunds+rbx*8], rcx
    inc     rbx
    jmp     abun_start
abun_end:

    ; get sums of pairs of abundants
    mov     rcx, -1
sums_start:
    inc     rcx
    cmp     qword [abunds+rcx*8], 0
    je      sums_end
    mov     rbx, rcx
    dec     rbx
smstart:
    inc     rbx
    cmp     qword [abunds+rbx*8], 0
    je      sums_start
    mov     rax, [abunds+rcx*8]
    add     rax, [abunds+rbx*8]
    cmp     rax, LIMIT
    jg      sums_start
    mov     rdx, rax
    dec     rdx
    mov     qword [sums_abunds+rdx*8], rax
    jmp     smstart 
sums_end:

    ; get the sum of all integers from 1 to LIMIT
    mov     rdi, LIMIT
    call    sum_consec
    mov     qword [total], rax
    
    ; deduct the numbers that can be written as sum of abundant pairs
    mov     rcx, LIMIT
deduct:
    mov     rbx, rcx
    dec     rbx
    mov     rax, [sums_abunds+rbx*8]
    sub     qword [total], rax
    loop    deduct
                    
    print_answer "022", INTEGER,[total]
    
    leave
    xor     rax, rax
    ret