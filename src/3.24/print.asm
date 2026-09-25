; print a string starting at address (eax=address of a string to print)

        %include "macros/stud_io.inc"

print:
        push eax                       ; [esp] str addr
        mov esi, eax                   ; prepare read
        xor eax, eax

.lp:
        lodsb
        cmp al, 0                      ; end of the str?
        je .return

        PUTCHAR al
        jmp .lp

.return:
        pop eax                        ; recover eax
