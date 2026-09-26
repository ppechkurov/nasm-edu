; to_number ([ebp+8]=address of a string to convert)
; returns (eax=result, ecx=error)
        section .text
ten:
        dd 10

to_number:
        push ebp                       ; CDECL
        mov ebp, esp                   ; save esp

        push dword 0                   ; [ebp-4] result
        push esi                       ; [ebp-8] save registers
        push ebx                       ; [ebp-12] for a caller

        mov esi, [ebp+8]               ; prepare read
        xor eax, eax                   ; prepare acc
        xor ecx, ecx                   ; reset counter
        cld

.lp:
        lodsb                          ; byte -> eax

        cmp al, 0                      ; NULL?
        je .done                       ; just in case

        sub al, "0"                    ; char to digit

        movzx ebx, al                  ; persist current digit
        mov eax, [ebp-4]               ; load current result
        mul dword [ten]

        add eax, ebx                   ; add a remainder
        mov [ebp-4], eax

        jmp .lp

.done:
        mov eax, [ebp-4]               ; result to eax
        xor ecx, ecx

.quit:
        pop ebx                        ; <- [ebp-12] restore ebx
        pop esi                        ; <- [ebp-8]  restore esi
        mov esp, ebp                   ; CDECL
        pop ebp                        ; caller's frame back
        ret
