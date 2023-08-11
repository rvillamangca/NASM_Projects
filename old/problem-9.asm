;using NASM x86_32
global _main
extern _printf

section .data
    fmt db "%d", 0


section .text
_main:
    enter 0,0
    
    mov eax, 1
    mov ecx, 0
    outer:
        cmp eax, 1000
        jge break1
        mov ebx, 1
        inner:
            cmp ebx, 1000
            jge break2
            push eax
            mul ebx
            mov esi, eax
            pop eax
            push eax
            mov edi, eax
            add edi, ebx
            sub edi, 500
            mov eax, 1000
            mul edi
            mov edi, eax
            pop eax
            cmp esi, edi
            je break3
            inc ebx
            jmp inner
            break3:
                mov ecx, 1000
                sub ecx, eax
                sub ecx, ebx
        break2:
            cmp ecx, 0
            jne break1
            inc eax
            jmp outer    
    break1:
        mul ebx
        mul ecx

    answer:
        push eax
        push fmt
        call _printf 
        add esp, 8
    leave
    xor eax, eax
    ret