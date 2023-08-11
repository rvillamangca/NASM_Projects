    global  main
    extern  printf

    section .data
num:    times 3 db 1
        db 10,0
fmt:    db  "%s"

    section .bss

    section .text  
main:
    enter   0,0
    
    xor ecx, ecx
myloop:
    mov al, [num+ecx]
    cmp al,10
    je print
    add al, 65
    mov byte [num+ecx], al
    inc ecx
    jmp myloop
print:
    push    num
    push    fmt
    call    printf
    
    leave
    xor     eax, eax
    ret