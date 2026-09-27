; print a string starting at address ([ebp+8]=address of a string to print)
        global print_str

        %include "macros/stud_io.inc"
        %define loc_arg1 ebp+8

print_str:
        push ebp                       ; CDECL
        mov ebp, esp

        push esi

        mov esi, [loc_arg1]            ; prepare read
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
