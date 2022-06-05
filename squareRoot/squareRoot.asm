bits    64
default rel
global  main
extern  printf
extern  scanf

section .data
	input_message db 'This is a program which will calculate square root of a sequence of numbers with step of 0.125', 0xA,'Enter a stopping criterion: ', 0
    output_message db  'sqrt(%f) = %f ',0xA, 0
    i_format	db '%lf', 0xA, 0
    step dq 0.125

section .bss
	end	resq 1

section .text
main:
    sub	rsp, 8
	lea	rdi, [input_message]
	mov	al, 0
    call	printf wrt ..plt ;display program description

    lea	rdi, [i_format]
    lea rsi, [end]
    mov	al, 0
    call	scanf wrt ..plt ;reading the float
    
    sub     rdx,  rdx
    movq	xmm6, rdx; d=0
    movq	xmm7, [step]
    movlpd	xmm8, [end]; stopping criterion
    loop_step_0125:
    addsd    xmm6, xmm7
    movq	 xmm0, xmm6
    sqrtsd   xmm1, xmm0; result stored in xmm6
    lea      rdi, [output_message]
    mov      al , 2
    call     printf wrt ..plt ;display result
    cmpnltsd  xmm0, xmm8
    movq     rax, xmm0
    cmp      rax, 0
    jz loop_step_0125

    return:
    mov	rax, 0; success
    add rsp, 8
    ret