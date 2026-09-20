; input: "2 3"
; output: 5
; output: -1
; output: 6

        %include "macros/stud_io.inc"
        %include "src/3.24/to_number.asm"
        global _start

        section .bss
        str1 resb 10                   ; first input str
        len1 resd 1                    ; first input len
        num1 resd 1                    ; first converted num

        str2 resb 10                   ; second input str
        len2 resd 1                    ; second input len
        num2 resd 1                    ; second converted num

        buf resb 10                    ; print buffer

        section .text
_start:
        xor eax, eax
        xor ecx, ecx                   ; current str len
        mov edi, str1                  ; str1 -> destination

read:
        GETCHAR

        cmp eax, -1                    ; eof?
        je done

        cmp eax, 10                    ; \n?
        je done

        cmp eax, " "                   ; got space?
        je to_num2                     ; read second number

        cmp eax, "0"                   ; not a digit?
        jl err

        cmp eax, "9"                   ; not a digit?
        jg err

        stosb
        inc ecx

        jmp read

to_num2:
        mov edi, str2                  ; str2 -> destination
        mov [len1], ecx                ; save str1 len
        xor ecx, ecx
        jmp read

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

convert:
        mov eax, str1
        mov ecx, [len1]
        call to_number                 ; number -> eax, err -> ecx
        cmp ecx, 1                     ; err?
        je err
        mov [num1], eax                ; save converted number

        mov eax, str2
        mov ecx, [len2]
        call to_number                 ; number -> eax, err -> ecx
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
        jmp to_str

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
        jmp to_str

.mul:
        PUTCHAR 10

        xor eax, eax                   ; clean up eax
        mov edi, buf                   ; destination -> buf
        mov ecx, 10                    ; len=10
        cld
        rep stosb                      ; fill with 0

        mov eax, [num1]
        mul [num2]

        mov edi, buf+10-1
        mov esi, edi
        std

        mov ebx, quit                  ; return address

to_str:                                ; assuming eax contains the number
        div ebp                        ; ebp = 10; modulo -> edx
        mov ecx, eax                   ; save result
        add edx, "0"                   ; to char
        mov eax, edx

        stosb
        jecxz .done

        mov eax, ecx
        xor edx, edx

        jmp to_str
.done:
        mov eax, ecx
        xor edx, edx

        mov edi, buf
        mov esi, edi

        cld
.lp:
        lodsb

        cmp esi, buf+10+1              ; boundary check
        jl .skip

        mov eax, ebx                   ; capture return address
        cmp eax, quit
        je .clean
        jmp ebx
.clean:
        xor ebx, ebx
        jmp quit

.skip:
        cmp al, 0
        je .lp

.print:
        PUTCHAR al
        jmp .lp

quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        int 80h
