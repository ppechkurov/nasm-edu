        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
lp:
        GETCHAR

        cmp eax, -1
        je quit                        ; eof

        cmp eax, 10
        jne lp

        PRINT "OK"
        PUTCHAR 10
        jmp lp
quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
