        %include "macros/learn.inc"

        global _start

        section .text
_start:
        mov eax, 10

        convert "this is a literal"
quit:
        xor ebx, ebx
        mov eax, 1                     ; exit syscall
        int 80h
