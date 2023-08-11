;------------------ PROJECT EULER PROBLEM NO. 014 - Longest Collatz sequence ----------------;
;                                                                                            ;                 
;   The following iterative sequence is defined for the set of positive integers:            ;
;                                                                                            ;
;   n -> n/2 (n is even)                                                                     ;
;   n -> 3n + 1 (n is odd)                                                                   ;
;                                                                                            ;
;   Using the rule above and starting with 13, we generate the following sequence:           ;
;   13 -> 40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1                                      ;
;                                                                                            ;
;   It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. ; 
;   Although it has not been proved yet (Collatz Problem), it is thought that all starting   ;
;   numbers finish at 1.                                                                     ;
;                                                                                            ;
;   Which starting number, under one million, produces the longest chain?                    ;
;                                                                                            ;
;   NOTE: Once the chain starts the terms are allowed to go above one million.               ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   for this problem since the limit is relatively small (1,000,000) we will just use brute-
;   force to calculate the length of the collatz sequence chain

%include "euler.inc"

%define LIMIT 1000000  

global  main

    section .data  
maxlen:     dq 0
target:     dq 0

    section .text    
main:
    enter   0,0
    
    mov     rcx, LIMIT
start:
    mov     rdi, rcx
    call    collatz_len
    cmp     rax, [maxlen]
    jle     repeat
    mov     qword [maxlen], rax
    mov     qword [target], rcx
repeat:
    loop    start
    
    print_answer "014", INTEGER, [target]
    
    leave
    xor     rax, rax
    ret