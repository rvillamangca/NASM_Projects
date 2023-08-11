%include "sysio64.inc"
%include "functions.inc"
%include "euler.inc"

extern calloc
extern malloc
extern realloc
extern free

%macro vec 1
    SECTION .data
        %%v     dq 5, 6
    SECTION .text    
        mov %1, %%v
%endmacro

%define LIMIT 114000 

global  main

    section .data
        ones    db 'one', "two"
        oneslen equ $-ones
;        num db 1, 2, 3, 4, 5, 6, 7, 8, 9, 0
;        zero times 8 db 48
;        three times 8 db 3
;        result times 9 db 0
;        
;        mynums dq 1
        
;        val3     dw 10, 9, 8, 1
;    value  dw 2, 2, 2, 2
;;    namex db "Ramon Villamangca", 0
;;    name times 25 db 0
;;    fmt db "%f", 0
;    val    dq 0, 1, 2,\
;              3, 4, 5,\
;              7, 8, 9
;    val2    dq 10, 11, 12,7,\
;              3, 4, 5,7,\
;              7, 8, 9,11,\
;              75,52,33,44
;
;        dbl dq 10.0
;        val4     dw 0.0, 0.0, 0.0, 0.0
; length = 5163,11

names: incbin "p022_names_no_quotes.txt"
txt: db 0, 71, 72, 73, 74
mary: db "rary", 0, 0
ramon: db "ramon", 0


    section .text  
main:
    enter   0,0
    
    mov     rdi, 7
    mov     rsi, 144
    call    lcm
    mov     rbx, rax
;    mov     rax, 3*3*3*3*3*3
;    mov     rbx, 7
;    xor     rdx, rdx
;    div     rbx
;    mov     rbx, rdx
    write_dec rbx
    
;    mov al, [names]
;    mov byte [txt], al
;    mov al, [names+1]
;    mov byte [txt+1], al
;    mov al, [names+2]
;    mov byte [txt+2], al
;    mov al, [names+3]
;    mov byte [txt+3], al
;    write_str txt
;    write_nl
;    
;    mov rbx, 10
;    mov rcx, 20
;    mov rdi, 70
;    lea rax, [rbx+rcx+70]
;    
;    write_dec rax
;    write_nl
;    
;    mov rcx, 284
;    mov rdi, rcx
;    call sum_divs
;    write_dec rcx
;    write_nl
    
;    
;    cmp_alpha mary, ramon, 6
;;    write_str ramon
;    write_dec rax
;    write_nl

;    mov rbx, 2018
;    mov rcx, 7
;;    write_dec rcx
;;    write_nl
;    weekday rbx, rcx, 17
;    mov r15, rcx
;    write_dec r15
    
;    movq mm0, [num]
;    paddb mm0, [zero]
;    movq qword [result], mm0
;    emms
;    write_str result
;    
;    write_nl
;    
;    mov rbx, [mynums]
;    shl rbx, 63
;    write_udec rbx
    
    
;    movq mm0, [num]
;    movq mm1, [three]
;    paddb mm0, mm1
;    movq qword [result], mm0
;    write_str result
    
;    vector _qword, vec, r15
;    resz_vec vec
;    mov rdi, vec
;    mov rsi, 800
;    call realloc
;    test rax, rax
;    jz end
;    mov vec, rax
;    mov qword [__r15sa],100
;    mov rax, 2
;    dec rax
;    mul qword [__r15tp]
;    add rax, vec
;    mov qword [rax], 10000
;    mov rdx, 555
;    setv vec(0), rdx
;   
;    pushv vec, rdx
;    pushv vec, 333
;    setv vec(0), 111
;    
;    write_dec [rax]
;    write_nl
;    
;    write_dec [vec]    
;    write_nl
;    
;    getv rbx, vec(1)
;    lenv rbx, vec
;    gendv rbx, vec
;    write_dec rbx
;    write_nl
;    popv rbx, vec
;    write_dec rbx
;    write_nl
;    gendv rbx, vec
;    ;mov rbx, [__r15sa]
;    write_dec rbx
;    write_nl
;    
;    mov rax, 9999999999
;    imul rax, 100
;    write_dec rax
;    
;    write_nl
;    
;    mov rdi, 0
;    call sum_digits
;    write_dec rax
    
    ;movupd xmm1, [value]
;    write_flt xmm1
;    write_nl
;   movupd xmm0, [val3]
;   write_flt xmm0
;   addpd  xmm1, xmm0
;   ;movq xmm0, xmm1
;    write_nl
;    write_flt xmm1
    
;    movq mm0, [val3]
;    movq mm1, [value]
;    psllw mm0, 6
;;    pmullw mm0, mm1
;    movq qword [val3], mm0
;    xor rbx, rbx
;    mov bx, word [val3+6]
;    emms
;    
;    write_dec rbx
    
end:    
    leave
    xor     rax, rax
    ret
    

 