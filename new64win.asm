    global  main
    extern  printf

    section .data
value:  dd   5
name:   db  "Problem 01",0
fmt:    db  "%s Answer:",9,"%d",10,0

    section .text  
main:
    enter   0,0
    
    mov     rcx, fmt
    mov     rdx, name
    mov     r8, [value]
    sub     rsp, 40
    call    printf
    add     rsp, 40
    
    leave
    xor     rax, rax
    ret