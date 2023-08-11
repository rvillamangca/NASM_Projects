global main
extern printf

section .data
    msg db 'Hello, world!', 0
    fmt db "%s", 0
    num dq 70000000000
    fmt2 db "%llu", 0

section .text    
main:
    mov rbp, rsp
    sub rsp, 32
    and rsp, -16
    
    mov rcx, fmt
    mov rdx, msg
    call printf
    
    mov rcx, fmt2
    mov rdx, [num]
    call printf
    
    mov rsp, rbp
    xor eax, eax
    ret