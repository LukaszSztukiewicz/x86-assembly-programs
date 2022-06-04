bits    64
default rel
global  main
extern  printf
extern  scanf

section .data
    i_format       dq '%d', 0
    o_format       dq '%d ',0

section .bss
    array          resq 100
    n              resq 1

section .text
    main:
        sub     rsp, 8 ;align to 16bit in stack
        mov     r15, 0 ;store n in register for optimization
        lea     r14, [array] ;load effective address of array to register
        lea     rdi, [i_format] ;first arg
        mov     al, 0 ;no floating point args
    read_array_loop:
        mov     rsi, r14; second arg
        sub     rax, rax;clear return value
        call    scanf wrt ..plt
        add     r14, 8 ;increment array pointer
        inc     r15 ;increment n
        cmp     r15, 100 ;check if n is 100
        jge     do_bubble_sort
        cmp     rax, 1 ;check if input was valid
        jz      read_array_loop

    do_bubble_sort:
        mov    qword [n], r15 ;store n back to memory
        
    print_array:
        mov     r15, qword [n] ;store number of elements in register
        lea     rdi, [o_format] ;first arg
        lea     r11, [array] ; load address of array to register
        mov     al, 0 ;no floating point args
    print_array_loop:
        dec     r15 ;decrement n
        mov     rsi, [r11 + r15*8]; second arg
        call    printf wrt ..plt
        cmp     r15, 0 ;check if n is 0
        jne     print_array_loop
        
    return:
        add     rsp, 8; adjust stack pointer
        sub     rax, rax; return 0
        ret