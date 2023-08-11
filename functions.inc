%ifndef FUNCTIONS

    %define FUNCTIONS FUNCTIONS
    
    %include "sysio64.inc"
    
    ; ---------------------------- FUNCTION CALLING CONVENTIONS --------------------------------;
    ;                                                                                           ;
    ; 1. Function arguments shall be stored in the 'unix' function calling convention:          ;
    ;    i.e. 'rdi', 'rsi', etc. for int64 and 'xmm0', 'xmm1' etc. for float                    ;
    ;                                                                                           ;
    ; 2. Function return shall be stored in the common calling convention:                      ;
    ;    i.e. 'rax' (and 'rdx' if required) or 'xmm0' (and 'xmm1' if required)                  ;
    ;                                                                                           ;
    ; 3. We will try to preserved the common registers recommended to be preserved:             ;
    ;    i.e. r12-r15                                                                           ;
    ;                                                                                           ;
    ; 4. Macros will also be used, in cases where macros are more convenient or if we want      ;
    ;    the command to behave like an regular opcode                                           ;
    ;                                                                                           ;
    ; ------------------------------------------------------------------------------------------;
    
    ;sample:
    ;    %push
    ;    %stacksize flat64
    ;    %assign %$localsize 0
    ;    %local samp:qword
    ;    enter %$localsize,0
    ;    mov qword [samp], rdi
    ;    mov rax, [samp]
    ;    leave
    ;    ret
    ;    %pop
    ;
    ;    __temp:
    ;        add qword [rdi+16], 1
    ;        ret
    
    %define TRUE 1
    %define FALSE 0
   
    %macro negsd 1  
        ; negates a floating point number in a register
        ; this is not a function, we need to use macro
        ; in order for this to behave as regular opcode
        ; note: argument must be a register
        SECTION     .data
            %%sgn   dq -1.0
            %%xtmp  dq  0.0
        SECTION     .text
            movsd   qword [%%xtmp], xmm15 ; don't use xmm0 because it's volatile
            movsd   xmm15, %1
            mulsd   xmm15, [%%sgn]
            movsd   %1, xmm15 
            movsd   xmm15, [%%xtmp]  ; restore register
    %endmacro
    
    %macro xmul 2  
        ; multiplies two integers and saves the product on the first argument
        ; any overflow will be saved in 'rdx'
        ; this is not a function, we need to use macro in order for this 
        ; to behave as regular opcode
        ; note: do not use 'rax', 'rdx', 'rdi' or memory as arguments
        SECTION     .data
            %%tmp   dq 0
        SECTION     .text
            mov qword [%%tmp], rax
            mov rax, %1
            mul %2
            mov %1, rax
            mov rax, [%%tmp]        
    %endmacro
    
    %macro weekday 3  
        ; calculates the weekday (0 = Sunday, etc.) for a given date
        ; argument must be registers and are in "yyyy, mm, dd" format. 
        ; result will be stored in 'rax'
        ; algorithm: uses the Sakamoto's method (https://en.wikipedia.org/wiki/
        ; Determination_of_the_day_of_the_week#Sakamoto's_methods)
        ; this is not a function, we need to use macro in order for this 
        ; to behave as regular opcode
        ; note: do not use 'rax', 'rdx', 'rsi', 'rdi' or memory as arguments
        SECTION     .data
            %%t         dq 0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4
            %%y         dq 0
        SECTION     .text
            mov         qword [%%y], %1
            cmp         %2, 3
            jge         .start
            dec         qword [%%y]
            .start:
                mov     rdi, [%%y]
                mov     rax, [%%y]
                mov     rsi, 4
                xor     rdx,  rdx
                div     rsi
                add     rdi, rax
                mov     rax, [%%y]
                mov     rsi, 100
                xor     rdx,  rdx
                div     rsi
                sub     rdi, rax
                mov     rax, [%%y]
                mov     rsi, 400
                xor     rdx,  rdx
                div     rsi
                add     rdi, rax
                mov     rax, rdi
                mov     rdi, %2
                dec     rdi
                add     rax, [%%t+rdi*8]
                add     rax, %3
                mov     rdi, 7
                xor     rdx, rdx
                div     rdi
                mov     rax, rdx        
    %endmacro

    %macro swap_str 3  
        ; swaps the content of 2 strings
        ; the first 2 arguments are memory address of the
        ; strings to be swapped which must have the same length
        ; while the 3rd argument must be an immediate containing
        ; the length of the string
        ; this is not a function, we need to use macro
        ; in order for this to behave as regular opcode
        ; note: do not use rax or rcx as arguments
        SECTION     .data
            %%_rax      dq 0
            %%_rcx      dq 0
        SECTION     .text
            mov         qword [%%_rax], rax
            mov         qword [%%_rcx], rcx
            mov         rcx, %3
            %%swap:
                mov     al, [%1+rcx-1]
                xchg    [%2+rcx-1], al
                xchg    [%1+rcx-1], al
                loop    %%swap
            mov         rax, [%%_rax]
            mov         rcx, [%%_rcx]
    %endmacro
    
    %macro cmp_alpha 3  
        ; compares if 2 strings are alphabetically arranged
        ; if they are 'rax' returns 1 (0 if not)
        ; the first 2 arguments are memory address of the
        ; strings to be compared which must have the same length
        ; while the 3rd argument must be an immediate containing
        ; the length of the string
        ; this is not a function, we need to use macro
        ; in order for this to behave as regular opcode
        ; note: do not use rax, rbx or rcx as arguments
        SECTION     .data
            %%_rbx      dq 0
            %%_rcx      dq 0
        SECTION     .text
            mov         qword [%%_rbx], rbx
            mov         qword [%%_rcx], rcx
            mov         rax, 1
            mov         rcx, -1
            %%alpha:
                inc     rcx
                cmp     rcx, %3
                jge     %%end
                mov     bl, [%1+rcx]
                cmp     bl, [%2+rcx]
                je      %%alpha
                jl      %%end
                mov     rax, 0           
            %%end:
            mov         rbx, [%%_rbx]
            mov         rcx, [%%_rcx]
    %endmacro
        
    sum_consec:         
        ; calculates the sum of integers from 1 up to the integer stored in 'rdi'
        ; algorithm: using the formula - s = n * (n + 1) / 2 
        mov     rax, rdi
        inc     rax
        mul     rdi
        mov     rdi, 2
        div     rdi
        ret
        
    sum_conssq:         
        ; calculates the sum of squares of numbers from 1 up to the integer stored in 'rdi'
        ; algorithm: using the formula - s = n * (n + 1) * (2*n + 1) / 6 
        mov     rsi, rdi
        mov     rax, rsi
        inc     rax
        mul     rsi
        mov     rsi, rax
        mov     rax, rdi
        mov     rdi, 2
        mul     rdi
        inc     rax
        mul     rsi
        mov     rdi, 6
        div     rdi
        ret
        
    isqrt:
        ; calculates the square root of an integer to the nearest integer
        ; algorithm: convert the built-in FP square root function to integer
        cvtsi2sd    xmm0, rdi
        sqrtsd      xmm1, xmm0
        cvttsd2si    rax, xmm1
        ret

    num_digits:
        ; counts the number of digits of an integer
        ; algorithm: count the number of times to divide n by 10 until until quotient is zero
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _rcx:qword
        enter %$localsize,0
            mov     qword [_rcx], rcx
            mov     rax, rdi
            mov     rcx, 1
            mov     rsi, 10
            .count_loop:
                xor     rdx,rdx
                div     rsi
                cmp     rax, 0
                je      .exit_loop
                inc     rcx
                jmp     .count_loop
            .exit_loop:
            mov     rax, rcx
            mov     rcx, [_rcx]
        leave
        ret
        %pop
        
    sum_digits:
        ; calculates the sum of digits of an integer
        ; algorithm: same principle as 'num_digits' but adding the remainders
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _rcx:qword
        enter %$localsize,0
            mov     qword [_rcx], rcx
            mov     rax, rdi
            xor     rcx, rcx
            mov     rsi, 10
            .count_loop:
                xor     rdx,rdx
                div     rsi
                add     rcx, rdx
                cmp     rax, 0
                je      .exit_loop
                jmp     .count_loop
            .exit_loop:
            mov     rax, rcx
            mov     rcx, [_rcx]
        leave
        ret
        %pop
        
    ppowp:
        ; calculates the positive integer power of a positive integer
        ; algorithm: using exponentiation by squaring (https://en.wikipedia.org/wiki/Exponentiation_by_squaring/)
        ; note: this function breaks down if the result is greater than 2^64 - 1
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _rcx:qword
        enter %$localsize,0
            mov     qword [_rcx], rcx
            mov     rax, 1
            mov     rcx, 1
            .pow_loop:
                mul     rdi
                mov     rdi, rax
                shr     rsi, 1
                jnc     .skip_mul
                mov     rax, rcx
                mul     rdi
                mov     rcx, rax
                mov     rax, rdi
                .skip_mul:
                    cmp     rsi, 0
                    jne      .pow_loop
            mov     rax, rcx
            mov     rcx, [_rcx]
        leave
        ret
        %pop
        
    ppowf:
        ; calculates the positive integer power of a floating point number
        ; algorithm: using exponentiation by squaring
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _xmm1:qword, _xmm2:qword
        enter %$localsize,0
            movsd   qword [_xmm1], xmm1
            movsd   qword [_xmm2], xmm2
            mov        rax, 1
            cvtsi2sd   xmm1, rax
            cvtsi2sd   xmm2, rax
            .pow_loop:
                mulsd   xmm1, xmm0
                movsd   xmm0, xmm1
                shr     rdi, 1
                jnc     .skip_mul
                mulsd   xmm2, xmm0
                .skip_mul:
                    cmp     rdi, 0
                    jne      .pow_loop
            movsd   xmm0, xmm2
            movsd   xmm1, qword [_xmm1]
            movsd   xmm2, qword [_xmm2]
        leave
        ret
        %pop

    fpow2:
        ; raises 2 to positive floating-point power
        ; algorithm: using the x87 FPU function 'f2xml' for the fractional part of the 
        ;            exponent + our derived function 'ppowf' for the integer part, then
        ;            combining the exponents using the formula: a^(x+y) = (a^x)*(a^y)
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _tmp1:qword, _tmp2:qword
        enter %$localsize,0
            ; prepare variables
            cvttsd2si   rdi, xmm0
            cvtsi2sd    xmm1, rdi
            subsd       xmm0, xmm1
            movsd       qword [_tmp1], xmm0
            mov         qword [_tmp2], 2
            ; evaluate integer exponent
            cvtsi2sd    xmm0, qword [_tmp2]
            call        ppowf
            movsd       qword [_tmp2], xmm0
            ; evaluate fractional exponent
            fld         qword [_tmp1]
            f2xm1
            fld1
            fadd
            fst         qword [_tmp1]
            ; combine integer and fractional exponent parts
            movsd       xmm0, [_tmp1]
            mulsd       xmm0, [_tmp2]
        leave
        ret
        %pop
        
    log2:
        ; calculates the base-2 logarithm of number
        ; algorithm: using the x87 FPU function 'fyl2x'
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _tmp:qword
        enter %$localsize,0
            movsd       qword [_tmp], xmm0
            fld1
            fld         qword [_tmp]
            fyl2x
            fst         qword [_tmp]
            movsd       xmm0, [_tmp]
        leave
        ret
        %pop
        
    logb:
        ; calculates the logarithm of number to any given base
        ; algorithm: using the formula: log(b,a) = log2(a) / log2(b)
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _tmp:qword
        enter %$localsize,0
            call    log2
            movsd   qword [_tmp], xmm0
            movsd   xmm0, xmm1
            call    log2
            movsd   xmm1, qword [_tmp]
            divsd   xmm0, xmm1
        leave
        ret
        %pop
        
    num_digits2:
        ; counts the number of digits of an integer
        ; algorithm: but this time using logarithms
        cvtsi2sd    xmm1, rdi
        mov         rdi, 10
        cvtsi2sd    xmm0, rdi
        call        logb
        cvttsd2si   rax, xmm0
        inc         rax
        ret
        
    fpowf:
        ; calculates the floating-point power of a floating-point number
        ; algorithm: using the formula: x^y = 2^(y*log2(x)), then
        ;            the derived functions 'fpow2' and 'log2'       
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _xmm2:qword
        enter %$localsize,0
            movsd           qword [_xmm2], xmm2
            mov rdi,        0
            cvtsi2sd        xmm2, rdi
            ucomisd         xmm1, xmm2
            jb              .neg
            .pos:
                call        log2
                mulsd       xmm0, xmm1
                call        fpow2
                jmp         .end
            .neg:
                negsd       xmm1
                call        log2
                mulsd       xmm0, xmm1
                call        fpow2
                mov rdi,    1
                cvtsi2sd    xmm2, rdi
                divsd       xmm2, xmm0
                movsd       xmm0, xmm2   
            .end: movsd     xmm2, qword [_xmm2]
        leave
        ret
        %pop

    fibo_num:
        ; calculates the fibonacci of a certain rank
        ; algorithm: uses 'fibonacci computation by rounding' method 
        ;            (https://en.wikipedia.org/wiki/Fibonacci_number#Computation_by_rounding)
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _xmm1:qword
        enter %$localsize,0
            movsd       qword [_xmm1], xmm1
            mov         rax, __float64__(1.6180339887498948482045868343656) ; loads the 'golden ratio' constant 'phi'
            movq        xmm0, rax
            mov         rax, __float64__(2.2360679774997896964091736687313) ; loads the square root of 5
            movq        xmm1, rax
            divsd       xmm0, xmm1
            mov         rax, __float64__(0.50) ; loads 1/2
            movq        xmm1, rax
            addsd       xmm0, xmm1
            cvttsd2si   rax, xmm0
            movsd       xmm1, qword [_xmm1]
        leave
        ret
        %pop
        
    fibo_len:
        ; calculates the number of digits of a fibonacci number of a certain rank
        ; algorithm: uses 'fibonacci computation by rounding' method 
        ;            (https://en.wikipedia.org/wiki/Fibonacci_number#Computation_by_rounding)
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _xmm1:qword, _xmm2:qword
        enter %$localsize,0
            movsd       qword [_xmm1], xmm1
            movsd       qword [_xmm2], xmm2
            mov         rax, __float64__(1.6180339887498948482045868343656) ; loads the 'golden ratio' constant 'phi'
            movq        xmm1, rax
            mov         rax, __float64__(10.00) ; 10 is the base of the to get the number of digits
            movq        xmm0, rax
            call        logb
            cvtsi2sd    xmm2, rdi
            mulsd       xmm2, xmm0
            mov         rax, __float64__(2.2360679774997896964091736687313) ; loads the square root of 5
            movq        xmm1, rax
            mov         rax, __float64__(10.00)
            movq        xmm0, rax
            call        logb
            subsd       xmm2, xmm0    
            cvttsd2si   rax, xmm2
            inc         rax
            movsd       xmm2, qword [_xmm2]
            movsd       xmm1, qword [_xmm1]
        leave
        ret
        %pop

    fibo_rank:
        ; calculates the rank of a fibonacci number nearest but less than a given number
        ; algorithm: uses 'fibonacci computation by rounding' method 
        ;            (https://en.wikipedia.org/wiki/Fibonacci_number#Computation_by_rounding)
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _xmm1:qword
        enter %$localsize,0
            movsd       qword [_xmm1], xmm1
            mov         rax, __float64__(2.2360679774997896964091736687313) ; loads the square root of 5
            movq        xmm0, rax
            cvtsi2sd    xmm1, rdi
            mulsd       xmm0, xmm1
            mov         rax, __float64__(0.50) ; loads 1/2
            movq        xmm1, rax
            addsd       xmm0, xmm1
            movsd       xmm1, xmm0
            mov         rax, __float64__(1.6180339887498948482045868343656) ; loads the 'golden ratio' constant 'phi'
            movq        xmm0, rax
            call        logb
            cvttsd2si   rax, xmm0
            movsd       xmm1, qword [_xmm1]
        leave
        ret
        %pop
        
    rev_digits:
        ; reverses the digits of an integer
        ; algorithm: same principle as 'num_digits'
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _rcx:qword, _rax:qword, _rdx:qword, _ndig:qword
        enter %$localsize,0
            mov     qword [_rcx], rcx
            mov     rax, rdi
            mov     qword [_rax], rax
            call    num_digits2
            mov     qword [_ndig], rax
            mov     rax, [_rax]
            xor     rcx, rcx
            mov     rdi, 10
            .count_loop:
                dec     qword [_ndig]
                xor     rdx,rdx
                div     rdi
                mov     qword [_rax], rax
                mov     qword [_rdx], rdx
                mov     rsi, [_ndig]
                call    ppowp
                mov     rsi, rax
                mov     rax, [_rdx]    
                mul     rsi
                add     rcx, rax
                mov     rax, [_rax]
                mov     rdi, 10
                cmp     qword [_ndig], 0
                je      .exit_loop
                jmp     .count_loop
            .exit_loop:
            mov     rax, rcx
            mov     rcx, [_rcx]
        leave
        ret
        %pop
        
    prime_sieve:
        ; implements the sieve of erathosthenes
        ; algorithm: filter out composites from a given array
        ; note: there are 2 arguments. 'rdi' contains the 'length-1' of the array
        ;       to be filtered, while 'rsi' contains a pointer to the array
        ;       the array should be byte array containing only '1s' except for
        ;       the first 2 elements which contains '0s'
        ;       there is no output value but the array will be modified on return
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local c:qword, b:qword, lim:qword, len:qword, _rbx:qword
        enter %$localsize,0
            mov     qword [_rbx], rbx
            mov     qword [len], rdi
            call    isqrt
            mov     qword [lim], rax
            mov     qword [c], 0
            .start:
                mov     rbx, [c]
                cmp     rbx, [lim]
                jg      .end     
                mov     rbx, rsi
                add     rbx, [c]
                cmp     byte [rbx], 0
                jne     .sieve
            .restart:
                add     qword [c], 1
                jmp     .start
            .sieve:
                mov     rax, [c]
                mul     rax
                mov     qword [b], rax
            .cont_sieve:
                mov     rbx, [b]
                cmp     rbx, [len]
                jg      .restart
                mov     rbx, rsi
                add     rbx, [b]
                mov     byte [rbx], 0
                mov     rbx, [b]
                add     rbx, [c]
                mov     qword [b], rbx
                jmp     .cont_sieve
            .end:
            mov rbx, [_rbx]     
        leave
        ret
        %pop
        
    %macro chr2int 1-2 
        ; converts a integer character into an integer digit
        ; note: %1 must represent a single integer digit only
        %if %0 = 1
            sub %1, 48          ; '48' is the character representation of the digit '0'
        %else
            sub %1 %2, 48
        %endif
    %endmacro
    
    gcd:
        ; calculates the greatest common divisor of two integers
        ; algorithm: uses the popular "euclidean algorithm"
        .start:
            mov     rax, rdi
            xor     rdx, rdx
            div     rsi
            cmp     rdx, 0
            je      .end
            mov     rdi, rsi
            mov     rsi, rdx
            jmp     .start
        .end:
            mov     rax, rsi
            ret
            
    lcm:
        ; calculates the least common multiple of 2 integers
        ; algorithm: apply the "gcd" function
        mov     r8, rdi
        mov     r9, rsi
        call    gcd
        mov     r10, rax
        mov     rax, r8
        mul     r9
        xor     rdx, rdx
        div     r10
        ret

    pyth_triple:
        ; produce a pythagorean triple, give two odd integers
        ; algorithm: uses the variant formula in: https://en.wikipedia.org/wiki/Pythagorean_triple#A_variant
        ; note: 'rdi' and 'rsi' must be both odd with [rdi] > [rsi]. 'r9' contains
        ; the address of the 'qword' array of 3 integers where the output triples will be stored
        mov     rax, rdi
        mul     rsi
        mov     qword [r9], rax
        mov     rax, rsi
        mul     rax
        mov     rsi, rax
        mov     rax, rdi
        mul     rax
        mov     rdi, rax
        sub     rax, rsi
        xor     rdx, rdx
        mov     r15, 2
        div     r15
        mov     qword [r9+8], rax
        mov     rax, rdi
        add     rax, rsi
        xor     rdx, rdx
        div     r15
        mov     qword [r9+16], rax
        ret

    pow_mod:
        ; calculates the modulus of a power of a positive integer
        ; algorithm: using exponentiation by squaring similar to the function 'ppowp'
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _rcx:qword
        enter %$localsize,0
            mov     qword [_rcx], rcx
            mov     rax, 1
            mov     rcx, 1
            .pow_loop:
                mul     rdi
                xor     rdx, rdx
                div     r9
                mov     rax, rdx
                mov     rdi, rdx
                shr     rsi, 1
                jnc     .skip_mul
                mov     rax, rcx
                mul     rdi
                xor     rdx, rdx
                div     r9
                mov     rcx, rdx
                mov     rax, rdi
                .skip_mul:
                    cmp     rsi, 0
                    jne      .pow_loop
            mov     rax, rcx
;            xor     rdx, rdx
;            div     r9
;            mov     rax, rdx
            mov     rcx, [_rcx]
        leave
        ret
        %pop
     
    is_prime:
        ; determines if a given positive integer is a prime number
        ; algorithm: this will make use of the famous "Miller-Rabin Primality Test" (https://primes.utm.edu/prove/prove2_3.html)
        ; output: sets the 'rax' to TRUE if the input number is prime or FALSE if the input number is composite
        ; note: this algorithm can positively identify primes up to 18,446,744,073,709,551,616 (i.e. 2^64).
        ; therefore, this literally covers all the possible values of integers in a 64-bit system, at least in theory.
        ; in practice, however, this implementation breaksdown for primes larger than 2^32. we don't know the reason yet.
        ; let's just hope that we don't have to deal with primes larger than that.
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _n0:qword, _n1:qword, _d:qword 
        enter %$localsize,0
            mov     qword [_n0], rdi
            ; 1. remove obvious candidates
            cmp     rdi, 2
            je      .prime
            jl      .composite
            mov     rax, 3215031751
            cmp     rdi, rax
            je      .composite
            shr     rdi, 1
            jnc     .composite
            ; 2. start test
            mov     rax, [_n0]
            dec     rax
            mov     qword [_n1], rax
        .start:     
            shr     rax, 1
            jnc     .start
            shl     rax, 1
            add     rax, 1
            mov     qword [_d], rax
            mov     r9, [_n0]
            cmp     r9, 2047
            jl      .test2
            cmp     r9, 1373653
            jl      .test3
            cmp     r9, 25326001
            jl      .test5
            mov     rax, 118670087467
            cmp     r9, rax
            jl      .test7
            mov     rax, 2152302898747
            cmp     r9, rax
            jl      .test11
            mov     rax, 3474749660383
            cmp     r9, rax
            jl      .test13
            mov     rax, 341550071728321
            cmp     r9, rax
            jl      .test17
            mov     rax, 3825123056546413051
            cmp     r9, rax
            jl      .test19_23
        .test29_31_37:
            mov     rdi, 37
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
            mov     rdi, 31
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
            mov     rdi, 29
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
        .test19_23:
            mov     rdi, 23
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
            mov     rdi, 19
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite                         
        .test17:
            mov     rdi, 17
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite             
        .test13:
            mov     rdi, 13
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite            
        .test11:
            mov     rdi, 11
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
        .test7:
            mov     rdi, 7
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
        .test5:
            mov     rdi, 5
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
        .test3:
            mov     rdi, 3
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
        .test2:
            mov     rdi, 2
            mov     rsi, [_d]
            mov     r9, [_n0]
            mov     rcx, [_n1]
            call    miller_rabin
            cmp     rax, FALSE
            je      .composite
        .prime:
            mov     rax, TRUE
            jmp     .end
        .composite:
            mov     rax, FALSE
        .end:     
        leave
        ret
        %pop
        miller_rabin:
            mov         r10, rdi
            mov         r11, rsi
            mov         r12, r9
            mov         r13, rcx
            call        pow_mod
            cmp         rax, 1
            je         .prime
            .test: 
;                mov     rdi, r10
;                mov     rsi, r11
;                mov     r9, r12
;                call    pow_mod
                xor     rdx, rdx
                div     r9
                mov     rax, rdx
                cmp     rax, r13
                je      .prime
                shl     r11, 1
                cmp     r11, r13
                je      .composite
                mul     rax
                jmp     .test
            .composite:
                mov     rax, FALSE
                jmp     .end
            .prime:
                mov     rax, TRUE
            .end:              
            ret   
            
    num_divs:
        ; counts the number divisors of a given number including itself
        ; algorithm: divide the number (n) with numbers from 1 to sqrt(n)
        ;            and count which one is divisible by n.
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _rcx:qword, _rbx:qword, _rdx:qword, _num:qword, _cnt:qword;
        enter %$localsize,0
            mov     qword [_rcx], rcx
            mov     qword [_rbx], rbx
            mov     qword [_rdx], rdx
            mov     qword [_num], rdi
            mov     qword [_cnt], 0
            cmp     rdi, 0
            je      .end
            mov     qword [_cnt], 1
            cmp     rdi, 1
            je      .end
            call    isqrt
            mov     qword [_cnt], 2
            mov     rbx, rax
            mov     rcx, 1
            .divloop:
                inc rcx
                cmp rcx, rbx
                jg  .end
                mov rax, [_num]
                xor rdx, rdx
                div rcx
                cmp rdx, 0
                jne .divloop
                add qword [_cnt], 2
                cmp rax, rbx
                jne  .divloop
                dec qword [_cnt]
                jmp .end
            .end:
            mov     rax, [_cnt]
            mov     rdx, [_rdx]
            mov     rbx, [_rbx]
            mov     rcx, [_rcx]
        leave
        ret
        %pop
        
    sum_divs:
        ; calculates the sum of the proper divisors of a given number
        ; algorithm: divide the number (n) with numbers from 1 to sqrt(n)
        ;            and sum those which one is divisible by n.
        %push
        %stacksize flat64
        %assign %$localsize 0
        %local _rcx:qword, _rbx:qword, _rdx:qword, _num:qword, _sum:qword;
        enter %$localsize,0
            mov     qword [_rcx], rcx
            mov     qword [_rbx], rbx
            mov     qword [_rdx], rdx
            mov     qword [_num], rdi
            mov     qword [_sum], 0
            cmp     rdi, 1
            jle      .end
            mov     qword [_sum], 1
            cmp     rdi, 3
            jle      .end
            call    isqrt
            mov     rbx, rax
            mov     rcx, 1
            .divloop:
                inc rcx
                cmp rcx, rbx
                jg  .end
                mov rax, [_num]
                xor rdx, rdx
                div rcx
                cmp rdx, 0
                jne .divloop
                add qword [_sum], rax
                cmp rax, rcx
                je  .end
                add qword [_sum], rcx
                jmp .divloop
            .end:
            mov     rax, [_sum]
            mov     rdx, [_rdx]
            mov     rbx, [_rbx]
            mov     rcx, [_rcx]
        leave
        ret
        %pop
         
    triangular:         
        ; calculates the nth triangular number
        ; algorithm: using the formula - s = n * (n + 1) / 2 
        mov     rax, rdi
        inc     rax
        mul     rdi
        mov     rdi, 2
        div     rdi
        ret 
        
    collatz_len:
        ; calculates the length of the collatz sequence of a given positive integer
        ; algorithm: count the collatz term via brute force
        mov         rax, 1
        .sequence:
            cmp     rdi, 1
            je      .end
            inc     rax
            mov     rbx, rdi
            shr     rbx, 1
            jnc     .even
            imul    rdi, 3
            add     rdi, 1
            jmp     .sequence
        .even:
            mov     rdi, rbx   
            jmp     .sequence
        .end:
        ret 
        
    max:
        ; find the maximum of the values inside two registers
        ; algorithm: just compare
        mov     rax, rdi
        cmp     rdi, rsi
        jge     .end
        mov     rax, rsi
        .end:
        ret  
        
    min:
        ; find the minimum of the values inside two registers
        ; algorithm: just compare
        mov     rax, rdi
        cmp     rdi, rsi
        jle     .end
        mov     rax, rsi
        .end:
        ret
        
    factorial:
        ; calculate the factorial of a number
        ; algorithm: just multiply
        ; note: up to 20! only
        mov     rax, 1
        cmp     rdi, 1
        jle     .end
        .start:
            mul rdi
            dec rdi
            cmp rdi, 0
            jle .end
            jmp .start
        .end:
        ret
        
    mult_order:
        ; calculates the multiplicative order of a number to a given base
        ; algorithm: multiply and divide until the remainder becomes '1'
        mov     r8, 0
        mov     rax, 1
        .start:
            inc r8
            mul rsi
            xor rdx, rdx
            div rdi
            cmp rdx, 1
            je  .end
            mov rax, rdx
            jmp .start
        .end:
        mov     rax, r8
        ret
         
%endif