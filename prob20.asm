;---------------------- PROJECT EULER PROBLEM NO. 20 - Factorial digit sum ---------------------;
;                                                                                            ;
;                                                                                            ;  
;   2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.                        ;
;                                                                                            ;
;   What is the sum of the digits of the number 2^1000?                                      ;   
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   this is very similar with problem 16, so we will follow the same approach. we notice that:
;       
;   1.  100! has, at most, 158 digits, i.e. log10(100!) + 1
;   2.  in problem 16 we use the full 63-bits (18-digits) for each segment of the "power" array,
;       we can't do that here because we have to multiply for up to 100. hence we will use
;       16-digit segments instead (i.e. log10(10^18 / 100))
;   3.  this means we need only 10 segments (i.e. 158 / 16)
;   4.  20! < 2^63 we will need to calculate for 20! before we check for carry
;   5.  unlike problem 16 where we wait for 3 multiplications before we normalize, we will normalize
;       on every multiplications here. however, to optimize we will skip multiplication and norma-
;       lization when there was no carry and the value of the segment is zero.


%include "euler.inc"

%define     NORM 10000000000000000
%define     ARRLEN 10
%define     ARREND (ARRLEN-1)*8

global  main

    section .data
power:      dq 1
            times ARRLEN-1 dq 0
sumdig:     dq 0        

    section .text    
main:
    enter   0,0
    
    ; first 20! (see item 4, above)
    mov     rcx, 1
    mov     rax, [power]
frststart:
    inc     rcx
    cmp     rcx, 20
    jg      frstend
    mul     rcx
    jmp     frststart
frstend:            
    mov     rbx, NORM
    xor     rdx, rdx
    div     rbx
    mov     qword [power+8], rax
    mov     qword [power], rdx
    
    ; next 21! to 100!
    mov     rdi, NORM
    mov     rcx, 20
nexstart:
    inc     rcx
    cmp     rcx, 100
    jg      nexend
    mov     rbx, -1
    mov     rsi, 0
mulstart:
    inc     rbx
    cmp     rbx, ARRLEN
    jge     mulend
    mov     rax, [power+rbx*8]
    mul     rcx
    add     rax, rsi
    xor     rdx, rdx
    div     rdi
    mov     qword [power+rbx*8], rdx
    mov     rsi, rax
    jmp     mulstart
mulend:
    jmp     nexstart
nexend: 

    ; get sum of digits
    mov     rcx, ARRLEN
sumstart:
    mov     rdi, [power+(rcx-1)*8]
    call    sum_digits
    add     qword [sumdig], rax
    loop    sumstart
        
    print_answer "020", INTEGER, [sumdig]
    
    leave
    xor     rax, rax
    ret