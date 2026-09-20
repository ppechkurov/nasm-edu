; input: "2+3"
; output: 5
; input: "2-3"
; output: -1
; input: "2*3"
; output: 6
; input: "2/3"
; output: 0

        %include "macros/stud_io.inc"
        global _start

        section .bss
        str1 resb 10                   ; first input str
        str2 resb 10                   ; second input str
        num1 resd 1                    ; first converted num
        num2 resd 1                    ; second converted num
        buf resb 10                    ; print buffer
        op resb 1                      ; operator

        section .text
_start:
        xor eax, eax
        mov edi, str1
        cld
        jmp read

to_num2:
        mov edi, str2

read:
        GETCHAR

        cmp eax, -1                    ; eof?
        je .eof

        cmp eax, 10                    ; \n?
        je done

        cmp [op], 0                    ; do we have something in [op]?
        jne .check                     ; already read

        cmp al, "+"
        je .op
        cmp al, "-"
        je .op
        cmp al, "*"
        je .op
        cmp al, "/"
        jne .check                     ; looks like not an operator

.op:
        mov [op], al
        jmp to_num2

.check:
        cmp eax, "0"                   ; not a digit?
        jl err

        cmp eax, "9"                   ; not a digit?
        jg err

        stosb

        jmp read
.eof:
        xor ebx, ebx                   ; exit code 0
        jmp quit

done:
        cmp [str2], 0                  ; str2 is missing
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
        lodsb

        cmp al, 0                      ; we wrote from end to start - skip zero's until something meaningful
        je .next

        sub al, "0"                    ; char to digit

.to_num:
        div ebp                        ; remainder -> edx

        mov ecx, edx                   ; persist the remainder
        mov eax, [edi]                 ; load current result
        mul ebp                        ; x10

        add eax, ecx                   ; add a remainer to the result
        mov [edi], eax                 ; update the result
        jmp convert                    ; next

.next:
        cmp edi, num1                  ; check which number is processing
        jne .done                      ; both number are parsed here

; reinit the thing
        xor eax, eax
        xor ecx, ecx
        mov esi, str2
        mov edi, num2
        mov ebx, str2 + 10             ; end of the str2

        jmp convert                    ; go parse num2

.done:

calc:
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
        mov ebp, 10                    ; ten

        mov edi, buf+10-1
        mov esi, edi
        std

        cmp [op], "+"
        je .sum
        cmp [op], "-"
        je .sub
        cmp [op], "*"
        je .mul
        cmp [op], "/"
        je .div

        PRINT "error: unknown operator "
        PUTCHAR [op]
        mov ebx, 1
        jmp quit

.sum:
        mov eax, [num1]
        add eax, [num2]

        jmp .done

.sub:
        mov eax, [num1]
        sub eax, [num2]

        jns .positive                  ; SF=0? - got positive number

        PUTCHAR "-"                    ; negative number
        neg eax

.positive:
        jmp .done

.mul:
        mov eax, [num1]
        mul [num2]
        jmp .done

.div:
        xor edx, edx
        mov eax, [num1]
        div [num2]

.done:
        mov ebx, again                 ; return address
        jmp to_str

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

again:
        PUTCHAR 10

        mov [op], 0                    ; reset op

        xor eax, eax
        mov [num1], 0
        mov [num2], 0
        mov esi, buf
        mov ebx, .str1
        jmp .reset
.str1:
        mov esi, str1
        mov ebx, .str2
        jmp .reset
.str2:
        mov esi, str2
        mov ebx, _start

.reset:
        mov ecx, 10
        mov edi, esi
        rep stosb
        jmp ebx

quit:
        PUTCHAR 10
        mov eax, 1                     ; exit syscall
        int 80h
