        global strlen

; procedure strlen
        %define str_addr ebp+8         ; arg1
; returns eax=len

        section .text
strlen:
        push ebp                       ; CDECL
        mov ebp, esp                   ; CDECL

        xor eax, eax
        mov ecx, [str_addr]

.lp:
        cmp byte [eax+ecx], 0
        jz .return

        inc eax
        jmp .lp

.return:
        mov esp, ebp                   ; CDECL
        pop ebp                        ; CDECL
        ret
