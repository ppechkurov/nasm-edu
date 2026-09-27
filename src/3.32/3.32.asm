        global _start
        section .bss
        argc resd 1

        section .text
_start:
        mov ebp, [esp]                 ; argc -> ebp
        mov dword [argc], ebp          ; save argc
        xor ebx, ebx                   ; exit code 0 by default

        cmp [argc], 4                  ; got three args?
        je .quit                       ; ok

        mov ebx, 1                     ; exit code 1
.quit:
        mov eax, 1                     ; exit syscall
        int 80h
