%ifndef STRUCTURES

    %define STRUCTURES STRUCTURES
    
    %include "sysio64.inc"
    extern exit, malloc, calloc, realloc, free
    
    ; --------------------------- DATA STRUCTURES IMPLEMENTATION -------------------------------;
    ;                                                                                           ;
    ;   The following sets of macro aims to implement the common data structures used           ;
    ;   in computer programming.                                                                ;
    ;                                                                                           ;
    ;   Among the data structures planned to be implemented are:                                ;
    ;                                                                                           ;
    ;       1. 2D Array called "Matrix"                                                         ;
    ;       2. Dynamic Array called "Vector"                                                    ;
    ;       3. Linked List called "List"                                                        ;
    ;       4. Object-oriented structure called "Class"                                         ;
    ;                                                                                           ;
    ; ------------------------------------------------------------------------------------------;
    
    
    %define TRUE 1
    %define FALSE 0
    
    ; data types
    %define _byte 1
    %define _word 2
    %define _dword 4
    %define _qword 8
    
    ; -------------- MATRIX IMPLEMENTATION ---------------

    %macro arr2mat 4
        ; converts an array into a 2-dimensional matrix array
        ; and make a function-like access to the matrix
        ; arguments:    %1 - data type as defined above
        ;               %2 - name of an 'existing' array
        ;               %3 - row size
        ;               %4 - column size
        %define %2(x,y) %2, %1, %3, %4, x, y 
    %endmacro
            
    %macro movm2r 7
        ; moves an array cell to a register
        ; note: first argument must be a register, do not use rdi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range...", 0
        SECTION     .text
            mov     rdi, %7
            cmp     rdi, %5
            jge     %%err
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     qword [%%tmp], %4
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %7
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            add     rdi, %2
            mov     %1, qword [rdi]
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro addm2r 7
        ; moves an array cell to a register
        ; note: first argument must be a register, do not use rdi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, %7
            cmp     rdi, %5
            jge     %%err
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     qword [%%tmp], %4
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %7
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            add     rdi, %2
            add     %1, qword [rdi]
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro subm2r 7
        ; moves an array cell to a register
        ; note: first argument must be a register, do not use rdi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, %7
            cmp     rdi, %5
            jge     %%err
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     qword [%%tmp], %4
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %7
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            add     rdi, %2
            sub     %1, qword [rdi]
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro mulm2r 7
        ; moves an array cell to a register
        ; note: first argument must be a register, do not use rdi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, %7
            cmp     rdi, %5
            jge     %%err
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     qword [%%tmp], %4
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %7
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            add     rdi, %2
            imul    %1, qword [rdi]
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro movr2m 7
        ; moves a register to an array cell
        ; note: last argument must be a register, do not use rdi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     rdi, %5
            cmp     rdi, %3
            jge     %%err
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %6
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %2
            imul    rdi, [%%tmp]
            add     rdi, %1
            mov     qword [rdi], %7
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro addr2m 7
        ; moves a register to an array cell
        ; note: last argument must be a register, do not use rdi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     rdi, %5
            cmp     rdi, %3
            jge     %%err
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %6
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %2
            imul    rdi, [%%tmp]
            add     rdi, %1
            add     qword [rdi], %7
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro subr2m 7
        ; moves a register to an array cell
        ; note: last argument must be a register, do not use rdi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     rdi, %5
            cmp     rdi, %3
            jge     %%err
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %6
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %2
            imul    rdi, [%%tmp]
            add     rdi, %1
            sub     qword [rdi], %7
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro mulr2m 7
        ; moves a register to an array cell
        ; note: last argument must be a register, do not use rdi and rsi
        SECTION     .data
            %%tmp   dq 0
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, %6
            cmp     rdi, %4
            jge     %%err
            mov     rdi, %5
            cmp     rdi, %3
            jge     %%err
            mov     qword [%%tmp], %3
            imul    rdi, [%%tmp]
            mov     qword [%%tmp], %6
            add     rdi, [%%tmp]
            mov     qword [%%tmp], %2
            imul    rdi, [%%tmp]
            add     rdi, %1
            mov     rsi, qword [rdi]
            imul    rsi, %7
            mov     qword [rdi], rsi
            jmp     %%end  
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    
    ; -------------- VECTOR IMPLEMENTATION ---------------
    
    %macro vector 3
        ; implements a dynamic array
        ; arguments:    %1 - data type as defined above
        ;               %2 - name of the vector
        ;               %3 - register to be used as pointer
        ;                    care must be taken to not unnecessarily
        ;                    delete this pointer nor use them to 
        ;                    to hold other values/address. non-volatile
        ;                    registers (r12-r15) is suggested                 
        %define     %2 %3
        %define     %3(x) %3, x
        SECTION .data
            __%3sa   dq  0    ; apparent size of vector
            __%3st   dq  100  ; true size of vector
            __%3tp   dq  %1   ; data type of vector
            %%er     db       "Error: Failed to allocate memory..."
        SECTION .text
            %ifidn __OUTPUT_FORMAT__, win64
                mov     rcx, %1
                imul    rcx, 100     ; put initial buffer of 100 elements
                sub     rsp, 40
                call    malloc
                add     rsp, 40
                test    rax, rax
                jz      %%err
                mov     %2, rax
                jmp     %%end
            %elifidn __OUTPUT_FORMAT__, elf64
                mov     rdi, %1
                imul    rdi, 100
                call    malloc
                test    rax, rax
                jz      %%err
                mov     %2, rax
                jmp     %%end
            %endif
        %%err:
            write_str %%er
            call exit
        %%end:
    %endmacro
    
    %macro resz_vec 1
        SECTION .data
            %%er     db       "Error: Failed to allocate memory..."
        SECTION .text
            add         qword [__%1st], 100        ; add another 100 elements
            %ifidn __OUTPUT_FORMAT__, win64
                mov     rcx, %1
                mov     rdx, [__%1st]
                imul    rdx, [__%1tp]        
                sub     rsp, 40
                call    realloc
                add     rsp, 40
                test    rax, rax
                jz      %%err
                mov     %1, rax
                jmp     %%end
            %elifidn __OUTPUT_FORMAT__, elf64
                mov     rdi, %1
                mov     rsi, [__%1st]
                imul    rsi, [__%1tp]
                call    realloc
                test    rax, rax
                jz      %%err
                mov     %1, rax
                jmp     %%end
            %endif
        %%err:
            write_str %%er
            call exit
        %%end:   
    %endmacro
    
    %macro lenv 2
        ; gets the current size of a vector and saves it on a register
        ; note: first argument must be a register
        mov %1, [__%2sa]
    %endmacro
    
    %macro setv 3
        ; sets the value of an existing vector element
        SECTION     .data
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, [__%1sa]
            dec     rdi
            cmp     rdi, %2
            jl      %%err
            mov     rdi, %2
            imul    rdi, [__%1tp]
            add     rdi, %1
            mov     qword [rdi], %3
            jmp     %%end
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro pushv 2
        ; adds a value to the end of a vector
        mov         rdi, [__%1sa]
        imul        rdi, [__%1tp]
        add         rdi, %1
        mov         qword [rdi], %2
        inc         qword [__%1sa]
        mov         rdi, [__%1sa]
        cmp         rdi, [__%1st]
        jl          %%end
        resz_vec    %1
        %%end:
    %endmacro
    
    %macro getv 3
        ; gets the value of an existing vector element and save it on a register
        ; note: first element must be a register
        SECTION     .data
            %%er    db "Error: Data out of range..."
        SECTION     .text
            mov     rdi, [__%2sa]
            dec     rdi
            cmp     rdi, %3
            jl      %%err
            mov     rdi, %3
            imul    rdi, [__%2tp]
            add     rdi, %2
            mov     %1, [rdi]
            jmp     %%end
            %%err:
                write_str %%er
                call exit
            %%end:
    %endmacro
    
    %macro gendv 2
        ; gets the last element of a vector and saves the value on a register
        mov     rdi, [__%2sa]
        dec     rdi
        imul    rdi, [__%2tp]
        add     rdi, %2
        mov     %1, [rdi]
    %endmacro
    
    %macro popv 2
        ; gets the last element of a vector, saves the value on a register,
        ; and then removes the last element
        mov     rdi, [__%2sa]
        dec     rdi
        imul    rdi, [__%2tp]
        add     rdi, %2
        mov     %1, [rdi]
        mov     qword [rdi], 0
        dec     qword [__%2sa] 
    %endmacro
         
%endif