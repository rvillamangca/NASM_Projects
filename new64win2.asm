%include "sysio64.inc"
%include "functions.inc"
%include "euler.inc"

global  main

    section .data
    value  db   5,4,3,2,1
;    namex db "Ramon Villamangca", 0
;    name times 25 db 0
;    fmt db "%f", 0
    v   dq 142913828922
    dbl dq 10.0
    prs db 0,0
        times 1999999 db 1

    section .text  
main:
    enter   0,0
    
    mov rdi, 2000000
    mov rsi, prs
;    call prime_sieve
;    movsx rbx, byte [prs+104743]
    mov rbx, [v]
    call write_dec rbx
    
    
    leave
    xor     rax, rax
    ret
 