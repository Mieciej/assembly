bits    64
default rel

global  main

extern  printf
extern  scanf
section .data
    i_format    db '%i %lf', 0    
    o_format    db 'e^x = %f', 0xa,0
    const       dq  1.0
section .bss
    k           resd 1
    x           resq 1
section .text
    main:
        sub     rsp, 8
        lea     rdx, [x]
        lea     rsi, [k]
        lea     rdi, [i_format]
        mov     al, 0  
        call    scanf wrt ..plt

        movsd   xmm1, [const]   ; series
        movsd   xmm2, [const]   ; numerator
        movsd   xmm3, [const]   ; denumerator
        movsd   xmm4, [x]
        mov     rdx,  [k]
        mov     rcx, 1          ; loop counter [i]
    
    repeat:
        cmp     rcx, rdx        ; check if number of iterations > k
        jg      exit
        mulsd   xmm2, xmm4      ; multiply numerator by x
        cvtsi2sd xmm0, rcx      ; convert rcx to double
        mulsd   xmm3, xmm0      ; multiply denominator by i
        movsd   xmm0, xmm2      ; divide numerator/denonimator
        divsd   xmm0, xmm3
        addsd   xmm1, xmm0      ; add result to the series
        inc     rcx 
        jmp repeat
    exit:
        movsd   xmm0, xmm1
        lea     rdi, [o_format]
        mov     al, 1   
        call    printf wrt ..plt


        add     rsp, 8
        sub     rax, rax
        ret