;---------------------- PROJECT EULER PROBLEM NO. 016 - Power digit sum ---------------------;
;                                                                                            ;
;                                                                                            ;  
;   2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.                        ;
;                                                                                            ;
;   What is the sum of the digits of the number 2^1000?                                      ;   
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   we will do this by brute-force. however, we notice the following:
;       
;   1.  2^1000 has, at most, 302 digits, i.e. 1000 * log10(2) + 1
;   2.  the largest power of 2 that can fit on an unsigned 64-bit address is 2^63 (not 2^64
;       because 2^64 will rollover to 0.
;   3.  63 bits (2^63) can safely accomodate 18-digit numbers
;   4.  this means that we only need 17 quadwords to represent 2^1000 (i.e. 302/18 = 16.78 = 17)
;   5.  the largest 18-digit integer is (10^18-1). since, (10^18-1)*8 < 2^63, we can multiply
;       each member of the 17 quadword arrays by 2, three times, before we check for carry
;       overflow
;   6.  since we will be starting with one (2^0), at first we don't need to check for carry 
;       until we have multiplied by 2, 63 times.
;   7.  multiplying by 2, is just the same 'shift left'.
;   8.  we will develop the function 'sum_digits' to sum the digits of each member of the quad-
;       word array
;   9.  we would also need to normalize (handle carries) by dividing by 10^18 before any overflow


%include "euler.inc"

%define     NORM 1000000000000000000
%define     ARRLEN 17
%define     ARREND (ARRLEN-1)*8

global  main

    section .data
power:      dq 1
            times ARRLEN-1 dq 0
sumdig:     dq 0        

    section .text    
main:
    enter   0,0
    
    ; first 63 powers (see item 7, above)
    mov     rax, [power]
    shl     rax, 63
    mov     rbx, NORM
    xor     rdx, rdx
    div     rbx
    mov     qword [power+8], rax
    mov     qword [power], rdx
    
    ; next 936 powers (i.e. 999 - 63)
    mov     rbx, 0
    mov     rsi, NORM
nxstart:
    cmp     rbx, 936
    jge     nxend
    mov     rcx, 0
    mov     rdi, 0
nxdig:
    cmp     rdi,ARREND
    jg      nxdigend
    mov     rax, [power+rdi]
    shl     rax, 3
    add     rax, rcx
    xor     rdx, rdx
    div     rsi
    mov     qword [power+rdi], rdx
    mov     rcx, rax
    add     rdi, 8
    jmp     nxdig
nxdigend:
    add     rbx, 3
    jmp     nxstart
nxend:  

    ; last 1 power (i.e. 1000 - 999)
    mov     rdi, 0
lststart:
    cmp     rdi,ARREND
    jg      lstend
    mov     rax, [power+rdi]
    shl     rax, 1
    mov     qword [power+rdi], rax
    add     rdi, 8
    jmp     lststart
lstend:

    ; get sum of digits
    mov     rcx, ARRLEN
sumstart:
    mov     rdi, [power+(rcx-1)*8]
    call    sum_digits
    add     qword [sumdig], rax
    loop    sumstart
        
    print_answer "016", INTEGER, [sumdig]
    
    leave
    xor     rax, rax
    ret