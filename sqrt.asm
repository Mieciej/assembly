bits    64
default rel

global  main

extern  printf
extern  scanf
section .data
    i_format    db '%lf', 0
    o_format    db 'sqrt(%f) = %f',0xa,0
    const       dq 0.125
section .bss
    end         resq 1
section .text
    main:
        sub     rsp, 8


        lea     rsi, [end]
        lea     rdi, [i_format]
        mov     al, 0  
        call    scanf wrt ..plt
        
        subsd   xmm4, xmm4  ; current value being squared
        subsd   xmm5, xmm5  ; target value
        subsd   xmm6, xmm6  ; constant 0.125
        movsd   xmm5, qword [end]
        movsd   xmm6, qword [const]
    repeat:

        movsd     xmm0, xmm4 
        cmpltsd   xmm0, xmm5 ;   check if xmm0 is less than xmm4, we use xmm5 because the result of the comparision is stored there

        movq    rax, xmm0   ; we move result to rax
        cmp     rax, 0      ;  rax!=0 when true
        jz      exit
        sqrtsd  xmm1, xmm4  ; square xmm4 and store result in xmm1 
        movq    xmm0, xmm4  ; store xmm4 in xmm0
        lea     rdi, [o_format]
        mov     al, 2       ; xmm0 and xmm1 will be passed as arguments
        call    printf wrt ..plt
        addsd   xmm4, xmm6  ; increment xmm4 by 0.125
        jmp     repeat
    exit:
        add     rsp, 8
        sub     rax, rax
        ret