bits    64
default rel
global  main
extern  scanf
extern  printf
section .data
    format      db '%s', 0 
    o_format    db '%s', 0xA, 0

section .bss
    input       resb 1024
    output      resb 1024
section .text
    main:
        sub     rsp, 8
        lea     rsi, [input + 0]
        lea     rdi, [format]
        mov     al, 0   
        call    scanf wrt ..plt
        ;measure the input length
        mov     al, 0
        mov     rcx, 1024
        lea     rdi, [input]
        repne   scasb
        ;copy (1024 - rcx) bytes to output
        mov     rax, rcx
        mov     rcx, 1024
        sub     rcx, rax
        lea     rsi, [input]
        lea     rdi, [output]
        rep     movsb
        ; print the output
        lea     rsi, [output]
        lea     rdi, [o_format]
        mov     al, 0   
        call    printf wrt ..plt

        sub     rax, rax
        add     rsp, 8
        ret