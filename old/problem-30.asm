;using NASM x86_32
global _main
extern _printf

%define MAX 413343 ; this 7*9^5 which is the largest candidate number that 
                   ; that could possibly have the property required by prob-30
                   ; any number larger than this would result in having the
                   ; sum of the 5th of the digits to be always less than
                   ; the number.

%macro pow 3
    pushad
    mov eax, 1
    mov ebx, %2
    mov ecx, 1
    pow_loop:
        cmp ecx, %3
        jg end
        cdq
        mul ebx
        inc ecx
        jmp pow_loop
    end:
        mov dword %1, eax
    popad
%endmacro

%macro sumfifthdig 2
    SECTION .data
        %%pow dd 0
        %%dig times 6 dd 0
    SECTION .text
        pushad
        mov eax, %2
        mov ecx, 1
        mov ebx, 10
        %%loop1:
            cmp ecx, 6
            jg %%sumdig51
            cdq
            div ebx
            mov [%%dig+(ecx-1)*4], edx
            inc ecx
            jmp %%loop1
        %%sumdig51:
            mov eax, 0
            mov ecx, 1
            %%sumdig52:
                cmp ecx, 6
                jg %%end
                pow [%%pow], [%%dig+(ecx-1)*4], 5
                add eax, [%%pow]
                inc ecx
                jmp %%sumdig52
        %%end:
            mov dword %1, eax            
        popad
%endmacro

section .data
    sum dd 0
    fmt db "%d", 0


section .text
_main:
    enter 0,0
    mov ecx, 9
    mov eax, 0
    accumulate:
        inc ecx
        cmp ecx, MAX
        jg answer
        sumfifthdig [sum], ecx
        cmp ecx, [sum]
        jne accumulate
        add eax, ecx
        jmp accumulate
    answer:
        push eax
        push fmt
        call _printf 
        add esp, 8
    leave
    xor eax, eax
    ret