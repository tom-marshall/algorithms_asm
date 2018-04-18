section .rodata
    base32tbl   db   "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

;    teststr     db   'If you clone a repository, the command automatically '
;                db   'adds that remote repository under the name “origin”. '
;                db   'So, git fetch origin fetches any new work that has '
;                db   'been pushed to that server since you cloned (or last '
;                db   'fetched from) it. It’s important to note that the git '
;                db   'fetch command only downloads he data to your local '
;                db   'repository — it doesn’t automatically merge it with '
;                db   'any of your work or modify what you’re currently '
;                db   'working on. You have to merge it manually into your '
;                db   'work when you’re ready.', 0


section .bss
    inputstr    resb    8192
    b32str      resb    8192


section .text
    extern strlen, putchar, puts

    global main

main:
    push rbp
    mov rbp, rsp

    cmp rdi, 2
    jnz .exit

    lea rdi, [b32str]
    mov rsi, [rsi+8]        ; argv[1]
    call encode_base32

    lea rdi, [b32str]
    call puts

.exit:
    mov eax, 1
    leave
    ret


;------------------------------------------------------------------------------;
; base32len                                                                    |
;   size_t base32len(const char *src)                                          |
;                                                                              |
; registers:                                                                   |
;   rdi: pointer to source string                                              |
;                                                                              |
; returns:                                                                     |
;   length of base32 string                                                    |
;------------------------------------------------------------------------------;
base32len:
    push rdi                ; save rdi since scasb advances it

    xor eax, eax            ; search for '0'
    mov rcx, -1             ; 64 byte uint max
    repne scasb             ; search

    mov rax, -2             ; 64 byte uint max - 1
    sub rax, rcx            ; find difference

    pop rdi                 ; restore rdi

    shl rax, 3              ; get # of bits in the byte count

    xor edx, edx            ; clear for divide
    mov ecx, 5              ; 5 bits per character
    div ecx                 ; divide

    mov rcx, rax            ; copy product into rcx
    inc rcx                 ; increase by one
    test rdx, rdx           ; test for remainder
    cmovnz rax, rcx         ; if so, we need extra space

    ret


;------------------------------------------------------------------------------;
; encode_base32                                                                |
;   size_t encode_base32(const char *src, char *dest)                          |
;                                                                              |
; registers:                                                                   |
;   rdi: pointer to destination c style string                                 |
;   rsi: pointer to source c style string                                      |
;   rbx: current byte string to process                                        |
;   r12: character count                                                       |
;                                                                              |
; returns:                                                                     |
;   length of base32 string                                                    |
;------------------------------------------------------------------------------;
encode_base32:
    push rbp
    mov rbp, rsp

    xchg rdi, rsi           ; swap because we need length of source
    call base32len
    mov r12, rax            ; store base32 length
    xchg rdi, rsi           ; swap back

    xor eax, eax
    xor ecx, ecx
    xor edx, edx            ; keep track of character count

.whileloop:
    mov ecx, 5              ; convert 5 8 byte groups to 8 5 bytes groups

.forloop1:
    lodsb                   ; load the next source byte
    test al, al             ; make sure it's not null
    jz .step2               ; if so, go to next step

    shl rbx, 8              ; shift old bits
    or rbx, rax             ;   and add fresh ones

    dec ecx
    jnz .forloop1

    ; at this point, we have 40 bits from our src string

.step2:
    shl cl, 3               ; pad bytes if we processed
    shl rbx, cl             ;   less than 5 characters

    mov cl, 8               ; 8 iterations for conversion to base32

.forloop2:
    cmp rdx, r12            ; if we've processed all bytes
    jz .whiledone           ;   then exit the while loop

    ; bitshift operation for conversion
    mov rax, rbx
    shr rax, 35
    and eax, 0x1f 
    mov al, byte [base32tbl+rax]
    stosb

    shl rbx, 5              ; shift to next 5 bits
    inc rdx

    dec cl
    jnz .forloop2

    jmp .whileloop


.whiledone:
    xor eax, eax
    stosb

    leave
    ret

