;---------------------- PROJECT EULER PROBLEM NO. 021 - Amicable numbers --------------------;
;                                                                                            ;  
;   Let d(n) be defined as the sum of proper divisors of n (numbers less than n which divide ;
;   evenly into n).                                                                          ;
;                                                                                            ;
;   If d(a) = b and d(b) = a, where a â‰  b, then a and b are an amicable pair and each of   ;
;   a and b are called amicable numbers.                                                     ;
;                                                                                            ;
;   For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 and 110;  ;
;   therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4, 71 and 142;              ;
;   so d(284) = 220.                                                                         ;
;                                                                                            ;
;   Evaluate the sum of all the amicable numbers under 10000.                                ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   for this problem we will develop the function 'sum_divs' to sum up the proper divisors
;   this function uses the same algorithm of the function 'num_divs' which we used in 
;   problem 12

%include "euler.inc"

%define LIMIT 10000  

global  main

    section .data  
sumdiv:     dq 0

    section .text    
main:
    enter   0,0
    
    ; determine add the amicable numbers
    mov     rcx, 0
ami_start:
    inc     rcx
    cmp     rcx, LIMIT
    jge     ami_end
    mov     rdi, rcx
    call    sum_divs
    cmp     rax, LIMIT
    jge     ami_start
    cmp     rax, rcx
    jle     ami_start
    mov     rbx, rax
    mov     rdi, rax
    call    sum_divs
    cmp     rax, rcx
    jne     ami_start
    add     qword [sumdiv], rcx
    add     qword [sumdiv], rbx
    jmp     ami_start
ami_end:        
    
    print_answer "021", INTEGER, [sumdiv]
    
    leave
    xor     rax, rax
    ret