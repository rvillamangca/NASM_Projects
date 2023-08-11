%include "io64.inc"

%define MAX 10


section .data
    candidate dq 0
    fmt db '%d', 0
    
section .bss

section .text
    global _main
_main:
    ;enter 0,0
    
    mov rax, 1
    mov rbx, rax
    .start:
        mov rcx, MAX
    .test1:
        mov rax, rbx
        xor rdx, rdx
        div rcx
        cmp rdx, 0
        je .test2
        inc rbx
        jmp .start
    .test2:
        cmp rcx, 1
        je .accummulate
        ;dec ecx
        ;jmp .test1
        loop .test1
    .accummulate:
        mov [candidate], rbx
    
    PRINT_DEC 8, candidate
    
    ;leave
    mov rax, 0
    ret