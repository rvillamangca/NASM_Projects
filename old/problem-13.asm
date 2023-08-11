;using NASM x86_32
global _main
extern _printf
extern _atoi

%define MAXDIG 55      ; adding 100 50-digit would result in a maximum 52-digit
                       ; number, but we want our dword arrays to be 5-digit numbers
%define BREAKER 100000 ; needed to obtain no more than 5-digit numbers only

%macro normalize 1
    pushad
    mov ecx, MAXDIG/5
    %%norm_loop:
        mov eax, [%1+(ecx-1)*4]
        mov ebx, BREAKER
        cdq
        div ebx
        mov dword [%1+(ecx-1)*4], edx
        add dword [%1+(ecx-2)*4], eax
        loop %%norm_loop
    popad        
%endmacro

%macro addArr 2
    pushad
    mov ecx, MAXDIG/5
    %%norm_loop:
        mov eax, [%1+(ecx-1)*4]
        mov ebx, [%2+(ecx-1)*4]
        add eax, ebx
        mov dword [%1+(ecx-1)*4], eax 
        loop %%norm_loop
    normalize %1
    popad       
%endmacro

%macro toIntArr 2
    SECTION .data
        %%nstr times 6 db 0  
    SECTION .text
        pushad
        mov edi, MAXDIG/5
        mov esi, 50
        %%outer:
            cmp esi, 5
            jl %%end
            mov ecx, 5
            %%inner:
                xor eax, eax
                mov al, [%2+esi-1]
                mov byte [%%nstr+ecx-1], al
                dec esi
                loop %%inner
            push %%nstr
            call _atoi
            add esp, 4
            mov dword [%1+(edi-1)*4], eax
            dec edi
            jmp %%outer
        %%end: popad
%endmacro

section .data
    char_arr incbin "d:\Users\ramonsv\Desktop\My Files\SASM\Windows\Projects\p13.txt"
    num_str times 51 db 0
    num_arr times MAXDIG/5 dd 0 ; see comment above
    sum_arr times MAXDIG/5 dd 0
    fmt db "%d", 0

section .text
_main:
    enter 0,0
    
    mov ecx, 5000
    get_sum:
        cmp ecx, 50
        jl answer
        mov ebx, ecx
        sub ebx, 50
        mov esi, 50
        get_str:
            cmp ecx, ebx
            je get_num
            xor eax, eax
            mov al, [char_arr+ecx-1]
            mov byte [num_str+esi-1], al
            dec ecx
            dec esi
            jmp get_str 
        get_num:
            toIntArr num_arr, num_str
            addArr sum_arr, num_arr
            jmp get_sum  
    
    answer:       
        push dword [sum_arr]
        push fmt
        call _printf
        add esp, 8
        push dword [sum_arr+4]
        push fmt
        call _printf
        add esp, 8
        mov eax, [sum_arr+8]
        mov ebx, 100
        cdq
        div ebx
        push eax
        push fmt
        call _printf
        add esp, 8
        
    leave
    xor eax, eax
    ret