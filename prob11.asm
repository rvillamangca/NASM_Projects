; ---------------- PROJECT EULER PROBLEM NO. 011 - Largest product in a grid ----------------;
;                                                                                            ;
;   In the 20x20 grid below, four numbers along a diagonal line have been marked in red.     ;               
;                                                                                            ;
;       08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08                          ;
;       49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00                          ;
;       81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65                          ;
;       52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91                          ;
;       22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80                          ;
;       24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50                          ;
;       32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70                          ;
;       67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21                          ;
;       24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72                          ;
;       21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95                          ;
;       78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92                          ;
;       16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57                          ;
;       86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58                          ;
;       19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40                          ;
;       04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66                          ;
;       88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69                          ;
;       04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36                          ;
;       20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16                          ;
;       20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54                          ;
;       01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48                          ;
;                                                                                            ;
;   What is the greatest product of four adjacent numbers in the same direction (up, down,   ; 
;   left, right, or  diagonally) in the 20x20 grid?                                          ; 
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
 
; NOTE: there is no other way to do this than 'brute-force'. the only difficulty we have here
;       is accessing the 20x20 matrix grid. assembly is only able to assess arrays in one
;       dimension. we therefore, developed macros to address this issue.

%include "euler.inc"

global  main

    section .data
nums:   dq  08, 02, 22, 97, 38, 15, 00, 40, 00, 75, 04, 05, 07, 78, 52, 12, 50, 77, 91, 08,\
            49, 49, 99, 40, 17, 81, 18, 57, 60, 87, 17, 40, 98, 43, 69, 48, 04, 56, 62, 00,\
            81, 49, 31, 73, 55, 79, 14, 29, 93, 71, 40, 67, 53, 88, 30, 03, 49, 13, 36, 65,\
            52, 70, 95, 23, 04, 60, 11, 42, 69, 24, 68, 56, 01, 32, 56, 71, 37, 02, 36, 91,\
            22, 31, 16, 71, 51, 67, 63, 89, 41, 92, 36, 54, 22, 40, 40, 28, 66, 33, 13, 80,\
            24, 47, 32, 60, 99, 03, 45, 02, 44, 75, 33, 53, 78, 36, 84, 20, 35, 17, 12, 50,\
            32, 98, 81, 28, 64, 23, 67, 10, 26, 38, 40, 67, 59, 54, 70, 66, 18, 38, 64, 70,\
            67, 26, 20, 68, 02, 62, 12, 20, 95, 63, 94, 39, 63, 08, 40, 91, 66, 49, 94, 21,\
            24, 55, 58, 05, 66, 73, 99, 26, 97, 17, 78, 78, 96, 83, 14, 88, 34, 89, 63, 72,\
            21, 36, 23, 09, 75, 00, 76, 44, 20, 45, 35, 14, 00, 61, 33, 97, 34, 31, 33, 95,\
            78, 17, 53, 28, 22, 75, 31, 67, 15, 94, 03, 80, 04, 62, 16, 14, 09, 53, 56, 92,\
            16, 39, 05, 42, 96, 35, 31, 47, 55, 58, 88, 24, 00, 17, 54, 24, 36, 29, 85, 57,\
            86, 56, 00, 48, 35, 71, 89, 07, 05, 44, 44, 37, 44, 60, 21, 58, 51, 54, 17, 58,\
            19, 80, 81, 68, 05, 94, 47, 69, 28, 73, 92, 13, 86, 52, 17, 77, 04, 89, 55, 40,\
            04, 52, 08, 83, 97, 35, 99, 16, 07, 97, 57, 32, 16, 26, 26, 79, 33, 27, 98, 66,\
            88, 36, 68, 87, 57, 62, 20, 72, 03, 46, 33, 67, 46, 55, 12, 32, 63, 93, 53, 69,\
            04, 42, 16, 73, 38, 25, 39, 11, 24, 94, 72, 18, 08, 46, 29, 32, 40, 62, 76, 36,\
            20, 69, 36, 41, 72, 30, 23, 88, 34, 62, 99, 69, 82, 67, 59, 85, 74, 04, 36, 16,\
            20, 73, 35, 29, 78, 31, 90, 01, 74, 31, 49, 71, 48, 86, 81, 16, 23, 57, 05, 54,\
            01, 70, 54, 71, 83, 51, 54, 69, 16, 92, 33, 48, 61, 43, 52, 01, 89, 19, 67, 48 
