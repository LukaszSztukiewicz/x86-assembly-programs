bits    64
default rel
global  main
extern  printf
extern  scanf

section .data
	input_message db 'This is a program that computes the square root value.', 0xA,'Enter a double: ', 0
    output_message db 0xA, 'The result is: ', 0
    io_format	db '%lf', 0xA, 0

section .bss
	var	resq 1

section .text
main:
    sub	rsp, 8
	lea	rdi, [input_message]
	mov	al, 0
    call	printf wrt ..plt ;display program description

    lea	rdi, [io_format]
    lea rsi, [var]
    mov	al, 0
    call	scanf wrt ..plt ;reading the float
    
    ;computing the square root
    movlpd	xmm5, [var]
    sqrtsd  xmm6, xmm5; result stored in xmm6

    print_result:
    lea rdi, [output_message]
    call	printf wrt ..plt
    mov al, 1
    lea rdi, [io_format]
    movq  xmm0, xmm6
    call	printf wrt ..plt

    return:
    mov	rax, 0; success
    add rsp, 8
    ret