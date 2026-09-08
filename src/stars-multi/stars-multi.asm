        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax                   ; GETCHAR will put char here
        xor ebx, ebx                   ; +
        xor ecx, ecx                   ; -

read:
        GETCHAR

        cmp al, '+'
        je plus
        cmp al, '-'
        je dash

        cmp al, 10
        je count
        cmp al, -1
        je count

        jmp read

plus:
        inc ebx
        jmp read
dash:
        inc ecx
        jmp read

count:
        mov eax, ebx                   ; first num
        mul bl                         ; mul
        mov cx, ax                     ; result in ecx

        cmp cx, 0
        je end
print:
        PUTCHAR '*'
        loop print

end:
        PUTCHAR 10
        FINISH

