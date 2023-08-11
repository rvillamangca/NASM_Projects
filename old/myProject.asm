global _main
extern _printf
extern _getchar

section .data
    string db 'Hello, Ramon!', 0
    fmt db '%s', 0
    fmt2 dw '%c',0
    
section .text
_main:
    mov ebp, esp
    mov eax, 0x64
    push string
    push fmt
    call _printf
    call _getchar
    add esp, 8
    xor eax, eax
    ret