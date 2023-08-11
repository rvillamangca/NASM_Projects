    %include "euler.inc"
    
    global  main
    extern  printf

    section .data
value: dq 0.0

    section .text  
main:
    enter   0,0
    
    mov r13, __float64__ (3.1416)
    
    movq   xmm11, r13
    
    write_flt xmm11    
    leave
    xor     rax, rax
    ret