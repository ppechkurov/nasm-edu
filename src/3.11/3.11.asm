        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor ecx, ecx                   ; setup sum
lp:
        GETCHAR

        cmp eax, -1
        je lp_quit                     ; eof

        cmp eax, 10
        je lp_quit                     ; new line

        cmp al, "0"                    ; ignore non-digits
        jl lp
        cmp al, "9"
        jg lp

        sub al, "0"                    ; convert to a decimal
        cbw                            ; extend al -> ax
        cwde                           ; extend ax -> eax
        add ecx, eax                   ; update sum
        jmp lp
lp_quit:
        jecxz quit                     ; got 0, nothing to print
pr_lp:
        PUTCHAR "*"
        loop pr_lp
quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
