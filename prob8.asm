; --------------- PROJECT EULER PROBLEM NO. 008 - Largest product in a series ---------------;
;                                                                                            ;
;   The four adjacent digits in the 1000-digit number that have the greatest product are     ;
;   9 x 9 x 8 x 9 = 5832.                                                                    ;               
;                                                                                            ;
;       73167176531330624919225119674426574742355349194934                                   ;
;       96983520312774506326239578318016984801869478851843                                   ;
;       85861560789112949495459501737958331952853208805511                                   ;
;       12540698747158523863050715693290963295227443043557                                   ;
;       66896648950445244523161731856403098711121722383113                                   ;
;       62229893423380308135336276614282806444486645238749                                   ;
;       30358907296290491560440772390713810515859307960866                                   ;
;       70172427121883998797908792274921901699720888093776                                   ;
;       65727333001053367881220235421809751254540594752243                                   ;
;       52584907711670556013604839586446706324415722155397                                   ;
;       53697817977846174064955149290862569321978468622482                                   ;
;       83972241375657056057490261407972968652414535100474                                   ;
;       82166370484403199890008895243450658541227588666881                                   ;
;       16427171479924442928230863465674813919123162824586                                   ;
;       17866458359124566529476545682848912883142607690042                                   ;
;       24219022671055626321111109370544217506941658960408                                   ;
;       07198403850962455444362981230987879927244284909188                                   ;
;       84580156166097919133875499200524063689912560717606                                   ;
;       05886116467109405077541002256983155200055935729725                                   ;
;       71636269561882670428252483600823257530420752963450                                   ;
;                                                                                            ;
;   Find the thirteen adjacent digits in the 1000-digit number that have the greatest        ; 
;   product. What is the value of this product?                                              ;
;                                                                                            ;
; -------------------------------------------------------------------------------------------;
 
; NOTE: there is no other way to do this than 'brute-force'. however, we can optimize by 
;       skipping any set that contains '0' as the product will, ofcourse, be zero.



%include "euler.inc"

global  main

    section .data
max_prd13:      dq 0
num_array:      db "73167176531330624919225119674426574742355349194934"
                db "96983520312774506326239578318016984801869478851843"
                db "85861560789112949495459501737958331952853208805511"
                db "12540698747158523863050715693290963295227443043557"
                db "66896648950445244523161731856403098711121722383113"
                db "62229893423380308135336276614282806444486645238749"
                db "30358907296290491560440772390713810515859307960866"
                db "70172427121883998797908792274921901699720888093776"
                db "65727333001053367881220235421809751254540594752243"
                db "52584907711670556013604839586446706324415722155397"
                db "53697817977846174064955149290862569321978468622482"
                db "83972241375657056057490261407972968652414535100474"
                db "82166370484403199890008895243450658541227588666881"
                db "16427171479924442928230863465674813919123162824586"
                db "17866458359124566529476545682848912883142607690042"
                db "24219022671055626321111109370544217506941658960408"
                db "07198403850962455444362981230987879927244284909188"
                db "84580156166097919133875499200524063689912560717606"
                db "05886116467109405077541002256983155200055935729725"
                db "71636269561882670428252483600823257530420752963450" 
len_array:      equ $-num_array  

    section .text    
main:
    enter   0,0
    
    ; convert the num_array string to integer
    mov     r13, num_array
    mov     rcx, len_array
    dec     r13
convert:
    inc     r13
    chr2int byte [r13]
    loop    convert
    
    ; find the maximum product
    mov     r13, num_array
    mov     rcx, len_array-13
    dec     r13
multiply:
    inc     r13
    mov     rdi, r13
    call    prod_13
    cmp     rax, [max_prd13]
    jle     repeat
    mov     qword [max_prd13], rax
repeat:
    loop    multiply  
                                                
    print_answer "008", INTEGER, [max_prd13]
    
    leave 
    xor     rax, rax
    ret
