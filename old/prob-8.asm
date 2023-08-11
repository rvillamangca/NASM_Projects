;using NASM x86_32
global _main
extern _printf

%define BREAKER 10 ;needed to implement 64-bit compare (qcmp)

%macro qcmp 2
    SECTION .data
        %%n1high dd 0
        %%n1low dd 0
        %%n2high dd 0
        %%n2low dd 0
    SECTION .text
        pushad
        mov ebx, BREAKER
        mov eax, [%1]
        mov edx, [%1+4]
        cdq
        div ebx
        mov dword [%%n1high], eax
        mov dword [%%n1low], edx
        mov eax, [%2]
        mov edx, [%2+4]
        cdq
        div ebx
        mov dword [%%n2high], eax
        mov dword [%%n2low], edx
        mov eax, [%%n1high]
        cmp eax, [%%n2high]     
        jne %%end
        mov eax, [%%n1low]
        cmp eax, [%%n2low]
        %%end
        popad
%endmacro

section .data
    arr1 incbin "d:\Users\ramonsv\Desktop\My Files\SASM\Windows\Projects\p8.txt"
    arr2 times 1000 dd 0
    factors times 13 dd 0
    prod dq 0
    maxprod dq 0
    fmt db "%llu", 0
;    fmt db "%d", 0

section .text
_main:
    enter 0,0
    
    mov ecx, 0
    init_array:
        cmp ecx, 1000
        jge prep_products
        xor eax, eax
        mov al, [arr1+ecx]
        sub eax, 30h
        mov dword [arr2+ecx*4], eax
        inc ecx
        jmp init_array    
    
    prep_products:
    mov ecx, 0
    test_products:
        cmp ecx, 987
        jg answer
        push ecx
        mov ebx, 0
        init_factors:
            cmp ebx, 12
            jg prep_prod
            mov eax, [arr2+ecx*4]
            mov dword [factors+ebx*4], eax
            inc ecx
            inc ebx
            jmp init_factors
        prep_prod:
        mov ebx, 0
        mov eax, 1
        get_products:
            cmp ebx, 12
            jg test_prod
            cdq
            mov esi, [factors+ebx*4]
            mul esi
            inc ebx
            jmp get_products
        test_prod:
            mov dword [prod], eax
            mov dword [prod+4], edx
            qcmp prod, maxprod
            jl next_prod
            mov dword [maxprod], eax
            mov dword [maxprod+4], edx
        next_prod:
        pop ecx
        inc ecx
        jmp test_products

                                  
    answer:
        push dword [maxprod+4]
        push dword [maxprod]
;        push eax
        push fmt
        call _printf
        add esp, 8

    leave
    xor eax, eax
    ret