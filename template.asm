bits    64
default rel

global  main

extern  printf
extern  scanf
section .data

section .bss

section .text
    main:
        sub     rsp, 8

        add     rsp, 8
        sub     rax, rax
        ret