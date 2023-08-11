; -------------------- PROJECT EULER PROBLEM NO. 005 - Smallest multiple --------------------;
;                                                                                            ;
;   2520 is the smallest number that can be divided by each of the numbers from 1 to 10      ;
;   without any remainder.                                                                   ;
;                                                                                            ;
;   What is the smallest positive number that is evenly divisible by all of the numbers      ;
;   from 1 to 20?                                                                            ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
    
; NOTE: this is so simple, that we can do this by hand. all it takes is to multiply
;       all the highest powers of prime up to 20. for 2 the highest power is 16.
;       for 3 it is 9. for primes >= 5, the highest power is the prime themselves.

%include "euler.inc"

global  main

    section .data
ans:       dq 16*9*5*7*11*13*17*19  ; product of highest power of primes up to 20

    section .text    
main:
    enter   0,0         
                
    print_answer "005", INTEGER, [ans]
    
    leave 
    xor     rax, rax
    ret
