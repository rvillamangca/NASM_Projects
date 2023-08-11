; Project Euler Problem #1 Solution

global _main
extern _printf

%define MAX 1000

section .data
    fmt db '%d', 0
    
section .bss

section .text
_main:
    push ebp
    mov ebp, esp
    
    xor eax, eax
    
    xor ecx, ecx
    xor edx, edx
    mov ebx, 3
    call .sum_multiples
    add eax, ecx

    xor ecx, ecx
    xor edx, edx
    mov ebx, 5
    call .sum_multiples
    add eax, ecx

    xor ecx, ecx
    xor edx, edx
    mov ebx, 15
    call .sum_multiples
    sub eax, ecx
            
    push eax
    push fmt
    call _printf
    add esp, 8
    
    mov esp, ebp
    pop ebp
    mov eax, 0
    ret
    
.sum_multiples:
    add edx, ebx
    cmp edx, MAX
    jge .return
    add ecx, edx
    jmp .sum_multiples
    .return: ret