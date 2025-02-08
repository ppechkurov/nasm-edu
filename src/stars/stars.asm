        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax                   ; GETCHAR will put char here

        GETCHAR

        cmp al, '9'
        jg buf

        cmp al, '0'
        je buf

loop:
        PUTCHAR '*'
        dec al

        cmp al, '0'
        jne loop
        PUTCHAR 10

buf:
        GETCHAR
        cmp al, 10
        je end

        cmp al, -1
        jne buf
end:
        FINISH

