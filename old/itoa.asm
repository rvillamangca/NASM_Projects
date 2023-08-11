;using NASM x86

global _main
extern _printf

%define MAX 20

%macro itoa 2
    SECTION .data
        %%num_rstring times 20 db 0
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
            mov [len], ecx
            xor ebx, ebx
        %%rev_loop:
            cmp ecx, 0
            je %%end
            mov eax, [%%num_rstring+ebx]
            mov [num_string+ecx-1], al
            inc ebx
        loop %%rev_loop
    %%end
%endmacro

section .data
    num dd 12345
    num_string times 20 db 0
    fmt db "%s", 0
    
section .bss
    len resd 1

section .text
_main:
    enter 0,0
    
   ; mov eax, 123456789
    
    itoa [num], num_string
            
    push num_string
    push fmt
    call _printf
    add esp, 8
          
    leave
    mov eax, 0
    ret