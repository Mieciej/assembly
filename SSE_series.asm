bits    64
default rel

global  main

extern  printf
extern  scanf
section .data
    i_format    db '%i %lf', 0    
    o_format    db 'e^x = %f', 0xa,0
    num_initial dq  1.0, 2.0
    const       dq  3.0
    series      dq  1.0
section .bss
    k           resd 1
    x           resq 1
    x_t         resq 2
    sum         resq 2
    n           resq 1
section .text
    main:
        sub     rsp, 8
        lea     rdx, [x]
        lea     rsi, [k]
        lea     rdi, [i_format]
        mov     al, 0  
        call    scanf wrt ..plt
        

        movlpd  xmm0, [x]
        movlpd  xmm3, [x]
        mulsd   xmm0, xmm0

        movlpd  [x_t], xmm0
        movhpd  xmm3, [x_t]
        movlpd  [x_t], xmm0

        movdqu  xmm2, [num_initial]
        mov     rcx, 1
        movsd   xmm4,[series] 
        mov     r8, [k]
        movq    xmm8, [const]
        movq    xmm9, [series]
    repeat:
        cmp     rcx, r8
        jg      exit


        movdqu  xmm7, xmm3
        divpd   xmm7, xmm2
        movupd  [sum], xmm7
        movlpd  xmm0, [sum]
        addsd   xmm4, xmm0
        movlpd  xmm0, [sum+8]
        addsd   xmm4, xmm0

        punpckhqdq xmm2, xmm2
        movq    xmm0, xmm2
        mulsd   xmm0, xmm8
        movq    xmm2, xmm0
        addsd   xmm8, xmm9
        mulsd   xmm0, xmm8
        movq     [n], xmm0
        movhpd  xmm2, [n]
        addsd   xmm8, xmm9

        movlpd  xmm0, [x_t]
        movhpd  xmm0, [x_t]
        mulpd   xmm3, xmm0
        
        add     rcx, 2
        jmp     repeat
        
    
        

        


    exit:
        movsd   xmm0, xmm4
        lea     rdi, [o_format]
        mov     al, 1   
        call    printf wrt ..plt

        add     rsp, 8
        sub     rax, rax
        ret