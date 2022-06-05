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
       
    read_array_loop:
        lea     rdi, [i_format] ;first arg
        lea     rsi, [array] ;load effective address of array to register
        mov     al, 0 ;no floating point args
        sub     rax, rax;clear return value
        call    scanf wrt ..plt
        inc     r15 ;increment n
        cmp     r15, 100 ;check if n is 100
        jge     do_bubble_sort
        cmp     rax, 1 ;check if input was valid
        jz      read_array_loop

    do_bubble_sort:
        mov    qword [n], r15 ;store n back to memory
        mov    r11, 0 ;outer loop counter
    outer_loop:
        mov    rcx, qword [n] ;inner counter
        dec    rcx
    inner_loop:
        ;mov    r8d, dword [array + 4*rcx] ;load first element
        ;mov    r9d, dword [array + 4*rcx - 4] ;load second element
        cmp    r8d, r9d
        jg     noswap
        xchg   r8d, r9d
    noswap:
        mov    r12, qword [array]
        mov    [r12 + rcx*4], r8d ;store first element
        ;mov    dword [array + 4*rcx - 4], r9d ;store second element
        loop inner_loop
        inc    r11 ;increment outer loop counter
        cmp    r11, r15 ;check if outer loop counter is equal to n
        jl     outer_loop

    print_array:
        mov     r15, qword [n] ;store number of elements in register
        lea     rdi, [o_format] ;first arg
        lea     r11, [array] ; load address of array to register
        mov     al, 0 ;no floating point args
    print_array_loop:
        dec     r15 ;decrement n
        ;mov     rsi, [r11 + r15*8]; second arg
        call    printf wrt ..plt
        cmp     r15, 0 ;check if n is 0
        jne     print_array_loop
        
    return:
        add     rsp, 8; adjust stack pointer
        sub     rax, rax; return 0
        ret