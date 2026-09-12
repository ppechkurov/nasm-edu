        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
compare:
        GETCHAR

        cmp eax, -1                    ; eof
        je quit

        PUTCHAR al
        jmp compare
quit:
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
