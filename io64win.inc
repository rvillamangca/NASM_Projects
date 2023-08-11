extern printf

%ifnmacro pushad64 0    
    %macro pushad64 0   ; emulates 'pushad' which is not available in x64
        SECTION     .text
            push rax
            push rbx
            push rcx
            push rdx
    %endmacro
%endif

%ifnmacro popad64 0
    %macro popad64 0    ; emulates 'popad' which is not available in x64
        SECTION     .text
            pop rdx
            pop rcx
            pop rbx
            pop rax
    %endmacro
%endif

%macro write_dec 1  ; prints an integer to the screen
    pushad64
    SECTION     .data
        %%fmt   db "%d", 0
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