sz:         equ   20
max_prod:    dq    0   

    section .text    
main:
    enter   0,0
    
    ; convert the integer array to a 2D-matrix
    arr2mat _qword, nums, sz, sz
    
    ; test horizontal products
    mov     rbx, -1
hout_strt:
    inc     rbx
    cmp     rbx, sz
    jge     hout_end
    mov     rcx, -1
hin_strt:
    inc     rcx
    cmp     rcx, sz-4
    jg      hout_strt
    mov     rdx, -1
    mov     rax, 1
hin_prod:
    inc     rdx
    cmp     rdx, 4
    jge     hin_end
    add     rdx, rcx
    mulm2r  rax, nums(rbx,rdx)
    sub     rdx, rcx
    jmp     hin_prod
hin_end:
    cmp     rax, [max_prod]
    jl      hin_strt
    mov     qword [max_prod], rax
    jmp     hin_strt
hout_end:

    ; test vertical products
    mov     rbx, -1
vout_strt:
    inc     rbx
    cmp     rbx, sz
    jge     vout_end
    mov     rcx, -1
vin_strt:
    inc     rcx
    cmp     rcx, sz-4
    jg      vout_strt
    mov     rdx, -1
    mov     rax, 1
vin_prod:
    inc     rdx
    cmp     rdx, 4
    jge     vin_end
    add     rdx, rcx
    mulm2r  rax, nums(rdx,rbx)
    sub     rdx, rcx
    jmp     vin_prod
vin_end:
    cmp     rax, [max_prod]
    jl      vin_strt
    mov     qword [max_prod], rax
    jmp     vin_strt
vout_end: 

   ; test diagonal down-right products
    mov     rbx, -1
drout_strt:
    inc     rbx
    cmp     rbx, sz-4
    jg      drout_end
    mov     rcx, -1
drin_strt:
    inc     rcx
    cmp     rcx, sz-4
    jg      drout_strt
    mov     rdx, -1
    mov     r10, -1
    mov     rax, 1
drin_prod:
    inc     rdx
    inc     r10
    cmp     r10, 4
    jge     drin_end
    add     rdx, rbx
    add     r10, rcx
    mulm2r  rax, nums(rdx,r10)
    sub     rdx, rbx
    sub     r10, rcx
    jmp     drin_prod
drin_end:
    cmp     rax, [max_prod]
    jl      drin_strt
    mov     qword [max_prod], rax
    jmp     drin_strt
drout_end:   

; test diagonal down-left products
    mov     rbx, -1
dlout_strt:
    inc     rbx
    cmp     rbx, sz-4
    jg      dlout_end
    mov     rcx, 4
dlin_strt:
    inc     rcx
    cmp     rcx, sz
    jge      dlout_strt
    mov     rdx, -1
    mov     r10, -1
    mov     rax, 1
dlin_prod:
    inc     rdx
    inc     r10
    cmp     r10, 4
    jge     dlin_end
    add     rdx, rbx
    sub     r10, rcx
    neg     r10
    mulm2r  rax, nums(rdx,r10)
    sub     rdx, rbx
    neg     r10
    add     r10, rcx
    jmp     dlin_prod
dlin_end:
    cmp     rax, [max_prod]
    jl      dlin_strt
    mov     qword [max_prod], rax
    jmp     dlin_strt
dlout_end:
                                              
    print_answer "011", INTEGER, [max_prod]
    
    leave 
    xor     rax, rax
    ret
