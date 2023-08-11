;using NASM x86_64
global main
extern printf

%define MAX 1000000
%define SIEVE_MAX  1000 ; largest for sieve test, i.e. square root of MAX
%assign PI_MAX 78498    ; number of primes up to MAX, this was pre-counted using the 'sieve'
                        ; in the '.text' section, unfortunately this has to be hard-coded


section .data
    sieve times MAX+1 dq 0
    primes_arr times PI_MAX+1 dq 0
    fmt db "%llu", 0

section .text    
main:
    mov rbp, rsp
    sub rsp, 32
    and rsp, -16


    mov rcx, MAX 
    init_sieve:
        cmp rcx, 1
        je prep_sieve
        mov qword [sieve+rcx*8], rcx
        loop init_sieve
        
    prep_sieve:
    mov rcx, 2
    filter_sieve:
        cmp rcx, SIEVE_MAX
        jg prep_count
        cmp qword [sieve+rcx*8],0
        je rep_filter
        mov rbx, 1
        zero:
            inc rbx
            mov rax, rbx
            mul rcx
            cmp rax, MAX
            jg rep_filter
            mov qword [sieve+rax*8],0
            jmp zero
        rep_filter:
            inc rcx
            jmp filter_sieve    
    
    prep_count:
        mov rcx, MAX
        mov rax, 0
        count_primes:
            cmp qword [sieve+rcx*8], 0
            je rep_count
            inc rax
            rep_count: loop count_primes
                     

    answer: 
        mov rcx, fmt
        mov rdx, rax
        call printf
    
    mov rsp, rbp
    xor eax, eax
    ret