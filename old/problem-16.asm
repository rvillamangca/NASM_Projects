;using NASM x86_32
global _main
extern _printf

%define MAXPOW 1000
%define MAXDIG 400 ; the maximum number of digits is 302, i.e. 1000*log10(2)
                   ; 400 digits is therefore sufficient

section .data
    temp1 times MAXDIG db 0
    temp2 times MAXDIG db 0
    num times MAXDIG db 0
    fmt db "%d", 0


section .text
_main:
    enter 0,0
    
    mov byte [temp1], 1
    mov byte [temp2], 1
    
    mov ecx, MAXPOW
    getPower:
        addBig num, temp1, temp2
        movBig temp1, num
        movBig temp, num
        loop getPower

    mov eax, 0        
    mov ecx, 0
    getDigitSum:
        cmp ecx, MAXDIG
        je answer
        add eax, [num+ecx]
        jmp getDigitSum
    
    answer:
        push eax
        push fmt
        call _printf 
        add esp, 8
    leave
    xor eax, eax
    ret