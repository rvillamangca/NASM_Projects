    global  main
    extern  printf

    section .data
value:  dd   5
name:   db  "Problem 01",0
fmt:    db  "%s Answer:",9,"%d",10,0

    section .bss

    section .text  
main:
    enter   0,0
    
    xor     eax, eax
    mov     al, 6
    shl     al, 1
    aaa
    add     al, 9
    aaa
    xor     ebx, ebx
    mov     bl, ah
    
    push    ebx
    push    name
    push    fmt
    call    printf
    
    leave
    xor     eax, eax
    ret