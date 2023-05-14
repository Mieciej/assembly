bits    64
default rel

global  main

extern  printf
extern  scanf
section .data
    i_format    db '%d', 0
    o_format    db '%d ', 0
section .bss
    array       resd 100
    n           resd 1
section .text
    main:
        sub     rsp, 8

        
        sub     rbx, rbx ;counter inside the loop
    ; reads input
    input_loop:
        mov     rax, rbx ;move counter to rax
        ; multiply rax by 4 to caclulate array offset
        add     rax, rax
        add     rax, rax
        ; load array address and add offset to it
        lea     rsi, [array]   
        add     rsi, rax
        ; read the array
        lea     rdi, [i_format]
        mov     al, 0   
        call    scanf wrt ..plt
        ; increment counter
        add     rbx, 1
        ; check if scanf succeded, if yes, next iteration
        cmp     rax, 1
        je      input_loop
        sub     rbx, 1
        cmp     rbx, 0
        je      exit
        mov     [n], rbx

        mov     r10, rbx    ; store number of all elemnts in r10
        sub     rbx, rbx
        mov     r8, 4       ; store 4 used for multiplication
        mov     rcx, 0      ; store number of already sorted elements [i]
        mov     r9, r10     ; r9 is used as [j] variable, i.e. enumerates the array in reverse
        jmp     compare_loop;start comparing elements
    array_loop:
        add     rcx, 1      
        cmp     rcx, r10    ; check if all elements are sorted
        jge     print       ; if yes, then print
        mov     r9, r10     ; restart the sorting from last element
    compare_loop:
        sub     r9, 1
        cmp     r9, rcx     ; see if we iterated through all unsorted elements elements 
        jng     array_loop  ; if yes, then repeat the whole process
        mov     rax, r9     ; rax is used to find memory offset inside the array
        mul     r8
        ;load array[j] to edi
        lea     rsi, [array] 
        add     rsi, rax
        mov     edi, [rsi]
        ; load array[j-1] to ebi
        sub     rsi, r8
        mov     ebx, [rsi]
        cmp     edi, ebx ; compare the values
        jge     continue
        ; swap them 
        mov     [rsi], edi
        add     rsi, r8
        mov     [rsi], ebx
    continue:
        jmp     compare_loop
        
        
        


    
    print:
        sub     rbx, rbx ;counter inside the loop
        
    output_loop:
        mov     rax, rbx ;move counter to rax
        ; multiply rax by 4 to caclulate array offset
        add     rax, rax
        add     rax, rax
        ; load array address and add offset to it
        lea     rdx, [array]   
        add     rdx, rax
        mov     rsi, [rdx]
        ; read the array
        lea     rdi, [o_format]
        mov     al, 0   
        call    printf wrt ..plt
        ; increment counter
        add     rbx, 1
        ; check if scanf succeded, if yes, next iteration
        mov     rax, [n]
        cmp     rbx, rax
        jge     exit
        jmp     output_loop
    exit:
        add     rsp, 8
        sub     rax, rax
        ret
