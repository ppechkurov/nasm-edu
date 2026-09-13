        %include "macros/stud_io.inc"
        global _start

        section .bss
        buf resb 10                    ; unsigned 32-bit int max

        section .text
_start:
        xor ebx, ebx                   ; open brackets counter
        xor edx, edx                   ; closed brackets counter
lp:
        GETCHAR

        cmp eax, "("
        je open

        cmp eax, ")"
        je closed

        cmp eax, -1
        je done                        ; eof: judge the pending line

        cmp eax, 10                    ; \n
        je done

        jmp lp
open:
        inc ebx
        jmp lp
closed:
        inc edx
        cmp edx, ebx
        jg unb                         ; unbalanced, like )(
        jmp lp
unb:
        GETCHAR
        cmp eax, -1                    ; eof
        je no

        cmp eax, 10                    ; \n
        jne unb                        ; read to the end of the line
        jmp no
done:
        cmp ebx, edx
        jne no                         ; unequal counts -> NO, any trigger

        cmp eax, -1
        jne yes                        ; newline + equal -> YES

        cmp ebx, 0
        je quit                        ; eof + nothing counted -> silent
        jmp yes                        ; eof + balanced nonzero -> YES

yes:
        PRINT "YES"
        jmp again

no:
        PRINT "NO"

again:
        PUTCHAR 10
        cmp eax, -1
        je quit                        ; judged the final line, done
        jmp _start

quit:
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
