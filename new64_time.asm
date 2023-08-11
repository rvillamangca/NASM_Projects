    global  main
    extern  printf
    extern  time
    extern  clock
    extern  clock_tick

    section .data
timer:  dq  0
value:  dq  5
name:   db  "Problem 01",0
fmt:    db  "%s Answer:",9,"%d",10,0

    section .text
main:
    enter   0,0

;    mov     rcx, 0
;    sub     rsp, 40
;    call    time
;    add     rsp, 40
;    mov     qword [timer], rax
;
    mov     rcx, 10000000000
mloop1:
    loop    mloop1

;    mov     rcx, 10000000000
;mloop2:
;    loop    mloop2

;    mov     qword [timer], CLOCKS_PER_SEC

    sub     rsp, 40
    call    clock_tick
    add     rsp, 40
    mov     rbx, rax

    mov     rcx, 0
    sub     rsp, 40
    call    clock ;time
    add     rsp, 40
;    sub     rax, [timer]
;    mov     qword [timer], rax
    xor     rdx, rdx
    div     rbx
    mov     qword [timer], rax



    mov     rcx, fmt
    mov     rdx, name
    mov     r8, [timer] ;[value]
    sub     rsp, 40
    call    printf
    add     rsp, 40

    leave
    xor     rax, rax
    ret
