;
; gcf - greatest common factor using Euclid's mothod
;
; Greatest common factor using Euclid's method with subtraction. Mod would be faster.
;

section .data
    num1:   DD 12635235
    num2:   DD 6352350


section .text
global _start


_start:
    mov edi, [num1]     ; edi holds the number which should be larger
    mov esi, [num2]     ; esi holds the number which should be smaller

.gcdloop:
    test edi, edi       ; continue while we still have a non-negative to test
    jz .finished        ; if the number is zero, we're done

    cmp edi, esi        ; test for larger number in edi
    jg .postswap        ; if not, swap them

    xchg edi, esi       ; swap edi and esi

.postswap:
    sub edi, esi        ; larger number is now larger minus smaller

    jmp .gcdloop        ; repeat

.finished:
    nop


