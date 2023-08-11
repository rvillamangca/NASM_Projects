    global  main
    extern  printf

    section .data
value:  dd   5
name:   db  "Problem 01",0
fmt:    db  "%s Answer:",9,"%d",10,0

    section .text  
main:
    enter   0,0
    
    xor     rax, rax
    mov     al, 5
    add     al, 6
    aaa
    
    mov     rdi, fmt
    mov     rsi, name
    mov     rdx, qword al
    call    printf
    
    leave
    xor     rax, rax
    ret