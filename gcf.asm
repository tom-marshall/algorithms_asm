;
; gcf - greatest common factor using Euclid's mothod
;

section .data
    num1:   DD 12635235
    num2:   DD 6352350


section .text
global _start

_start:
    mov edi, [num1]
    mov esi, [num2]

.gcdloop:
    test edi, edi
    jz .finished

    cmp edi, esi
    jg .postswap

    ; swap edi and esi
    mov eax, edi
    mov edi, esi
    mov esi, eax

.postswap:
    sub edi, esi

    jmp .gcdloop

.finished:
    nop


