; to_number (eax=address of a string to convert, ecx=length)
; returns (eax=result, ecx=error)

; %include "macros/stud_io.inc"

to_number:
        push dword 0                   ; [esp+8] result
        push eax                       ; [esp+4] str addr
        push ecx                       ; [esp] str len

        mov edi, 10

        mov esi, eax                   ; prepare read
        xor eax, eax                   ; prepare acc
        xor ecx, ecx                   ; reset counter
        cld

.lp:
        cmp [esp], ecx                 ; len == counter?
        je .done

        lodsb                          ; byte -> eax

        cmp al, 0                      ; NULL?
        je .err                        ; just in case

.convert:
        inc ecx
        sub al, "0"                    ; char to digit

        movzx ebx, al                  ; persist current digit
        mov eax, [esp+8]               ; load current result
        mul edi

        add eax, ebx                   ; add a remainder
        mov [esp+8], eax

        jmp .lp

.done:
        mov eax, [esp+8]               ; result to eax
        mov ecx, 0
        jmp .ret

.err:
        mov ecx, 1                     ; error
        xor eax, eax
.ret:
        add esp, 12                    ; clean stack
        ret
