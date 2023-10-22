;; string/getlen.asm ;;

global getlen

; procedure getlen
; [ebp+8] == address of the string
; returns length through eax

section .text

getlen:     push ebp
            mov ebp, esp

            xor eax, eax
            mov ecx, [ebp+8]                    ; arg1

.loop:      cmp byte [eax+ecx], 0
            jz .return

            inc eax
            jmp .loop

.return     pop ebp
            ret
