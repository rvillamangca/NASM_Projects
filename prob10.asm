; --------------------- PROJECT EULER PROBLEM NO. 010 - Summation of primes -----------------;
;                                                                                            ;
;   The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.                                    ;
;                                                                                            ;
;   Find the sum of all the primes below two million.                                        ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
 
; NOTE: we are not able to make use of the 'sieve of erathosthenes' we have implemented in 
;       problem #7, because of the limit of the number of elements an array is allowed to have
;       instead we have made an "isprime" function based on the 'miller-rabin primality test'

%include "euler.inc"

%define LIMIT 2000000

global  main

    section .data
sum:    dq 2            ; there is only one even prime: "2", we will sum only the odd primes       

    section .text    
main:
    enter       0,0
    
    ; start summing the primes
    mov         rbx, 1
start:
    add         rbx, 2
    cmp         rbx, LIMIT
    jg          end
    mov         rdi, rbx
    call        is_prime
    cmp         rax, TRUE
    jne         start
    add         qword [sum], rbx
    jmp         start
end:                                                
    print_answer "010", INTEGER, [sum]
    
    leave 
    xor     rax, rax
    ret
