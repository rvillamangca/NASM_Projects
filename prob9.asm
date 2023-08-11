; --------------- PROJECT EULER PROBLEM NO. 009 - Special Pythagorean triplet ---------------;
;                                                                                            ;
;   A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,           ;
;   a^2 + b^2 = c^2                                                                          ;
;                                                                                            ;
;   For example, 32 + 42 = 9 + 16 = 25 = 52.                                                 ;
;                                                                                            ;
;   There exists exactly one Pythagorean triplet for which a + b + c = 1000.                 ;
;   Find the product abc.                                                                    ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
 
; NOTE: for this problem we have developed a function generate pythagorean triples using
;       two odd integers to generate. in order to be primitive, the two odd integers
;       must be co-prime, so we also developed a function to calculate gcd.



%include "euler.inc"

global  main

    section .data
triple:     dq 0,0,0      ; this will store the pythagorean triples to test

    section .text    
main:
    enter   0,0
    
    mov     r12, 1
outer:
    add     r12, 2
    mov     r13, r12
inner:
    sub     r13, 2
    cmp     r13, 1
    jl      outer
    mov     rdi, r12
    mov     rsi, r13
    call    gcd
    cmp     rax, 1
    jne     inner
    mov     rdi, r12
    mov     rsi, r13
    mov     r9, triple
    call    pyth_triple
    mov     rbx, [triple]
    add     rbx, [triple+8]
    add     rbx, [triple+16]
    mov     rax, 1000
    xor     rdx, rdx
    div     rbx
    cmp     rdx, 0
    je      end
    jmp     inner
end:
    mov     rbx, rax
    times   2 mul rbx
    mul     qword [triple]
    mul     qword [triple+8]
    mul     qword [triple+16]
                                                                                      
    print_answer "009", INTEGER, rax
    
    leave 
    xor     rax, rax
    ret
