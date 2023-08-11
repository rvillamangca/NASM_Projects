;using NASM x86_32
global _main
extern _printf

%define SIEVE_MAX 2000000
%define SIEVE_MAXTEST  1415 ;largest for sieve test - approx. sq.rt. SIEVE_MAX

section .data
    sieve times SIEVE_MAX+1 dd 0
    sum dq 0
    fmt db "%llu", 0

section .text
_main:
    enter 0,0
    
    mov ecx,SIEVE_MAX 
    init_sieve:
        cmp ecx, 1
        je prep_sieve
        mov dword [sieve+ecx*4], ecx
        dec ecx
        jmp init_sieve
    
    prep_sieve:
    mov ecx, 2
    filter_sieve:
        cmp ecx, SIEVE_MAXTEST
        jg prep_prime
        cmp dword [sieve+ecx*4],0
        je rep_filter
        mov ebx, 1
        zero:
            inc ebx
            mov eax, ebx
            mul ecx
            cmp eax, SIEVE_MAX
            jg rep_filter
            mov dword [sieve+eax*4],0
            jmp zero
        rep_filter:
            inc ecx
            jmp filter_sieve
               
    prep_prime:
    mov ecx, SIEVE_MAX
    sum_prime:
        mov ebx, [sieve+ecx*4]
        cmp ebx,0
        je rep_sum
        movq mm0, [sum]
        movd mm1, [sieve+ecx*4]
        paddq mm0, mm1
        movq [sum], mm0
        rep_sum: loop sum_prime
                                   
    answer:
        push dword [sum+4]
        push dword [sum]
        push fmt
        call _printf
        add esp, 8

    leave
    xor eax, eax
    ret