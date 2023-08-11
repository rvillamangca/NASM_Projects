global _main
extern _printf

%macro rev_num 2
    pushad
    xor edi, edi
    mov eax, [%1]
    mov ebx, 10
    %%rev_loop:
        cmp eax, 0
        je %%end
        push eax
        mov eax, edi
        mul ebx
        mov edi, eax
        pop eax
        cdq
        div ebx
        add edi, edx
        jmp %%rev_loop
    %%end
    mov [%2], edi
    popad
%endmacro

section .data
    answer dd 0
    num dd 0
    rnum dd 0
    fmt db "%d", 0

section .bss

section .text
_main:
    enter 0,0    
    mov ecx, 1000
    outer_loop:
        dec ecx
        cmp ecx, 100
        jl end
        mov ebx, 1000
        inner_loop:
            dec ebx
            cmp ebx, 100
            jl outer_loop
            mov eax, ecx
            imul ebx
            cmp eax, [answer]
            jle inner_loop
            mov dword [num], eax
            rev_num num, rnum
            cmp eax, [rnum]
            jne inner_loop
            mov dword [answer], eax
            jmp inner_loop
    end:
        push dword [answer]
        push fmt
        call _printf
        add esp, 8
    leave
    mov eax, 0
    ret