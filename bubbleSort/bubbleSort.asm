bits    64
default rel
global  main
extern  printf
extern  scanf

section .data
    i_format       db '%d', 0
    o_format       db '%d ', 0

section .bss
    n              resq 1   
    array          resd 100

section .text
    main:
        sub     rsp, 8 ;align to 16bit in stack
        mov     r15, 0 ;store n in register for optimization
        lea     r12, [array] ;second arg
       
    read_array_loop:
        lea     rsi, [r12 + r15*4] ;load effective address of array to register
        lea     rdi, [i_format] ;first arg
        mov     al, 0 ;no floating point args
        sub     rax, rax;clear return value
        call    scanf wrt ..plt
        inc     r15 ;increment n
        cmp     r15, 100 ;check if n is 100
        jge     do_bubble_sort
        cmp     rax, 1 ;check if input was valid
        jz      read_array_loop

    do_bubble_sort:
        dec     r15 ;addjust to the real array size
        mov    qword [n], r15 ;store n back to memory
        mov    r11, 0 ;i=0
    outer_loop:
        mov    rcx, qword [n]
        dec    rcx; j=n-1
    inner_loop:
        mov    r8d, dword [r12 + 4*rcx] ;array[j]
        mov    r9d, dword [r12 + 4*rcx - 4]  ;array[j-1]
        cmp    r8d, r9d 
        jl     noswap ;array[j] < array[j - 1]
        xchg   r8d, r9d ;swap
    noswap:
        mov    dword [r12 + 4*rcx], r8d ;store first element
        mov    dword [r12 + 4*rcx - 4], r9d ;store second element
        loop inner_loop
        inc    r11 ;increment outer loop counter
        cmp    r11, r15 ;check if outer loop counter is equal to n
        jl     outer_loop
    
    print_array:
        lea     r12, [array] ;second arg
    print_array_loop:
        dec     r15
        lea     rdi, [o_format] ;first arg
        mov     rsi, [r12 + r15*4] ;load effective address of array to register
        mov     al, 0 ;no floating point args
        call    printf wrt ..plt
        cmp     r15, 0 ;check if n is 100
        jne     print_array_loop

    return:
        add     rsp, 8; adjust stack pointer
        sub     rax, rax; return 0
        ret