        %include "macros/stud_io.inc"
        global _start

        section .bss
        buf resb 64

        section .text
_start:
        xor eax, eax
        xor ecx, ecx
        mov edi, buf
        cld
count:
        GETCHAR

        cmp eax, -1                    ; eof?
        je done

        inc ecx

        jmp count

done:
        cmp ecx, 0
        je quit                        ; nothing to print

        mov eax, ecx
        xor ebx, ebx                   ; result len
        xor edx, edx
        mov esi, 10                    ; delitel

to_str:
        div esi

        mov ecx, eax                   ; save rest

        add edx, "0"                   ; modulo to char
        mov eax, edx
        stosb
        inc ebx

        jecxz prep

        mov eax, ecx
        xor edx, edx
        jmp to_str

prep:
        lea esi, [buf+ebx-1]           ; addr of the LAST stored digit
        xor eax, eax
        std
lp:
        lodsb
        PUTCHAR al
        dec ebx
        jnz lp

quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        mov ebx, 0                     ; exit code
        int 80h
