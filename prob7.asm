; ------------------------ PROJECT EULER PROBLEM NO. 007 - 10001st prime --------------------;
;                                                                                            ;
;   By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the      ;
;   6th prime is 13.                                                                         ;
;                                                                                            ;
;   What is the 10001st prime number?                                                        ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
 
; NOTE: in this problem we implemented the 'sieve of erathosthenes' to create an array of primes
;       the 'prime_sieve' functions modifies the array such that if [primes+n] = 1, then 'n' is
;       a prime, else if [primes+n] = 0, then 'n' is composite.
;       we wil also make use of 'prime number theorem' (see https://en.wikipedia.org/wiki
;       /Prime_number_theorem#Approximations_for_the_nth_prime_number), to estimate the length
;       of our primes array which exceeds '10001' but very near to it.
;       the formula according to that wikipedia page is: nth_prime < n * (ln(n) + ln(ln(n)))

%include "euler.inc"

%define TARGET 10001
%define LIMIT 114000    ; according to the above formula, this is a sufficient limit

global  main

    section .data
primes:     db 0,0          ; this array format is required by the 'prime_sieve' function
            times LIMIT-1 db 1

count:      dq 0            ; our prime counter          

    section .text    
main:
    enter   0,0
    
    ; invoke 'prime_sieve' function
    mov     rdi, LIMIT
    mov     rsi, primes
    call    prime_sieve  

    ; determine the 10001st prime  
    mov     rbx, primes
count_loop:
    inc     rbx
    cmp     byte [rbx], 1
    jne     count_loop
    inc     qword [count]
    cmp     qword [count], TARGET
    je      end_loop
    jmp     count_loop
end_loop:
    sub     rbx, primes 
                                                
    print_answer "007", INTEGER, rbx
    
    leave 
    xor     rax, rax
    ret
