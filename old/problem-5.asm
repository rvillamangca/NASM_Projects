;using NASM x86

global _main
extern _printf

%define MAX 20


section .data
    fmt db "%d", 0
    
section .bss

section .text
_main:
    enter 0,0
    
    mov eax, 1
    mov ebx, eax
    .start:
        mov ecx, MAX
    .test1:
        mov eax, ebx
        cdq
        div ecx
        cmp edx, 0
        je .test2
        inc ebx
        jmp .start
    .test2:
        cmp ecx, 1
        je .answer
        loop .test1
    .answer:
        push ebx
        push fmt
        call _printf
        add esp, 12
          
    leave
    mov eax, 0
    ret