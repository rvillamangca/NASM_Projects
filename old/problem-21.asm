;using NASM x86_32
global _main
extern _printf

%define MAX 9999

%macro sqrt 2
    pushad
    mov ecx, 20
    mov eax, [%2]
    mov ebx, 2
    cdq
    div ebx
    mov esi, [%2]
    %%sqrt_loop:
        cmp esi, eax
        je %%end
        mov esi, eax
        mov eax, [%2]
        cdq
        div esi
        add eax, esi
        cdq
        div ebx
        loop %%sqrt_loop
    %%end:
    mov dword [%1], eax
    popad
%endmacro

%macro sumPropDiv 2
    SECTION .data
        %%max dd 1
    SECTION .text
        pushad
        mov ebx, 0
        sqrt %%max, %2
        mov ecx, [%%max]
        %%sum_loop:
            mov eax, [%2]
            cdq
            div ecx
            cmp edx, 0
            jne %%next
            cmp eax, ecx
            je %%once
            add ebx, eax
            %%once: add ebx, ecx
            %%next: loop %%sum_loop
        sub ebx, [%2]
        mov dword [%1], ebx
        popad
%endmacro

section .data
    num dd 0
    anum dd 0
    bnum dd 0
    sum dd 0
    fmt db "%d", 0

section .text
_main:
    enter 0,0 
    
    mov ecx, 2
    find_sum:
        cmp ecx, MAX
        je answer
        mov ebx, 0
        mov dword [num], ecx
        sumPropDiv anum, num
        cmp ecx, [anum]
        jge next
        sumPropDiv bnum, anum
        cmp ecx, [bnum]
        jne next
        add ebx, [num]
        add ebx, [anum]
        add dword [sum], ebx
        next:
            inc ecx
            jmp find_sum
    answer:
        push dword [sum]
        push fmt
        call _printf    
    
    leave
    xor eax, eax
    ret