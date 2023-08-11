%include "io.inc"

section .data
    msg1 db 'Enter a string: ', 0
    msg2 db 'The string you entered is: ', 0
    msg3 db 'The length of the string is: ', 0
    string times 51 db 0
    
section .bss
    len resd 1

section .text
    global _main
_main:
    push ebp
    mov ebp, esp
    PRINT_STRING msg1
    GET_STRING string, 50
    call str_len
    NEWLINE
    PRINT_STRING msg2
    PRINT_STRING string
    NEWLINE
    PRINT_STRING msg3
    PRINT_DEC 4, len
    mov esp, ebp
    pop ebp
    mov eax, 0
    ret
str_len:
    xor ecx, ecx
    .len_loop:
        cmp BYTE [string+ecx], 0
        je .return
        inc ecx
        mov [len], ecx
        jmp .len_loop
    .return: ret