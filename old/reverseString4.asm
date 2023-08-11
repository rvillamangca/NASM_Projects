global _main
extern _printf
extern _scanf

;---MACROS SECTION -------------------------

%define MAX_STR_LEN 32

%macro write_str 1
    SECTION .data
        %%fmt db "%s", 0
    SECTION .text
        push %1
        push %%fmt 
        call _printf
        add esp, 8
%endmacro

%macro read_str 1
    SECTION .data
        %%fmt db "%s", 0
    SECTION .text
        push %1
        push %%fmt 
        call _scanf
        add esp, 8
%endmacro

%macro write_nl 0
    SECTION .data
        %%nl db 10, 0
        %%fmt db "%s", 0
    SECTION .text
        push %%nl
        push %%fmt 
        call _printf
        add esp, 8
%endmacro

%macro write_dec 1
    SECTION .data
        %%fmt db "%d", 0
    SECTION .text
        push dword [%1]
        push %%fmt 
        call _printf
        add esp, 8
%endmacro

%macro strlen 2
    pushad
    xor ecx, ecx
    mov esi, %1
    cld
    %%repeat:
        lodsb
        cmp eax, 0
        je %%exit
        inc ecx
        jmp %%repeat
    %%exit:
        mov [%2], ecx
    popad
%endmacro

%macro rev_string 2
    SECTION .bss
        %%len resd 1
    SECTION .text
    pushad
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

;---END OF MACROS SECTION ---------------------


section .data
    msg1 db "Enter a string: ", 0
    msg2 db "The string you entered is: ", 0
    msg3 db "The reverse of the string is: ", 0
    str1 times MAX_STR_LEN db 0
    rstr1 times MAX_STR_LEN db 0
    
section .bss

section .text
_main:
    enter 0,0
    write_str msg1
    read_str str1
    rev_string str1, rstr1
    write_nl
    write_str msg2
    write_str str1
    write_nl
    write_str msg3
    write_str rstr1
    write_nl
    leave
    mov eax, 0
    ret