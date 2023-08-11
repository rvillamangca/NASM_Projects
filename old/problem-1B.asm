global _main
extern _printf

%define MAX 1000

%macro sum_multiples 1
    xor ecx, ecx
    xor edx, edx
    mov ebx, %1
    %%sum:
        add edx, ebx
        cmp edx, MAX
        jge %%accumulate
        add ecx, edx
        jmp %%sum
    %%accumulate:
        %if %1 == 15
            sub eax, ecx
        %else
            add eax, ecx
        %endif
%endmacro

section .data
    fmt db '%d', 0
    
section .bss

section .text
_main:
    enter 0,0
    
    xor eax, eax  
    sum_multiples 3
    sum_multiples 5
    sum_multiples 15
       
    push eax
    push fmt
    call _printf
    add esp, 8
    
    leave
    mov eax, 0
    ret