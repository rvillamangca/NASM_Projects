;using NASM x86

global _main
extern _atoi
extern _printf

%define MAX 20


section .data
    number db "1234",0
    fmt db "%d", 0
    
section .bss

section .text
_main:
    enter 0,0
    
    push number
    call _atoi
    add esp, 4
    
    push eax
    push fmt
    call _printf
    add esp, 8
          
    leave
    mov eax, 0
    ret