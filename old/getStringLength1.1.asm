global _main
extern _printf
extern _scanf

%define MAXLEN 50

section .data
    msg1 db 'Enter a string: ', 0
    msg2 db 'The string you entered is: ', 0
    msg3 db 'The length of the string is: ', 0
    string times MAXLEN+1 db 0
    newline db 10, 0
    fmt_str db '%s', 0
    fmt_dec db '%i', 0   
    
section .bss
    len resd 1

section .text
    global _main
_main:
    push ebp
    mov ebp, esp
    push msg1
    push fmt_str
    call _printf
    add esp, 8
    push string
    push fmt_str
    call _scanf
    add esp, 8
    call str_len
    push newline
    push fmt_str
    call _printf
    add esp, 8
    push msg2
    push fmt_str
    call _printf
    add esp, 8
    push string
    push fmt_str
    call _printf
    add esp, 8
    push newline
    push fmt_str
    call _printf
    add esp, 8
    push msg3
    push fmt_str
    call _printf
    add esp, 8
    push dword [len]
    push fmt_dec
    call _printf
    add esp, 8
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