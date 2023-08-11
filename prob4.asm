; ---------------- PROJECT EULER PROBLEM NO. 004 - Largest palindrome product ---------------;
;                                                                                            ;
;   A palindromic number reads the same both ways. The largest palindrome made from the      ;
;   product of two 2-digit numbers is 9009 = 91  99.                                         ;
;                                                                                            ;
;   Find the largest palindrome made from the product of two 3-digit numbers.                ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
  
; NOTE: there is two ways to approach this. one is to create palindromes and then
;       test them if they are products of two 3-digit numbers. The other way is to
;       multiply two 3-digit numbers, and test is their product is a palindrome.
;       we will do the former here.

%include "euler.inc"

global  main

    section .data
cand:       dq 0        ; holds the created palindrome
aa:          dq 10       ; first/last digit of palindrome
bb:          dq 10       ; second/second-to-last digit of palindrome
cc:          dq 10       ; middle digit/s of palindrome

    section .text    
main:
    enter   0,0
    
        ; test for 6-digit palindromes
    loop_a6:
        dec     qword [aa]
        mov     rdi, [aa]
    loop_b6:
        dec     qword [bb]
        mov     rsi, [bb]
    loop_c6:
        dec     qword [cc]
        mov     r9, [cc]
        call    make_pal6
        mov     qword [cand], rax
        mov     rdi, rax
        call    prob4_testdiv
        cmp     rax, 1
        je      end_loops        
        mov     rdi, [aa]
        mov     rsi, [bb]
        cmp     qword [cc], 0
        jg      loop_c6
        mov     qword [cc], 10
        cmp     qword [bb], 0
        mov     rdi, [aa]
        jg      loop_b6
        mov     qword [bb], 10
        cmp     qword [aa], 1
        jg      loop_a6 
        
        ; refresh the digits variable
        mov qword [aa], 10
        mov qword [bb], 10
        mov qword [cc], 10
        
        ; test for 5-digit palindromes
    loop_a5:
        dec     qword [aa]
        mov     rdi, [aa]
    loop_b5:
        dec     qword [bb]
        mov     rsi, [bb]
    loop_c5:
        dec     qword [cc]
        mov     r9, [cc]
        call    make_pal5
        mov     qword [cand], rax
        mov     rdi, rax
        call    prob4_testdiv
        cmp     rax, 1
        je      end_loops
        mov     rdi, [aa]
        mov     rsi, [bb]
        cmp     qword [cc], 0
        jg      loop_c5
        mov     qword [cc], 10
        cmp     qword [bb], 0
        mov     rdi, [aa]
        jg      loop_b5
        mov     qword [bb], 10
        cmp     qword [aa], 1
        jg      loop_a5     
        
    end_loops:         
                
    print_answer "004", INTEGER, [cand]
    
    leave 
    xor     rax, rax
    ret
