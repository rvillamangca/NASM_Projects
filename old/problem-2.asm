;using NASM x86_32
global _main
extern _printf

%define MAX 4000000

section .data
    farnum dd 1
    nearnum dd 2
    fmt db "%d", 0

section .text
_main:
    enter 0,0    
    xor eax, eax    
    fibo_sum:
        mov  ebx, [nearnum]
        cmp ebx, MAX
        jg answer
        bt ebx, 0
        jc next
        add eax, [nearnum]
        next:
            mov edx, [farnum]
            add edx, ebx
            mov dword [nearnum], edx
            mov dword [farnum], ebx
            jmp fibo_sum
    answer:
        push eax
        push fmt
        call _printf
        add esp, 8
    leave
    mov eax, 0
    ret