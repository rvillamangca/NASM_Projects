global _main
extern _printf

%define MAX_STR_LEN 11

%macro write_dec 1
    pushad
    SECTION .data
        %%fmt db "%d", 0
    SECTION .text
        push dword [%1]
        push %%fmt 
        call _printf
        add esp, 8
    popad
%endmacro

%macro num2str 2
    pushad
    SECTION .data
        %%num_rstring times 20 db 0
        %%len dd 0
    SECTION .text
        xor ecx, ecx
        mov eax, %1
        %%next:
            cdq
            mov ebx, 10
            div ebx
            mov bl, dl
            add bl, 30h
            mov [%%num_rstring+ecx], bl
            cmp eax, 0
            je %%out
            inc ecx
            jmp %%next
        %%out:
            inc ecx
            mov [%%len], ecx
            xor ebx, ebx
        %%rev_loop:
            cmp ecx, 0
            je %%end
            mov eax, [%%num_rstring+ebx]
            mov [%2+ecx-1], al
            inc ebx
        loop %%rev_loop
    %%end
    popad
%endmacro

%macro strlen 2
    pushad
    xor ecx, ecx
    mov esi, %1
    cld
    %%repeat:
        lodsb
        cmp al, 0
        je %%exit
        inc ecx
        jmp %%repeat
    %%exit:
        mov [%2], ecx
    popad
%endmacro

%macro rev_str 2
    pushad
    SECTION .bss
        %%len resd 1
    SECTION .text
    strlen %1, %%len
    mov ecx, [%%len]
    mov esi, %1
    cld
    %%repeat:
        lodsb
        mov [%2+ecx-1], al
        loop %%repeat
    %%exit:
    popad
%endmacro

%macro cmp_str 3
    pushad
    SECTION .bss
        %%len1 resd 1
        %%len2 resd 1
    SECTION .text
    strlen %1, %%len1
    strlen %2, %%len2
    mov ecx, [%%len1]
    cmp ecx, [%%len2]
    jne %%nequal
    cmp ecx, ecx
    cmp ecx, 0
    je %%equal
    mov ebx, 0
    mov esi, %1
    cmp ecx,ecx
    cld
    %%repeat:
        lodsb
        cmp [%2+ebx], al
        jne %%nequal
        inc ebx
        loop %%repeat
    %%equal:
        mov eax, 1
        mov [%3], eax
        jmp %%exit
    %%nequal
        mov eax, 0
        mov [%3], eax
    %%exit:
    popad
%endmacro


;--------- program start ----------------

section .data
    answer dd 0
    temp dd 0
    nstring times 12 db 0
    rstring times 12 db 0
    flag dd 0

section .bss

section .text
_main:
    enter 0,0
    
    mov ecx, 1000
    outer_loop:
        dec ecx
        cmp ecx, 100
        jl exit_loop
        mov ebx, 1000
        inner_loop:
            dec ebx
            cmp ebx, 100
            jl outer_loop
            mov eax, ecx
            imul ebx
            mov dword [temp], eax
            num2str [temp], nstring
            rev_str nstring, rstring
            cmp_str nstring, rstring, flag
            mov edi, [flag]
            cmp edi, 1
            jne inner_loop
            cmp eax, [answer]
            jle inner_loop
            mov dword [answer], eax
            jmp inner_loop
    exit_loop:
        write_dec answer
    
    leave
    mov eax, 0
    ret