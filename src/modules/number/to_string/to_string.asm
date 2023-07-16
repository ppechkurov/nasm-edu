;; number/to_string.asm ;;
; converts 4 byte number to string
; returns address of the converted string

global to_string

section .bss
result      resb 10
ten         equ 10

section .text
; procedure to_string
; [ebp+8] == number to convert
to_string:  push ebp
            mov ebp, esp
            push ebx                            ; save ebx (CDECL)

            xor ecx, ecx
            xor edx, edx

            mov eax, [ebp+8]                    ; arg1 -> eax
            mov ebx, ten                        ; 10 -> ebx

; div edx:eax by 10, modulo -> edx, result -> eax
.div_ten:   div ebx
            add edx, "0"                        ; modulo to char
            push edx                            ; save modulo in stack

            xor edx, edx                        ; reset edx
            inc ecx                             ; count chars
            cmp eax, 0
            jne .div_ten

            mov edi, result                     ; prepare stosb
            cld

.fill:      pop eax                             ; fill result
            stosb
            loop .fill

            mov al, 0                           ; mark end of the string
            stosb

            pop ebx                             ; recover ebx (CDECL)
            mov eax, result                     ; return address of the result

            mov esp, ebp
            pop ebp
            ret
