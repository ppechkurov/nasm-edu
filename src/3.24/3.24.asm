        %include "src/3.24/print.asm"
        global _start

        section .data
str:
        db "this is a test", 0
        section .text
_start:
        mov eax, str
        call print
quit:
        PUTCHAR 10
        xor ebx, ebx
        mov eax, 1                     ; exit syscall
        int 80h

