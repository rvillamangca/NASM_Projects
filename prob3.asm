; ------------------- PROJECT EULER PROBLEM NO. 003 - Largest prime factor ------------------;
;                                                                                            ;
;   The prime factors of 13195 are 5, 7, 13 and 29.                                          ;
;                                                                                            ;
;   What is the largest prime factor of the number 600851475143?                             ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;

%include "euler.inc"

%define NUMBER 600851475143

global  main

    section .data  
test_num:   dq 0
cand:       dq 1

    section .text    
main:
    enter   0,0
    
    ; NOTE: we could do a 'sieve of eratosthenes' get all the primes less than or equal to the NUMBER
    ;       but this may not be the most efficient solution because we don't know up to when we will go. 
    ;       the possible largest possible candidate is 200283825047 (i.e. NUMBER/3), we should go down
    ;       from that until we found our target. but before that to build the sieve we have to iterate
    ;       from 2 to 775146 (i.e. sqrt of NUMBER). this is too much work, so we decided not to use sieving.
    ;
    ;       A better algorithm, in our opinion, is to test divisibility of NUMBER to all numbers from 2 
    ;       to sqrt(NUMBER), the first number (p) that will divide NUMBER is the smallest prime divisor 
    ;       of NUMBER. the quotient of NUMBER over p (testnum), is the next number we will test. we will test
    ;       divisibility from p+1 to sqrt(testnum), which is a smaller range than before. we will do this
    ;       until testnum=1, which means that previous testnum is the largest prime factor we are looking for.
    
        mov     rax, NUMBER
        mov     qword [test_num], rax       ; saves our initial test number which is NUMBER.
        mov     rbx, 3                      ; iterates with odd numbers from 3 to sqrt(test_lim)
    test_prime:
        mov     rax, qword [test_num]
        xor     rdx, rdx
        div     rbx
        cmp     rdx, 0                      ; test divisibility
        je      cont_test                   ; if divisible continue testing
        jmp     rep_test                    ; if not then repeat testing
    cont_test:
        mov     qword [cand], rbx           ; update the value of the candidate
        cmp     rax, 1                      ; test if rax is equal to '1'
        je      end_test                    ; if it is then we've found our answer so stop the test
    rem_cand:                               ; remove all 'cand' factors in 'rax'
        mov     r12, rax                    ; preserve the value of 'rax'      
        xor     rdx, rdx
        div     rbx                         
        cmp     rdx, 0                      ; test divisibility
        jne     loop_back                   ; if not divisible then repeat testing
        cmp     rax, 1                      ; if it divisible, test if rax is equal to '1'
        je      end_test                    ; if it is then we've found our answer so stop the test
        jne     rem_cand                    ; if not remove more factors
    loop_back:
        mov     qword [test_num], r12       ; update the value of test_num and
    rep_test:
        times 2 inc rbx                     ; increment counter by 2 and
        jmp     test_prime                  ; loop back to test
    end_test:
                
    print_answer "003", INTEGER, [cand]
    
    leave 
    xor     rax, rax
    ret
