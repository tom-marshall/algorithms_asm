%define LIMIT  2000             ; upper limit to test to
%define HALFLIMIT  LIMIT / 2    ; take half as a macro


section .data
    arr:    times (LIMIT + 1)   dd  1
    fmt:                        db  "Prime: %d", 10, 0


section .text

extern printf                   ; uses printf
global main

main:
    push rbp
    mov rbp, rsp

    mov rbx, 1                  ; rbx is the outer loop index

.outerloop:
    inc rbx                     ; increment outer loop (start at 2)
    mov rcx, 1                  ; rcx is the inner loop index
                                ;    (also starts at 2 - see next op)

.innerloop:
    inc rcx                     ; increment inner loop

    mov r8, rbx                 ; use r8 to multiply
    imul r8, rcx                ;    rbx and rcx

    mov [arr+r8*4], dword 0     ; mult inner index times outer index

    xor rdx, rdx                ; clear rdx for division
    mov rax, LIMIT              ; loop to upper limit div
    idiv rbx                    ;    by outer loop counter

    cmp rcx, rax                ; check innter loop counter to
    jl .innerloop               ;    LIMIT / inner loop counter

    cmp rbx, HALFLIMIT          ; check outer loop iteration quit condition
    jl .outerloop


.testprimes:
    xor ebx, ebx                ; ebx is counter for printing primes in loop

.testprimeloop:
    inc rbx                     ; start at 1

    mov edx, [arr + rbx * 4]    ; load arr[rbx] into edx to test
    test edx, edx               ; test for arr having a zero ot that index
    jz .afterprint              ;    skip printing if not a prime

    mov rdi, fmt                ; printf format string
    mov rsi, rbx                ; first arg is prime number
    xor eax, eax                ; no xmm registers
    call printf                 ; print it!

.afterprint:
    cmp rbx, LIMIT              ; increment test index up to LIMIT
    jl .testprimeloop           ; loop to print next prime #

    leave                       ; fix stack

    mov rax, 0                  ; no errors
    ret                         ; adios


