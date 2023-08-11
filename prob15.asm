;----------------------- PROJECT EULER PROBLEM NO. 015 - LLattice paths ---------------------;
;                                                                                            ;
;   Starting in the top left corner of a 2x2 grid, and only being able to move to the right  ;
;   and down, there are exactly 6 routes to the bottom right corner.                         ;
;                                                                                            ;
;   How many such routes are there through a 20x20 grid?                                     ;           
;                                                                                            ;
;--------------------------------------------------------------------------------------------;


;   this is another problem that at first glance is difficult but actually can be done by hand.
;   to get to the bottom right corner of 20x20 grid, we have to traverse to the right 20 units
;   and down 20 units. so we only have to calculate the number of routes to traverse 20-downs
;   and 20-rights. the problem is therefore reduced to "permutation with repetition" with
;   formula: 40! / (20! x (40 - 20)!). which reduces to (40x39x38...x21) / (20x19x18...x1).
;   we also notice that (40x38x36...x22) / (20x19x18...x11) = 2^10. also, 8*4*2*1 = 2^6.
;   so we can further reduce this to: 
;       40! / (20! x (40 - 20)!) = ((39x37x35...x21)x2^10) / ((10x9x7x6x5x3)x2^6)
;                                = ((39x37x35...x21)x16) / (10x9x7x6x5x3)

%include "euler.inc"

global  main

    section .text    
main:
    enter   0,0
    
    mov     rax, (39*37*35*33*31*29*27*25*23*21)*16/(10*9*7*6*5*3)
    
    print_answer "015", INTEGER, rax
    
    leave
    xor     rax, rax
    ret