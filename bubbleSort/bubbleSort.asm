bits    64
default rel

global  main

extern  printf
extern  scanf

section .data
    i_format       db "%d", 0
    o_format       db "%d ", 0
    n              db 0

section .bss
    array          resd 100

section .text
    main:
        sub     rsp, 8 ;align to 16bit in stack
        mov     r10, [n];store n in register for optimization

    read_array:
        lea     rdi, [i_format] ;first arg
        lea     rsi, [array+0] ;second arg
        mov     al, 0 ;no floating point args
    read_array_loop:
        mov     rax, 0 ;clear return register
        sub     rsp, 8 ;align to 16bit in stack
        call    scanf wrt ..plt

        inc     r10 ;increment n
        cmp     r10, 100 ;check if n is 100
        je      end_read_array; jump if n is 100, n indicates number of elements
        
        add     rsi, 4 ;move to next element (64-bit)
        cmp     rax, 1 ;check if input was valid
        je      read_array_loop;continue loop
        
    end_read_array:
        add     rsp, 8
        sub     rax, rax
        ret

    print_array:
        lea     rdi, [o_format] ;first arg
        lea     rsi, [array] ;second arg
        mov     al, 0 ;no floating point args
    print_array_loop:
        sub     rsp, 8 ;align to 16bit in stack
        call    printf wrt ..plt

        dec     r10 ;increment n
        cmp     r10, 0 ;check if n is 0
        je      end_print_array; jump if n is 100, n indicates number of elements
        
        add     rsi, 4 ;move to next element (64-bit)
        cmp     rax, 1 ;check if input was valid
        je      print_array_loop;continue loop
    end_print_array:
        add     rsp, 8
        sub     rax, rax
        ret