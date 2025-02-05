        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax                   ; GETCHAR will put char here
        xor ebx, ebx                   ; first char from input
        xor ecx, ecx                   ; chars count

        GETCHAR                        ; save first input char
        mov bl, al                     ; to bl
read:
        GETCHAR                        ; read all buffered input
        cmp al, 10                     ; until not  CR
        je decide

        cmp al, -1                     ; EOF
        je end

        inc ecx                        ; chars count
        jmp read                       ; loop
decide:
        cmp ecx, 0                     ; if chars > 1
        jg no

        cmp bl, 'a'                    ; if first char is not 'a'
        jne no

        PRINT 'YES'                    ; else all is good
        jmp end
no:
        PRINT 'NO'
end:
        PUTCHAR 10
        FINISH 0

