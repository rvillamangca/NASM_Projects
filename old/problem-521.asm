;using NASM x86_64
global main
extern printf

%define TARGET 1000000000000
%define MAX 1000000
%define SIEVE_MAX  1000 ; largest for sieve test, i.e. square root of MAX
%assign PI_MAX 78498    ; number of primes up to MAX, this was pre-counted using the 'sieve'
                        ; in the '.text' section, unfortunately this has to be hard-coded

section .data
    sieve times MAX+1 dq 0
    primes_arr times PI_MAX dq 0
    primes_size dq 0
    sums_arr times PI_MAX dq 0
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
        jg prep_arr
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
    
    prep_arr:
        mov rcx, 2
        mov r8, 0
        fill_arr:
            cmp rcx, MAX
            jg count_primes
            mov r9, [sieve+rcx*8]
            cmp r9, 0
            je rep_fill
            mov qword [primes_arr+r8*8], r9
            inc r8
            rep_fill:
                inc rcx
                jmp fill_arr
                     
    count_primes:
;        mov rcx, 0
;        count:
;            cmp qword [primes_arr+rcx*8], 0
;            je end_count
;            inc rcx
;            jmp count
;        end_count: mov qword [primes_size], rcx
    get_sums:
        mov rcx, 1
        gs1:
            inc rcx
;            mov r9, 10 ; TARGET
;            sub r9, rcx
;            cmp r9, 0
            cmp rcx, 100
            jg temp
            mov rbx, 0
            gs2:
                cmp rbx, PI_MAX-1
                je gs1
;                cmp qword [primes_arr+rbx*8], rcx
;                jl rep_gs2
                mov rax, rcx
                mov r8, [primes_arr+rbx*8] 
                div r8
                cmp rdx, 0
                jne rep_gs2
                add qword [sums_arr+rbx*8], r8
                jmp gs1
                rep_gs2:
                    inc rbx
                    jmp gs2
    temp:
;        mov rdx, [primes_arr+PI_MAX*8-8]
;        push rdx
;        mov rdx, [primes_arr+PI_MAX*8-16]
;        push rdx
;        pop rbx
;        pop rbx
;        mov rax, rbx ;[stack_64+8]
;        mov rax, [primes_arr+PI_MAX*8-16]
;        mov rax, [primes_size]
;        mov rax, 6
;        mov r8, 5
;        div r8
        mov rax, [primes_arr+32]
               

    answer: 
        mov rcx, fmt
        mov rdx, rax
        call printf
    
    mov rsp, rbp
    xor eax, eax
    ret