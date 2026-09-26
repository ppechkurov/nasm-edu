; read a string at addr up to len ([ebp+8]=address of a string, [ebp+12]=len)
; returns (eax=read len, ecx=error code)

        %include "macros/stud_io.inc"

read:
        push ebp                       ; CDECL
        mov ebp, esp

        push edi

        cmp [ebp+12], 0
        je .quit                       ; len=0

        mov edi, [ebp+8]               ; prepare write

        xor eax, eax                   ; char
        xor ecx, ecx                   ; scanned

.read_lp:
        GETCHAR

        cmp al, "0"
        jl .not_digit

        cmp al, "9"
        jg .not_digit

.put:
        stosb
        inc ecx

.check:
        cmp [ebp+12], ecx
        jle .quit
        jmp .read_lp

.not_digit:
        mov edx, ecx                   ; save read len
        mov ecx, eax                   ; char as error code
        mov eax, edx                   ; return len

.quit:
        mov [edi], 0                   ; finish str

        pop edi
        mov esp, ebp
        pop ebp
        ret
