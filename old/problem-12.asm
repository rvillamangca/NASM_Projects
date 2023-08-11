;using NASM x86_32
global _main
extern _printf

%define TARGET 500

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

%macro numFactors 2
    SECTION .data
        %%max dd 1
    SECTION .text
        pushad
        cmp dword [%2], 1
        jne start
        mov ebx, 1
        jmp finish
        start: sqrt %%max, %2
        mov ecx, [%%max]
        mov ebx, 0
        %%count:
            mov eax, [%2]
            cdq
            div ecx
            cmp edx, 0
            jne %%next
            inc ebx
            %%next: loop %%count
        add ebx, ebx
        finish: mov dword [%1], ebx
        popad
%endmacro

section .data
    num dd 0
    numfac dd 0
    fmt db "%d", 0

section .text
_main:
    enter 0,0
    
    mov ecx, 1
    testNum:
        add dword [num], ecx
        numFactors numfac, num
        mov eax, [numfac]
        cmp eax, TARGET
        jg answer
        inc ecx
        jmp testNum    

    answer:
        push dword [num]
        push fmt
        call _printf    
    
    leave
    xor eax, eax
    ret