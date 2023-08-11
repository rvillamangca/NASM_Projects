;using NASM x86_64
global main
extern printf

%define TARGET 1000000000000
%define MAX 1000000
%define SIEVE_MAX  1000 ; largest for sieve test, i.e. square root of MAX
%assign PI_MAX 78498    ; number of primes up to MAX, this was pre-counted using the 'sieve'
                        ; in the '.text' section, unfortunately this has to be hard-coded


%macro push_64 1
    mov r15, 0
    %%push_it:
        cmp r15, MAX
        je %%end_push
        cmp qword [stack_64+r15*8], 0
        jne %%rep_push
        mov qword [stack_64+r15*8], %1
        jmp %%end_push
        %%rep_push:
            inc r15
            jmp %%push_it
    %%end_push:    
%endmacro

%macro pop_64 1
    mov r15, 0
    %%pop_it:
        cmp r15, MAX
        je %%end_pop
        cmp qword [stack_64+r15*8], 0
        jne %%rep_pop
        mov qword %1, [stack_64+(r15-1)*8]
        mov qword [stack_64+(r15-1)*8], 0
        jmp %%end_pop
        %%rep_pop:
            inc r15
            jmp %%pop_it
    %%end_pop:    
%endmacro

%macro pushq 1
    mov qword [stack_temp], %1
    push dword [stack_temp]
    push dword [stack_temp+4]
%endmacro

%macro popq 1
    pop dword [stack_temp+4]
    pop dword [stack_temp]
    mov %1, [stack_temp]
%endmacro

section .data
    stack_64 times MAX dq 0 ; this has to be implemented 64-bit assembly does not work 
                            ; well with the 32-bit stack
    stack_temp dq 0
    sieve times MAX+1 dq 0
    primes_arr times PI_MAX dq 0
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
            jg temp
            mov r9, [sieve+rcx*8]
            cmp r9, 0
            je rep_fill
            mov qword [primes_arr+r8*8], r9
            inc r8
            rep_fill:
                inc rcx
                jmp fill_arr
                     
    temp:
        mov rdx, 1000000000000000;[primes_arr+PI_MAX*8-8]
        push rdx
        mov rdx, 2000000000000000;[primes_arr+PI_MAX*8-16]
        push rdx
        pop rbx
;        pop rbx
        mov rax, rbx ;[stack_64+8]
;        mov rax, [primes_arr+PI_MAX*8-16]

               

    answer: 
        mov rcx, fmt
        mov rdx, rax
        call printf
    
    mov rsp, rbp
    xor eax, eax
    ret