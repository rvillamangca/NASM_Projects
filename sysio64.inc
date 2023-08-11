%ifndef SYSIO64

    %define SYSIO64 SYSIO64
    
    extern printf
    extern scanf
    extern getchar
 
    
    ;--------- COMMON -----------
     
    %macro pushad64 0   ; emulates 'pushad' which is not available in x64
        SECTION     .text
            push    rax
            push    rbx
            push    rcx
            push    rdx
    %endmacro
    
    %macro popad64 0    ; emulates 'popad' which is not available in x64
        SECTION     .text
            pop     rdx
            pop     rcx
            pop     rbx
            pop     rax
    %endmacro
    
    
    ;--------- SCREEN OUTPUT -----------
    
    %macro write_dec 1  ; prints an integer to the screen
        pushad64
        SECTION     .data
            %%fmt   db "%lld", 0
        SECTION     .text
            %ifidn __OUTPUT_FORMAT__, win64
                mov     rcx, %%fmt
                mov     rdx, %1
                sub     rsp, 40
                call    printf
                add     rsp, 40
            %elifidn __OUTPUT_FORMAT__, elf64
                mov     rdi, %%fmt
                mov     rsi, %1
                call    printf
            %endif
        popad64
    %endmacro
    
    %macro write_udec 1  ; prints an unsigned integer to the screen
        pushad64
        SECTION     .data
            %%fmt   db "%llu", 0
        SECTION     .text
            %ifidn __OUTPUT_FORMAT__, win64
                mov     rcx, %%fmt
                mov     rdx, %1
                sub     rsp, 40
                call    printf
                add     rsp, 40
            %elifidn __OUTPUT_FORMAT__, elf64
                mov     rdi, %%fmt
                mov     rsi, %1
                call    printf
            %endif
        popad64
    %endmacro
    
    %macro write_flt 1  ; prints a floating point number to the screen
        pushad64
        SECTION     .data
            %%fmt   db "%f", 0
        SECTION     .text
            %ifidn __OUTPUT_FORMAT__, win64
                mov     rcx, %%fmt
                movq    xmm1, %1
                movq    rdx, %1
                sub     rsp, 40
                call    printf
                add     rsp, 40
            %elifidn __OUTPUT_FORMAT__, elf64
                mov     rdi, %%fmt
                movsd   xmm0, %1
                call    printf
            %endif
        popad64
    %endmacro
    
    %macro write_str 1  ; prints an string to the screen
        pushad64
        SECTION     .data
            %%fmt db "%s", 0
        SECTION     .text
            %ifidn __OUTPUT_FORMAT__, win64
                mov     rcx, %%fmt
                mov     rdx, %1
                sub     rsp, 40
                call    printf
                add     rsp, 40
            %elifidn __OUTPUT_FORMAT__, elf64
                mov     rdi, %%fmt
                mov     rsi, %1
                call    printf
            %endif
        popad64
    %endmacro
    
    %macro write_nl 0   ; moves the output cursor one line down
        SECTION     .data
            %%nl    db 10, 0
        SECTION     .text
            write_str %%nl
    %endmacro
    
    %macro write_sp 0   ; prints an empty space on the same line
        SECTION     .data
            %%sp    db 32, 0
        SECTION     .text
            write_str %%sp
    %endmacro
    
    %macro write_tb 0   ; prints a tab of space on the screen
        SECTION     .data
            %%tb    db 9, 0
        SECTION     .text
            write_str %%tb
    %endmacro
        
    
    ;--------- SCREEN INPUT -----------
    
    %macro clear_input 0  ; clears the input buffer
        pushad64
        SECTION     .text
            %ifidn __OUTPUT_FORMAT__, win64
                sub     rsp, 40
                call    getchar
                add     rsp, 40
            %elifidn __OUTPUT_FORMAT__, elf64
                call    getchar
            %endif
        popad64
    %endmacro
    
    %macro get_dec 1  ; gets an integer from the screen
        pushad64
        SECTION     .data
            %%fmt   db "%lld", 0
        SECTION     .text
            %ifidn __OUTPUT_FORMAT__, win64
                ;clr_in
                mov     rcx, %%fmt
                mov     rdx, %1
                sub     rsp, 40
                call    scanf
                add     rsp, 40
            %elifidn __OUTPUT_FORMAT__, elf64
                ;clr_in
                mov     rdi, %%fmt
                mov     rsi, %1
                call    scanf
            %endif
        popad64
    %endmacro
    
    %macro get_str 1  ; gets a string from the screen
        pushad64
        SECTION     .data
            %%fmt   db "%[^",10,"]s", 0
        SECTION     .text
            %ifidn __OUTPUT_FORMAT__, win64
                mov     rcx, %%fmt
                mov     rdx, %1
                sub     rsp, 40
                call    scanf
                add     rsp, 40
            %elifidn __OUTPUT_FORMAT__, elf64
                mov     rdi, %%fmt
                mov     rsi, %1
                call    scanf
            %endif
        popad64
    %endmacro

%endif