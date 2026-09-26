; input: "2 3"
; output: 5
; output: -1
; output: 6

; %include "macros/stud_io.inc"
        %include "src/3.24/to_number.asm"
        %include "src/3.24/to_string.asm"
        %include "src/3.24/read.asm"

        global _start

        section .bss
        str1 resb 10                   ; first input str
        str1_len equ $-str1            ; first input len
        len1 resd 1                    ; first input len
        num1 resd 1                    ; first converted num

        str2 resb 10                   ; second input str
        str2_len equ $-str2            ; second input len
        len2 resd 1                    ; second input len
        num2 resd 1                    ; second converted num

        buf resb 10                    ; print buffer

        section .text
_start:
        mov eax, str1
        mov ecx, str1_len
        call read                      ; read count -> ecx
        mov [len1], ebx

        cmp ecx, " "                   ; got space?
        je read_2                      ; read the second number
        mov eax, ebx                   ; result to eax
        jmp err

read_2:
        mov eax, str2
        mov ecx, str2_len
        call read
        mov [len2], ebx

        jmp read_all

done:
        mov [len2], ecx                ; save str2 len
        cmp ecx, 0                     ; str2 is missing
        jne read_all

        PRINT "error: number two was not provided"
        PUTCHAR 10

err:
        PRINT "error: not a digit '"
        mov ebx, 1                     ; exit code

        cmp al, 10                     ; \n
        jne .char

        PRINT "\n"
        jmp .close
.char:
        PUTCHAR al
.close:
        PUTCHAR "'"

read_all:
        jmp .done
        cmp eax, -1
        je .done

        cmp eax, 10
        je .done

        GETCHAR                        ; read all stdin
        jmp read_all
.done:
        xor eax, eax
        xor ecx, ecx
        mov ebx, str1 + 10             ; end of the str1
        mov esi, str1
        mov edi, num1
        cld
        mov ebp, 10                    ; ten

.to_number:
        push str1
        call to_number                 ; number -> eax, err -> ecx
        add esp, 4                     ; CDECL -> restore the stack

        cmp ecx, 1                     ; err?
        je err
        mov [num1], eax                ; save converted number

        push str2
        call to_number                 ; number -> eax, err -> ecx
        add esp, 4                     ; CDECL -> restore the stack

        cmp ecx, 1                     ; err?
        je err
        mov [num2], eax                ; save converted number

calc:
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
        mov ebp, 10                    ; ten

        mov edi, buf+10-1
        mov esi, edi
        std
.sum:
        mov eax, [num1]
        add eax, [num2]

        mov ebx, .sub                  ; return address
        jmp .to_string

.sub:
        PUTCHAR 10

        xor eax, eax                   ; clean up eax
        mov edi, buf                   ; destination -> buf
        mov ecx, 10                    ; len=10
        cld
        rep stosb                      ; fill with 0

        mov edi, buf+10-1              ; prepare buf to store result
        mov esi, edi
        std

        mov eax, [num1]
        sub eax, [num2]
        jns .positive                  ; SF=0? - got positive number
        PUTCHAR "-"
        neg eax

.positive:
        mov ebx, .mul                  ; return address
        jmp .to_string

.mul:
        PUTCHAR 10

        xor eax, eax                   ; clean up eax
        mov edi, buf                   ; destination -> buf
        mov ecx, 10                    ; len=10
        cld
        rep stosb                      ; fill with 0

        mov eax, [num1]
        mul dword [num2]               ; watch for correct size!

        mov edi, buf+10-1
        mov esi, edi
        std

        mov ebx, quit                  ; return address

.to_string:                            ; assuming eax contains the number
        mov ecx, buf                   ; buf -> ecx
        push ebx                       ; save return addr
        call to_string                 ; str -> buf
        pop ebx                        ; restore return addr

        mov edi, buf
        mov esi, edi
        cld
.lp:
        lodsb
        cmp al, 0
        jne .print

        jmp ebx

.print:
        PUTCHAR al
        jmp .lp

quit:
        PUTCHAR 10
        xor ebx, ebx
        mov eax, 1                     ; exit syscall
        int 80h
