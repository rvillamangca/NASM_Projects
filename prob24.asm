;------------------ PROJECT EULER PROBLEM NO. 024 - Lexicographic permutations --------------;
;                                                                                            ;  
;   A permutation is an ordered arrangement of objects. For example, 3124 is one possible    ;
;   permutation of the digits 1, 2, 3 and 4. If all of the permutations are listed           ;
;   numerically or alphabetically, we call it lexicographic order. The lexicographic         ;
;   permutations of 0, 1 and 2 are:                                                          ;
;                                                                                            ;
;                           012   021   102   120   201   210                                ;
;                                                                                            ;
;   What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7,    ;
;   8 and 9?                                                                                 ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   there is an article in wikipedia showing an algorithm to generate lexicographic
;   permutations (https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order). 
;   however, we will not use this because it needs to traverse through all the smaller
;   permutations to get to the target. this is wasteful and slow. instead, we will skip
;   certain permutations we don't need. we take note of the following:
;
;       1. the number of permutations of 'n' different objects is 'n!'. 
;       2. lexicographic permutation set is sorted in increasing order. 

%include "euler.inc"

%define LEN 10
%define TARGET 1000000-1    ; we consider "0123456789" as the 1st permutation so
                            ; we will count only from the 2nd to the 1-millionth

global  main

    section .data
base:       db "0123456789", 0
lexi:       times LEN+1 db 0    ; we add one more zero so we can print it
count:      dq 0

    section .text    
main:
    enter   0,0
    
    mov     rcx, LEN            ; lexi position counter
start:
    mov     r10, -1             ; base position counter
    mov     rdi, rcx
    dec     rdi
    call    factorial
    mov     r11, rax            ; adder
build_lexi:
    inc     r10    
    cmp     r10, LEN
    jge     restart
    mov     bl, [base+r10]
    cmp     bl, 0               ; we skip those digits that are marked with zero
    je      build_lexi
    mov     rax, [count]
    add     rax, r11
    cmp     rax, TARGET   
    jg      blexi
    mov     qword [count], rax
    jmp     build_lexi
blexi:
    mov     rax, LEN
    sub     rax, rcx
    xchg    [lexi+rax], bl
    xchg    [base+r10], bl
restart:
    loop    start
    
    print_answer "024", STRING, lexi
    
    leave
    xor     rax, rax
    ret