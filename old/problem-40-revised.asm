;using NASM x86_32
global _main
extern _printf

%macro getdigit 3
    pushad
    mov ecx, 1
    mov eax, %2
    mov esi, 10
    %%dig_loop:
        cmp ecx, %3
        jg %%end
        cdq
        div esi
        inc ecx
        jmp %%dig_loop
    %%end:
        mov dword %1, edx
    popad
%endmacro

section .data
    len dd 0  
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
    mov ecx, 1    
    setdigitsize:
        cmp ecx, 1000000
        jl dig6
        mov ebx, 7
        jmp accumulate
        dig6: cmp ecx, 100000
        jl dig5
        mov ebx, 6
        jmp accumulate
        dig5: cmp ecx, 10000
        jl dig4
        mov ebx, 5
        jmp accumulate
        dig4: cmp ecx, 1000
        jl dig3
        mov ebx, 4
        jmp accumulate
        dig3: cmp ecx, 100
        jl dig2
        mov ebx, 3
        jmp accumulate
        dig2: cmp ecx, 10
        jl dig1
        mov ebx, 2
        jmp accumulate
        dig1: 
        mov ebx, 1
        jmp accumulate
    accumulate:
        add dword [len], ebx
        setd6: 
            cmp dword [len], 1000000
            jl setd5
            mov dword [d6], ecx
            mov eax, [len]
            mov dword [d6+4], eax
            jmp setfactors       
        setd5: 
            cmp dword [len], 100000
            jl setd4
            cmp dword [d5], 0
            jg repeat
            mov dword [d5], ecx
            mov eax, [len]
            mov dword [d5+4], eax
            jmp repeat 
        setd4: 
            cmp dword [len], 10000
            jl setd3
            cmp dword [d4], 0
            jg repeat
            mov dword [d4], ecx
            mov eax, [len]
            mov dword [d4+4], eax
            jmp repeat
        setd3: 
            cmp dword [len], 1000
            jl setd2
            cmp dword [d3], 0
            jg repeat
            mov dword [d3], ecx
            mov eax, [len]
            mov dword [d3+4], eax
            jmp repeat  
        setd2: 
            cmp dword [len], 100
            jl setd1
            cmp dword [d2], 0
            jg repeat
            mov dword [d2], ecx
            mov eax, [len]
            mov dword [d2+4], eax
            jmp repeat
        setd1: 
            cmp dword [len], 10
            jl repeat
            cmp dword [d1], 0
            jg repeat
            mov dword [d1], ecx
            mov eax, [len]
            mov dword [d1+4], eax
            jmp repeat                                                  
        repeat:
            inc ecx
            jmp setdigitsize
    setfactors:
        mov ebx, [d1+4]
        inc ebx
        sub ebx, 10
        getdigit [d1+8], [d1], ebx
        mov ebx, [d2+4]
        inc ebx
        sub ebx, 100
        getdigit [d2+8], [d2], ebx
        mov ebx, [d3+4]
        inc ebx
        sub ebx, 1000
        getdigit [d3+8], [d3], ebx
        mov ebx, [d4+4]
        inc ebx
        sub ebx, 10000
        getdigit [d4+8], [d4], ebx
        mov ebx, [d5+4]
        inc ebx
        sub ebx, 100000
        getdigit [d5+8], [d5], ebx 
        mov ebx, [d6+4]
        inc ebx
        sub ebx, 1000000
        getdigit [d6+8], [d6], ebx                       
    getproduct:        
        mov eax, 1
        mul dword [d1+8] 
        mul dword [d2+8]
        mul dword [d3+8]
        mul dword [d4+8]                                                     
        mul dword [d5+8]
        mul dword [d6+8]
    answer:
        push eax
        push fmt
        call _printf 
        add esp, 8
    leave
    xor eax, eax
    ret 