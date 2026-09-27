        global _start

        extern strlen
        extern print

        %define argc ebp
        %define arg ebp+8

        section .text
_start:
        mov ebp, esp

        mov edi, [argc]                ; argc -> edi
        dec edi                        ; skip prog name
        cmp edi, 0
        je .fail                       ; no args, skipping

        xor ebx, ebx                   ; exit code 0 by default

        mov esi, 0

.lp:
        mov eax, [arg+esi*4]           ; current arg addr

        push eax
        call print
        add esp, 4

        cmp eax, 0
        jl .fail

        dec edi
        inc esi
        cmp edi, 0
        je .quit

        jmp .lp

.fail:
        mov ebx, eax                   ; exit code 1
.quit:
        mov eax, 1                     ; exit syscall
        int 80h
