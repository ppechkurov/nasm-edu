; print a string starting at address ([ebp+8]=address of a string to print)

        %include "macros/stud_io.inc"

print_str:
        push ebp                       ; CDECL
        mov ebp, esp

        push esi

        mov esi, eax                   ; prepare read
        xor eax, eax

.lp:
        lodsb
        cmp al, 0                      ; end of the str?
        je .quit

        PUTCHAR al
        jmp .lp

.quit:
        pop esi
        mov esp, ebp                   ; CDECL
        pop ebp
        ret
