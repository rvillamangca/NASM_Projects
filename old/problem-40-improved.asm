;using NASM x86_32
global _main
extern _printf



section .data   
    nums: times 9 dd 1        ; to have a concatenated number of 10^6 digits, the numbers
          times 90 dd 2       ; to be concatenated need not be more than 199999
          times 900 dd 3
          times 9000 dd 4
          times 90000 dd 5
          times 100000 dd 6
    d1 times 3 dd 0
    d2 times 3 dd 0
    d3 times 3 dd 0
    d4 times 3 dd 0
    d5 times 3 dd 0
    d6 times 3 dd 0
    fmt db "%d", 0

section .text
_main:
    enter 0,0
    
    mov eax, [nums+(4*199998)]
    answer:
        push eax
        push fmt
        call _printf    
    
    leave
    xor eax, eax
    ret