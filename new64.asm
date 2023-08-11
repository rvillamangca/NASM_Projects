    global  main
    extern  printf

    section .data
value:  dd   5
name:   db  "Problem 01",0
fmt:    db  "%s Answer:",9,"%d",10,0

    section .text  
main:
    enter   0,0
    
    mov     rdi, fmt
    mov     rsi, name
    mov     rdx, [value]
    call    printf
    
    leave
    xor     rax, rax
    ret