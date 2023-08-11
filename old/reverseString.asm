%include "io.inc"

section .data
    string db 'ramon', 0
    len equ $ - string - 1
    rstring times len + 1 db 0
    
section .bss

section .text
    global _main
_main:
    push ebp
    mov ebp, esp
    call rev_string
    PRINT_STRING rstring
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