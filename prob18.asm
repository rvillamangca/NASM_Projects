;--------------------- PROJECT EULER PROBLEM NO. 018 - Maximum path sum I -------------------;
;                                                                                            ;
;   By starting at the top of the triangle below and moving to adjacent numbers on the row   ;
;   below, the maximum total from top to bottom is 23.                                       ;
;                                                                                            ;
;               3                                                                            ;
;               7 4                                                                          ;
;               2 4 6                                                                        ;
;               8 5 9 3                                                                      ;        
;                                                                                            ;
;   That is, 3 + 7 + 4 + 9 = 23.                                                             ;
;                                                                                            ;
;   Find the maximum total from top to bottom of the triangle below:                         ;
;                                                                                            ;
;       75                                                                                   ;
;       95 64                                                                                ;
;       17 47 82                                                                             ;
;       18 35 87 10                                                                          ;
;       20 04 82 47 65                                                                       ;
;       19 01 23 75 03 34                                                                    ;
;       88 02 77 73 07 63 67                                                                 ;
;       99 65 04 28 06 16 70 92                                                              ;
;       41 41 26 56 83 40 80 70 33                                                           ;
;       41 48 72 33 47 32 37 16 94 29                                                        ;
;       53 71 44 65 25 43 91 52 97 51 14                                                     ;
;       70 11 33 28 77 73 17 78 39 68 17 57                                                  ;
;       91 71 52 38 17 14 91 43 58 50 27 29 48                                               ;
;       63 66 04 68 89 53 67 30 73 16 69 87 40 31                                            ;
;       04 62 98 27 23 09 70 98 73 93 38 53 60 04 23                                         ;
;                                                                                            ;
;   NOTE: As there are only 16384 routes, it is possible to solve this problem by trying     ;
;   every route. However, Problem 67, is the same challenge with a triangle containing one-  ;
;   hundred rows; it cannot be solved by brute force, and requires a clever method! ;o)      ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;
 
; NOTE: we don't see any reason for the problem 'note' above because the solution is quite
;       obvious. we will make use of the 2D-matrix data structure we developed in problem 11.
;       however, we will pad the triangular matrix with zeros to convert it to the proper
;       rectangular matrix. we also need to make a 'max' function.

%include "euler.inc"

global  main

    section .data
nums:   dq  75, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00,\
            95, 64, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00,\
            17, 47, 82, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00,\
            18, 35, 87, 10, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00,\
            20, 04, 82, 47, 65, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00,\
            19, 01, 23, 75, 03, 34, 00, 00, 00, 00, 00, 00, 00, 00, 00,\
            88, 02, 77, 73, 07, 63, 67, 00, 00, 00, 00, 00, 00, 00, 00,\
            99, 65, 04, 28, 06, 16, 70, 92, 00, 00, 00, 00, 00, 00, 00,\
            41, 41, 26, 56, 83, 40, 80, 70, 33, 00, 00, 00, 00, 00, 00,\
            41, 48, 72, 33, 47, 32, 37, 16, 94, 29, 00, 00, 00, 00, 00,\
            53, 71, 44, 65, 25, 43, 91, 52, 97, 51, 14, 00, 00, 00, 00,\
            70, 11, 33, 28, 77, 73, 17, 78, 39, 68, 17, 57, 00, 00, 00,\
            91, 71, 52, 38, 17, 14, 91, 43, 58, 50, 27, 29, 48, 00, 00,\
            63, 66, 04, 68, 89, 53, 67, 30, 73, 16, 69, 87, 40, 31, 00,\
            04, 62, 98, 27, 23, 09, 70, 98, 73, 93, 38, 53, 60, 04, 23
 
sz:         equ   15
max_sum:    dq    0   

    section .text    
main:
    enter   0,0
    
    ; convert the integer array to a 2D-matrix
    arr2mat _qword, nums, sz, sz
    
    ; start at the 14th row
    mov     rcx, 14
outer:
    dec     rcx
    cmp     rcx, 0
    jl      end_outer
    mov     rbx, -1
inner:
    inc     rbx
    cmp     rbx, rcx
    jg      end_inner
    mov     r10, rcx
    inc     r10
    mov     r11, rbx
    movm2r  r12, nums(r10,r11)
    inc     r11
    movm2r  r13, nums(r10,r11)
    mov     rdi, r12
    mov     rsi, r13
    call    max
    addr2m  nums(rcx,rbx), rax
    jmp     inner
end_inner:
    jmp     outer
end_outer:

    movm2r  rax, nums(0,0) 
                                              
    print_answer "018", INTEGER, rax
    
    leave 
    xor     rax, rax
    ret
