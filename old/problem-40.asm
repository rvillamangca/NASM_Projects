;using NASM x86_32
global _main
extern _printf

section .data
    d1 dd 0,0,0
    d2 dd 0,0,0
    d3 dd 0,0,0
    d4 dd 0,0,0
    d5 dd 0,0,0
    d6 dd 0,0,0
    fmt db "%d", 0

section .text
_main:
    enter 0,0
    
    mov eax, 1    ; current number of digits
    mov ecx, 1    ; number counter
    mov ebx, 1    ; digit adder
    
    count1:
        cmp eax, 10
        jl c1
        mov edx, [d1]
        cmp edx, 0
        jg c1
        mov dword [d1], ecx
        mov dword [d1+8], eax
        c1: 
            cmp ecx, 10
            jl c11
            mov ebx, 10
            jmp count2
            c11:
                add eax, ebx
                inc ecx
                jmp count1
    count2:
        cmp eax, 100
        jl c2
        mov edx, [d2]
        cmp edx, 0
        jg c2
        mov dword [d2], ecx
        mov dword [d2+8], eax
        c2: 
            cmp ecx, 100
            jl c22
            mov ebx, 100
            jmp count3
            c22:
                add eax, ebx
                inc ecx
                jmp count2
    count3:
        cmp eax, 1000
        jl c3
        mov edx, [d3]
        cmp edx, 0
        jg c3
        mov dword [d3], ecx
        mov dword [d3+8], eax
        c3: 
            cmp ecx, 1000
            jl c33
            mov ebx, 1000
            jmp count4
            c33:
                add eax, ebx
                inc ecx
                jmp count3
    count4:
        cmp eax, 10000
        jl c4
        mov edx, [d4]
        cmp edx, 0
        jg c4
        mov dword [d4], ecx
        mov dword [d4+8], eax
        c4: 
            cmp ecx, 10000
            jl c44
            mov ebx, 10000
            jmp count5
            c44:
                add eax, ebx
                inc ecx
                jmp count4
    count5:
        mov eax, [d4]
    answer:
        push eax
        push fmt
        call _printf    
    
    leave
    xor eax, eax
    ret