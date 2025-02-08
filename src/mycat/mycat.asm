        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax                   ; GETCHAR will put char here

loop:
        GETCHAR
        PUTCHAR al

        cmp al, -1
        jne loop

end:
        FINISH

