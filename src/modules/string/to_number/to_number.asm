;; string/to_number.asm ;;
; converts string to number
; returns converted number

%include "macros/stud_io.inc"

global to_number

section .bss
result      resd 1
ten         equ 10

section .text
; procedure to_number
; [ebp+8] == address of the string
to_number:  push ebp
            mov ebp, esp
            push ebx                            ; save ebx (CDECL)

            xor ebx, ebx
            xor ecx, ecx                        ; accumulated number here
            mov edx, ten                        ; ten

            xor eax, eax
            mov esi, [ebp+8]                    ; arg1 -> esi, prepare lodsb
            cld

.read       lodsb
            cmp al, 0
            je .return

            sub al, "0"                         ; convert char to digit

            mov ebx, eax                        ; digit -> bl
            mov eax, ecx                        ; accumulated -> eax
            mul dl                              ; x10
            
            add eax, ebx                        ; add digit to multiplied 
            mov ecx, eax                        ; update accumulated
            xor eax, eax                        ; reset eax
            jmp .read

.return     pop ebx                             ; recover ebx (CDECL)
            mov eax, ecx                        ; result -> eax
            mov esp, ebp
            pop ebp
            ret
