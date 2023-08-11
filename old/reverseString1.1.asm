global _main
extern _printf

section .data
    string db 'ramon', 0
    len equ $ - string - 1
    rstring times len + 1 db 0
    str_fmt db '%s', 0
    
section .bss

section .text
_main:
    push ebp
    mov ebp, esp
    call rev_string
    ;PRINT_STRING rstring
    push rstring
    push str_fmt
    call _printf
    add esp, 8
    mov esp, ebp
    pop ebp
    mov eax, 0
    ret
rev_string:
    mov ecx, len
    xor ebx, ebx
    .rev_loop:
        mov eax, [string+ebx]
        mov [rstring+ecx-1], al
        inc ebx
        loop .rev_loop
    ret