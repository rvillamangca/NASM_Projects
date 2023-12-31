; ------------------- PROJECT EULER PROBLEM NO. 002 - Even Fibonacci Numbers ----------------;
;                                                                                            ;
;   Each new term in the Fibonacci sequence is generated by adding the previous two terms.   ;
;   By starting with 1 and 2, the first 10 terms will be:                                    ;
;                                                                                            ;
;                          1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...                            ;
;                                                                                            ;
;   By consi dering the terms in the Fibonacci sequence whose values do not exceed four      ;
;   million, find the sum of the even-valued terms.                                          ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;

%include "euler.inc"

%define LIMIT 4000000

global  main

    section .text    
main:
    enter   0,0
    
    ; NOTE: a fibonacci number is even if and only if its rank is a multiple of '3'
    
    ; get the rank of the fibonacci number nearest but less than LIMIT
    mov     rdi, LIMIT
    call    fibo_rank
    
    ; divide the rank by '3' (see NOTE above)
    mov     rbx, 3
    xor     rdx, rdx
    div     rbx
    
    ; take the sum of even fibonaccis (i.e. all with ranks divisible by '3', see NOTE above)
    mov     r12, rax        ; 'rax' contains the rank of LIMIT divided by '3'
    xor     r13, r13
    mov     rcx, rax        ; below loop iterates from '(rank of LIMIT)/3' to '0'
    add_fibo:
        mov     rax, r12
        mul     rbx         ; 'rbx' contains the number '3'
        mov     rdi, rax
        call    fibo_num
        add     r13, rax
        dec     r12
        loop    add_fibo
    
    print_answer "002", INTEGER, r13
    
    leave
    xor     rax, rax
    ret
