;-------------------- PROJECT EULER PROBLEM NO. 017 - Number letter counts ------------------;
;                                                                                            ; 
;   If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there  ; 
;   are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.                                        ;
;                                                                                            ;
;   If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words,    ;
;   how many letters would be used?                                                          ;
;                                                                                            ;
;   NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two)     ;  
;   contains 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of    ;
;   "and" when writing out numbers is in compliance with British usage.                      ;
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   this involves counting lengths of strings which is quite easy in assembly


%include "euler.inc"

global  main

    section .data

units:      db 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'
unitslen    equ $ - units

teens:      db 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'
teenslen    equ $ - teens

tys:        db 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'
tyslen      equ $ - tys

hun:        db 'hundred'
hunlen      equ $ - hun

nd:         db 'and'
andlen      equ $ - nd

thou:       db 'one', 'thousand'
thoulen     equ $ - thou

    section .text    
main:
    enter   0,0
    
    ; from 1 to 99
    mov     rbx, 9 * unitslen + teenslen + 10 * tyslen
    
    ; 100, 200, 300 ... 900
    mov     rcx, unitslen + 9 * hunlen
    
    ; totals
    imul    rbx, 10
    imul    rcx, 100
    mov     rax, 9 * 99 * andlen + thoulen
    add     rax, rbx
    add     rax, rcx
        
    print_answer "017", INTEGER, rax
    
    leave
    xor     rax, rax
    ret