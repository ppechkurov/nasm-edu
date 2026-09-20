        %include "macros/stud_io.inc"
        global _start

        section .text
_start:
        xor eax, eax                   ; current char
        xor ecx, ecx                   ; counter

read:
        GETCHAR

        cmp eax, -1                    ; eof?
        je .eof

        push eax
        inc ecx

        jmp read

.eof:
        mov ebx, eax                   ; save GETCHAR return value
        xor edx, edx

print:
        jecxz read_all                 ; 0 chars read

        cmp [esp], 10                  ; new line at the top of the stack?
        jne .init

        pop eax                        ; remove extra new line
        dec ecx
.init:
        lea esi, [esp + ecx*4 - 4]
        std
.lp:
        lodsd

        cmp eax, 10                    ; got a new line?
        jne .next

        dec ecx                        ; \n counts anyway as a loop iteration
        jmp .print

.next:
        push eax
        inc edx
        loop .lp

.print:
        cmp edx, 0
        je .done

        pop eax
        PUTCHAR al
        dec edx
        jmp .print

.done:
        xor edx, edx
        jecxz .finish

        PUTCHAR 10
        jmp .lp

.finish:
        mov eax, ebx                   ; restore originar GETCHAR return value

read_all:
        cmp eax, -1
        je .done

        cmp eax, 10
        je .done

        GETCHAR                        ; read all stdin
        jmp read_all
.done:
        xor ebx, ebx                   ; exit code 0

quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        int 80h
