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
        jge     print_array
        cmp     rax, 1 ;check if input was valid
        jz      read_array_loop
    
    print_array:
        lea     r12, [array] ;second arg
        dec     r15 ;decrement n
        
        
    
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