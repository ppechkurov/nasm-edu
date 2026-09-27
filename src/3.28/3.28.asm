        %include "macros/learn.inc"

        global _start

        section .text
_start:
        fill 1, 2, 10
quit:
        xor ebx, ebx
        mov eax, 1                     ; exit syscall
        int 80h
