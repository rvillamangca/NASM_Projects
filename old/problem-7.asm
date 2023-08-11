;using NASM x86_32
global _main
extern _printf

%define TARGET 10001
%define TRUE 1
%define FALSE 0

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
        je end
        mov esi, eax
        mov eax, [%2]
        cdq
        div esi
        add eax, esi
        cdq
        div ebx
        loop %%sqrt_loop
    end:
    mov dword [%1], eax
    popad
%endmacro

%macro primeTest 2
    SECTION .data
        %%limit dd 0
        %%temp dd 0
    SECTION .text
        pushad
            mov ebx, TRUE
            sqrt %%limit, %2
            mov ecx, [%%limit]
            inc ecx
            %%test_loop:
                mov eax, [%2]
                cmp eax, 3
                jle %%end
                cmp ecx, 1
                jle %%end
                cdq
                div ecx
                cmp edx, 0
                jne %%next
                mov ebx, FALSE
                jmp %%end
                %%next:
                    dec ecx
                    jmp %%test_loop
        %%end:
        mov dword [%1], ebx
        popad
%endmacro

section .data
    num dd 0
    isprime dd FALSE
    fmt db "%d", 0

section .text
_main:
    enter 0,0
    
    mov eax, 1
    mov ecx, 0
    countprime:
        cmp ecx, TARGET
        je answer
        inc eax
        mov dword [num], eax
        primeTest isprime, num
        mov ebx, [isprime]
        cmp ebx, TRUE
        jne next
        inc ecx
        next:
            jmp countprime
    answer:
        push eax
        push fmt
        call _printf    
    
    leave
    xor eax, eax
    ret