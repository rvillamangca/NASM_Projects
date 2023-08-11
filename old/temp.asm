;using NASM x86_32
global _main
extern _printf

%assign num 0

%macro reassign 1
    %%a equ 78
    %assign num %%a
%endmacro

section .data
    fmt db "%d", 0


section .text
_main:
    enter 0,0
    
    mov eax, num
    answer1:
        push eax
        push fmt
        call _printf 
        add esp, 8
    mov ecx, 3
    reassign ecx
    mov eax, num
    answer2:
        push eax
        push fmt
        call _printf 
        add esp, 8
    
    leave
    xor eax, eax
    ret