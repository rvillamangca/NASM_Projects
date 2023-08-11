;------------------------ PROJECT EULER PROBLEM NO. 022 - Names scores ----------------------;
;                                                                                            ;  
;   Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing   ;
;   over five-thousand first names, begin by sorting it into alphabetical order. Then        ;
;   working out the alphabetical value for each name, multiply this value by its alpha-      ;
;   betical position in the list to obtain a name score.                                     ;
;                                                                                            ;
;   For example, when the list is sorted into alphabetical order, COLIN, which is worth      ;
;   3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. So, COLIN would obtain a       ;
;   score of 938 x 53 = 49714.                                                               ;
;                                                                                            ;
;   What is the total of all the name scores in the file?                                    ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   this problem is relatively difficult to do in assembly, because assembly does not have
;   native way for sorting arrays, much more sorting "string" arrays. however, getting the
;   "scores" of strings are quite straight forward in assembly because characters are stored
;   as ascii bytes. we shall follow the following steps:
;
;       1.  for convenience we precalculated that there are 5,163 names inside the given
;           names file. the longest name is 11 characters long.
;       2.  we have modified the "names.txt" file removing all quotation marks.
;       3.  we shall use the NASM pseudocode "incbin" to export the name text file.
;       4.  we shall transfer the names into a fixed length string array. we shall give
;           each string a length of 12 characters. at the same time, we shall deduct 64
;           to each character to convert it to values with A = 1, B = 2, etc.
;       5.  we shall sort the fixed-length string array, using bubble sort.
;       6.  we then calculate the names scores and total it as required in this problem.


%include "euler.inc"

%define NUM_NAMES 5163
%define LEN_NAMES 12 

global  main

    section .data
names_let:      incbin "p022_names_no_quotes.txt"
names_val:   times NUM_NAMES * LEN_NAMES db 0
sum_scores:     dq 0

    section .text    
main:
    enter   0,0
    
    ; convert the "letter" names to fixed-length "value" names 
    mov     r10, -1 
    mov     r11, -1    
copy_start:
    inc     r10
    cmp     r10, NUM_NAMES
    jge     copy_end
    mov     r12, r10
    imul    r12, LEN_NAMES
    add     r12, names_val
    dec     r12
cstart:
    inc     r11
    mov     r13, r11
    add     r13, names_let
    mov     al, [r13]
    cmp     al, ","
    je      copy_start
    sub     al, 64
    inc     r12
    mov     [r12], al
    jmp     cstart  
copy_end:    

    ; sort "names_val" using "bubble sort"
    mov     r10, NUM_NAMES-1
sort_start:
    dec     r10
    cmp     r10, 0
    jl      sort_end
    mov     r11, -1
sstart:
    inc     r11
    cmp     r11, r10
    jg      sort_start
    mov     r12, r11
    mov     r13, r11
    inc     r13
    imul    r12, LEN_NAMES
    imul    r13, LEN_NAMES
    add     r12, names_val
    add     r13, names_val
    cmp_alpha r12, r13, LEN_NAMES-1
    cmp     rax, 1
    je      sstart 
    swap_str r12, r13, LEN_NAMES-1
    jmp     sstart 
sort_end:

    ; sum up the scores
    mov     rcx, NUM_NAMES
summation:
    mov     rax, rcx
    mov     rdi, rcx
    dec     rdi
    imul    rdi, LEN_NAMES
    add     rdi, names_val
    add_byte_array rbx, rdi, LEN_NAMES-1
    mul     rbx
    add     qword [sum_scores], rax
    loop    summation
    
    print_answer "022", INTEGER, [sum_scores]
    
    leave
    xor     rax, rax
    ret