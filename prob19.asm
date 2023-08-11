;-------------------- PROJECT EULER PROBLEM NO. 019 - Number letter counts ------------------;
;                                                                                            ; 
;   You are given the following information, but you may prefer to do some research for      ;
;   yourself.                                                                                ;
;                                                                                            ;
;       * 1 Jan 1900 was a Monday.                                                           ;
;                                                                                            ;
;       * Thirty days has September, April, June and November.                               ;
;         All the rest have thirty-one, Saving February alone,                               ;
;         Which has twenty-eight, rain or shine. And on leap years, twenty-nine.             ;
;                                                                                            ;
;       * A leap year occurs on any year evenly divisible by 4, but not on a century unless  ;
;         it is divisible by 400.                                                            ;
;                                                                                            ;
;   How many Sundays fell on the first of the month during the twentieth century             ;
;   (1 Jan 1901 to 31 Dec 2000)?                                                             ; 
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   in this problem we developed the "weekday" macro, to calculate the weekday (0 = Sunday, etc.) 
;   for any given date in "yyy, mm, dd" format


%include "euler.inc"

global  main

    section .data
sundays:     dq 0

    section .text    
main:
    enter   0,0
    
    mov     r10, 1900
year:
    inc     r10
    cmp     r10, 2000
    jg      end_year
    mov     r11, 0
month:
    inc     r11
    cmp     r11, 12
    jg      end_month
    weekday r10, r11, 1
    cmp     rax, 0          ; 0 = Sunday
    jne     month
    inc     qword [sundays]
    jmp     month
end_month:
    jmp     year
end_year:
        
    print_answer "019", INTEGER, [sundays]
    
    leave
    xor     rax, rax
    ret