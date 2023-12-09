section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Hash collission!!",0xA,0
	str1: db "L with ",0
	str2: db " ",0xA,0
	str3: db "Hash collission!!",0xA,0
	str4: db "R with ",0
	str5: db " ",0xA,0
	str6: db "Number of steps part 1: ",0
	str7: db "Number of steps part 2: ",0
	str8: db "Could not open file",0xA,0
	str9: db "Could not read from file",0xA,0
section .bss
	s_buffer resb 13650

section .text
	extern SYS_WRITE
array_out_of_bounds:
	mov rdi, 2
	mov rax, 1
	mov rsi, Array_OOB
	mov rdx, 28
	syscall
	mov rdi, 1
	mov rax, 60
	syscall
global find_ui64_in_string
find_ui64_in_string:
	xor rcx, rcx
.loop:
	cmp byte [rdi+rcx], 0x30
	jl .parse_number
	cmp byte [rdi+rcx], 0x39
	jg .parse_number
	movzx rax, byte [rdi+rcx]
	push rax
	inc rcx
	jmp .loop
.parse_number:
	xor r8, r8
	xor rbx, rbx
	inc rbx
.parse_loop:
	pop rax
	sub rax, 0x30
	mul rbx
	add r8, rax
	mov rax, 10
	mul rbx
	mov rbx, rax
	loop .parse_loop
.exit:
	mov rax, r8
	ret
global print_ui64
print_ui64:
	push rbp
	mov rsi, rsp
	sub rsp, 22
	mov rax, rdi
	mov rbx, 0xA
	xor rcx, rcx
to_string_ui64:
	dec rsi
	xor rdx, rdx
	div rbx
	add rdx, 0x30 ; '0'
	mov byte [rsi], dl
	inc rcx
	test rax, rax
	jnz to_string_ui64
.write:
	inc rax
	mov rdi, 1
	mov rdx, rcx
	syscall
	add rsp, 22
	pop rbp
	ret
global print_ui64_newline
print_ui64_newline:
	push rbp
	mov rsi, rsp
	sub rsp, 22
	mov rax, rdi
	mov rbx, 0xA
	xor rcx, rcx
	dec rsi
	mov byte [rsi], bl
	inc rcx
	jmp to_string_ui64
global printString
printString:
	mov rsi, rdi
	xor rdx, rdx
.strCountLoop:
	cmp byte [rdi], 0x0
	je .strCountDone
	inc rdx
	inc rdi
	jmp .strCountLoop
.strCountDone:
	cmp rdx, 0
	je .prtDone
	mov rax, 1
	mov rdi, 1
	syscall
.prtDone:
	ret

global Hash
Hash:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 16
	mov rax, 5381
	mov dword [rbp-4], eax; VAR_DECL_ASSIGN else variable h
	mov rax, qword rdi; printExpression variable buff
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable buf
	movzx rax, byte sil; printExpression variable type
	mov byte [rbp-13], al; VAR_DECL_ASSIGN else variable t
	mov rax, 0
	mov byte [rbp-14], al; LOOP i
.label1:
	mov rax, 3
	cmp byte [rbp-14], al; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 8
	movzx rax, byte [rbp-14]; printExpression variable i
	mov rbx, 1
	mul rbx
	mov rbx, qword [rbp-12]
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref buf
	mov rax, r11
	mov byte [rbp-15], al; VAR_DECL_ASSIGN else variable byte
	mov eax, dword [rbp-4]; printExpression, left identifier, rbp variable h
	mov rbx, 5; printExpression, right int
	mov rcx, rbx; printExpression, shift left
	shl rax, cl
	push rax; printExpression, leftPrinted, save left
	mov ebx, dword [rbp-4]; printExpression, right identifier, rbp variable h
	pop rax; printExpression, leftPrinted, recover left
	add eax, ebx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-15]; printExpression, right identifier, rbp variable byte
	pop rax; printExpression, leftPrinted, recover left
	add eax, ebx
	mov dword [rbp-4], eax; VAR_ASSIGNMENT else variable h
	add rsp, 8
.skip_label1:
	mov al, byte [rbp-14]; LOOP i
	inc rax
	mov byte [rbp-14], al; LOOP i
	jmp .label1
.not_label1:
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable t
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	mov eax, dword [rbp-4]; printExpression, left identifier, rbp variable h
	mov rbx, 5; printExpression, right int
	mov rcx, rbx; printExpression, shift left
	shl rax, cl
	push rax; printExpression, leftPrinted, save left
	mov ebx, dword [rbp-4]; printExpression, right identifier, rbp variable h
	pop rax; printExpression, leftPrinted, recover left
	add eax, ebx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 76; printExpression, right char 'L'
	pop rax; printExpression, leftPrinted, recover left
	add eax, ebx
	mov dword [rbp-4], eax; VAR_ASSIGNMENT else variable h
	jmp .end_if1
.else_if1:
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable t
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	mov eax, dword [rbp-4]; printExpression, left identifier, rbp variable h
	mov rbx, 5; printExpression, right int
	mov rcx, rbx; printExpression, shift left
	shl rax, cl
	push rax; printExpression, leftPrinted, save left
	mov ebx, dword [rbp-4]; printExpression, right identifier, rbp variable h
	pop rax; printExpression, leftPrinted, recover left
	add eax, ebx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 82; printExpression, right char 'R'
	pop rax; printExpression, leftPrinted, recover left
	add eax, ebx
	mov dword [rbp-4], eax; VAR_ASSIGNMENT else variable h
	jmp .end_if2
.end_if2:
.end_if1:
	mov eax, dword [rbp-4]; printExpression variable h
	add rsp, 16
	jmp .exit
	add rsp, 16
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

GCD:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov rax, qword rdi; printExpression variable a
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable A
	mov rax, qword rsi; printExpression variable b
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable B
.label2:
	sub rsp, 16
	mov rax, qword [rbp-16]; printExpression variable B
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable t
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable A
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable B
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov rax, rdx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable B
	mov rax, qword [rbp-24]; printExpression variable t
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable A
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable B
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .end_if3
.if3:
	jmp .not_label2
	jmp .end_if3
.end_if3:
	add rsp, 16
.skip_label2:
	jmp .label2
.not_label2:
	mov rax, qword [rbp-8]; printExpression variable A
	add rsp, 24
	jmp .exit
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

LCM:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 56
	mov rax, qword rdi; printExpression variable a
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable A
	mov rax, qword rsi; printExpression variable b
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable B
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable A
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable B
	mul qword rbx
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable c
	mov rax, qword [rbp-8]; printExpression variable A
	mov rdi, rax
	mov rax, qword [rbp-16]; printExpression variable B
	mov rsi, rax
	call GCD
	mov rbx, rax; printExpression, nodeType=1, function call
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable c
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	add rsp, 56
	jmp .exit
	add rsp, 56
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Part1
Part1:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 56
	mov rax, 1
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable parseInstructions
	mov rax, 0
	mov qword [rbp-9], rax; VAR_DECL_ASSIGN else variable instructionSize
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-17], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 65; CHAR_LITERAL 'A'
	mov byte [rbp-21], al; VAR_DECL_ASSIGN ARRAY variable source[0]
	mov rax, 65; CHAR_LITERAL 'A'
	mov byte [rbp-20], al; VAR_DECL_ASSIGN ARRAY variable source[1]
	mov rax, 65; CHAR_LITERAL 'A'
	mov byte [rbp-19], al; VAR_DECL_ASSIGN ARRAY variable source[2]
	mov rax, 0
	mov qword [rbp-29], rax; VAR_DECL_ASSIGN else variable destOffset
	mov rax, 4; printExpression, left int
	mov rbx, 2147483647; printExpression, right int
	mul qword rbx
	mov rdi, rax
	mov rax, 9
	mov rsi, rdi
	xor rdi, rdi
	mov rdx, 3
	mov r10, 34
	xor r8, r8
	xor r9, r9
	syscall
	mov qword [rbp-37], rax; VAR_DECL_ASSIGN else variable hashBuffer
	mov rax, 0
	mov qword [rbp-45], rax; LOOP i
.label3:
	mov rax, qword [rbp-17]; printExpression variable length
	cmp qword [rbp-45], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 8
	mov rax, qword [rbp-45]; printExpression variable i
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-46], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-46]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
	movzx rax, byte [rbp-1]; printExpression variable parseInstructions
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
	mov rax, 0
	mov byte [rbp-1], al; VAR_ASSIGNMENT else variable parseInstructions
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-45], rax; VAR_ASSIGNMENT else variable i
	jmp .end_if5
.else_if5:
	sub rsp, 16
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-45]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 16; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, 0
	mov rsi, rax
	call Hash
	mov dword [rbp-50], eax; VAR_DECL_ASSIGN else variable leftIndexHash
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-45]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 16; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rdi, rax
	mov rax, 1
	mov rsi, rax
	call Hash
	mov dword [rbp-54], eax; VAR_DECL_ASSIGN else variable rightIndexHash
	mov eax, dword [rbp-50]; printExpression variable leftIndexHash
	mov rbx, 4
	mul rbx
	mov rbx, qword [rbp-37]
	add rax, rbx
	mov r11d, dword [rax]; printExpression ref hashBuffer
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	mov rbx, 0; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 18
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, 3
	mov rdx, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-45]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 16; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rsi, rax
	mov rax, 1
	mov rdi, rax
	mov rax, 1
	syscall
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 7
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, 3
	mov rdx, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov eax, dword [rbp-50]; printExpression variable leftIndexHash
	mov rbx, 4
	mul rbx
	mov rbx, qword [rbp-37]
	add rax, rbx
	mov r11d, dword [rax]; printExpression ref hashBuffer
	mov rbx, r11; printExpression, nodeType=1, ref index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rsi, rax
	mov rax, 1
	mov rdi, rax
	mov rax, 1
	syscall
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 2
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, 0
	add rsp, 80
	jmp .exit
	jmp .end_if6
.end_if6:
	mov eax, dword [rbp-54]; printExpression variable rightIndexHash
	mov rbx, 4
	mul rbx
	mov rbx, qword [rbp-37]
	add rax, rbx
	mov r11d, dword [rax]; printExpression ref hashBuffer
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	mov rbx, 0; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .end_if7
.if7:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 18
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, 3
	mov rdx, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-45]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 16; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov rsi, rax
	mov rax, 1
	mov rdi, rax
	mov rax, 1
	syscall
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 7
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, 3
	mov rdx, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov eax, dword [rbp-54]; printExpression variable rightIndexHash
	mov rbx, 4
	mul rbx
	mov rbx, qword [rbp-37]
	add rax, rbx
	mov r11d, dword [rax]; printExpression ref hashBuffer
	mov rbx, r11; printExpression, nodeType=1, ref index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rsi, rax
	mov rax, 1
	mov rdi, rax
	mov rax, 1
	syscall
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 2
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, 0
	add rsp, 80
	jmp .exit
	jmp .end_if7
.end_if7:
	mov eax, dword [rbp-50]; printExpression variable leftIndexHash
	lea r11, dword [rbp-37]
	mov r11, qword [r11]
	mov rbx, 4
	mul rbx
	add r11, rax
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 9; printExpression, right int
	sub rax, rbx
	mov dword [r11], eax; VAR_ASSIGNMENT REF hashBuffer
	mov eax, dword [rbp-54]; printExpression variable rightIndexHash
	lea r11, dword [rbp-37]
	mov r11, qword [r11]
	mov rbx, 4
	mul rbx
	add r11, rax
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	sub rax, rbx
	mov dword [r11], eax; VAR_ASSIGNMENT REF hashBuffer
	mov rax, qword [rbp-29]; printExpression, left identifier, rbp variable destOffset
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 9; printExpression, right int
	sub rax, rbx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 90; printExpression, right char 'Z'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 9; printExpression, right int
	sub rax, rbx
	mov qword [rbp-29], rax; VAR_ASSIGNMENT else variable destOffset
	jmp .end_if9
.else_if9:
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	sub rax, rbx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 90; printExpression, right char 'Z'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .end_if10
.if10:
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	sub rax, rbx
	mov qword [rbp-29], rax; VAR_ASSIGNMENT else variable destOffset
	jmp .end_if10
.end_if10:
.end_if9:
	jmp .end_if8
.end_if8:
	add rsp, 16
.end_if5:
	jmp .end_if4
.else_if4:
	movzx rax, byte [rbp-1]; printExpression variable parseInstructions
	test rax, rax
	jnz .if11
	jmp .end_if11
.if11:
	mov rax, qword [rbp-9]; printExpression, left identifier, rbp variable instructionSize
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-9], rax; VAR_ASSIGNMENT else variable instructionSize
	jmp .end_if11
.end_if11:
.end_if4:
	add rsp, 8
.skip_label3:
	mov rax, qword [rbp-45]; LOOP i
	inc rax
	mov qword [rbp-45], rax; LOOP i
	jmp .label3
.not_label3:
	mov rax, 0
	mov qword [rbp-53], rax; VAR_DECL_ASSIGN else variable steps
	mov rax, qword [rbp-53]; printExpression, left identifier, rbp variable steps
	mov rbx, qword [rbp-9]; printExpression, right identifier, rbp variable instructionSize
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov rax, rdx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-54], al; VAR_DECL_ASSIGN else variable instruction
	lea rax, [rbp-21]; printExpression variable source
	mov rdi, rax
	movzx rax, byte [rbp-54]; printExpression, left identifier, rbp variable instruction
	mov rbx, 82; printExpression, right char 'R'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rsi, rax
	call Hash
	mov dword [rbp-58], eax; VAR_DECL_ASSIGN else variable currHash
	mov rax, qword [rbp-53]; printExpression, left identifier, rbp variable steps
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-53], rax; VAR_ASSIGNMENT else variable steps
.label4:
	sub rsp, 8
	mov eax, dword [rbp-58]; printExpression variable currHash
	mov rbx, 4
	mul rbx
	mov rbx, qword [rbp-37]
	add rax, rbx
	mov r11d, dword [rax]; printExpression ref hashBuffer
	mov rax, r11
	mov dword [rbp-62], eax; VAR_DECL_ASSIGN else variable offset
	mov eax, dword [rbp-62]; printExpression, left identifier, rbp variable offset
	mov rbx, qword [rbp-29]; printExpression, right identifier, rbp variable destOffset
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .end_if12
.if12:
	jmp .not_label4
	jmp .end_if12
.end_if12:
	mov rax, qword [rbp-53]; printExpression, left identifier, rbp variable steps
	mov rbx, qword [rbp-9]; printExpression, right identifier, rbp variable instructionSize
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov rax, rdx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-54], al; VAR_ASSIGNMENT else variable instruction
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov ebx, dword [rbp-62]; printExpression, right identifier, rbp variable offset
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	movzx rax, byte [rbp-54]; printExpression, left identifier, rbp variable instruction
	mov rbx, 82; printExpression, right char 'R'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rsi, rax
	call Hash
	mov dword [rbp-58], eax; VAR_ASSIGNMENT else variable currHash
	mov rax, qword [rbp-53]; printExpression, left identifier, rbp variable steps
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-53], rax; VAR_ASSIGNMENT else variable steps
	add rsp, 8
.skip_label4:
	jmp .label4
.not_label4:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-53]; variable steps
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, qword [rbp-37]; printExpression variable hashBuffer
	add rsp, 56
	jmp .exit
	add rsp, 56
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Part2
Part2:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 224
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable length
	mov rax, qword rsi; printExpression variable hashBuff
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable hashBuffer
	mov rax, 0
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable instructionSize
	mov rax, 1
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable parseInstructions
	mov rax, 0
	mov qword [rbp-74], rax; VAR_DECL_ASSIGN ARRAY variable sources[0]
	mov rax, 0
	mov qword [rbp-66], rax; VAR_DECL_ASSIGN ARRAY variable sources[1]
	mov rax, 0
	mov qword [rbp-58], rax; VAR_DECL_ASSIGN ARRAY variable sources[2]
	mov rax, 0
	mov qword [rbp-50], rax; VAR_DECL_ASSIGN ARRAY variable sources[3]
	mov rax, 0
	mov qword [rbp-42], rax; VAR_DECL_ASSIGN ARRAY variable sources[4]
	mov rax, 0
	mov qword [rbp-34], rax; VAR_DECL_ASSIGN ARRAY variable sources[5]
	mov rax, 0
	mov word [rbp-76], ax; VAR_DECL_ASSIGN else variable sourcesCount
	mov rax, 0
	mov qword [rbp-125], rax; VAR_DECL_ASSIGN ARRAY variable destinations[0]
	mov rax, 0
	mov qword [rbp-117], rax; VAR_DECL_ASSIGN ARRAY variable destinations[1]
	mov rax, 0
	mov qword [rbp-109], rax; VAR_DECL_ASSIGN ARRAY variable destinations[2]
	mov rax, 0
	mov qword [rbp-101], rax; VAR_DECL_ASSIGN ARRAY variable destinations[3]
	mov rax, 0
	mov qword [rbp-93], rax; VAR_DECL_ASSIGN ARRAY variable destinations[4]
	mov rax, 0
	mov qword [rbp-85], rax; VAR_DECL_ASSIGN ARRAY variable destinations[5]
	mov rax, 0
	mov word [rbp-127], ax; VAR_DECL_ASSIGN else variable destinationsCount
	mov rax, 0
	mov qword [rbp-135], rax; LOOP i
.label5:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-135], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	mov rax, qword [rbp-135]; printExpression variable i
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-136], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-136]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	movzx rax, byte [rbp-25]; printExpression variable parseInstructions
	test rax, rax
	jnz .if14
	jmp .else_if14
.if14:
	mov rax, 0
	mov byte [rbp-25], al; VAR_ASSIGNMENT else variable parseInstructions
	mov rax, qword [rbp-135]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-135], rax; VAR_ASSIGNMENT else variable i
	jmp .end_if14
.else_if14:
	mov rax, qword [rbp-135]; printExpression, left identifier, rbp variable i
	mov rbx, 14; printExpression, right int
	sub rax, rbx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 65; printExpression, right char 'A'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if15
	jmp .else_if15
.if15:
	movzx rax, word [rbp-76]; printExpression variable sourcesCount
	cmp rax, 6; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-135]; printExpression, left identifier, rbp variable i
	mov rbx, 16; printExpression, right int
	sub rax, rbx
	pop r11
	mov qword [rbp-74+r11*8], rax; VAR_ASSIGNMENT ARRAY sources
	movzx rax, word [rbp-76]; printExpression, left identifier, rbp variable sourcesCount
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [rbp-76], ax; VAR_ASSIGNMENT else variable sourcesCount
	jmp .end_if15
.else_if15:
	mov rax, qword [rbp-135]; printExpression, left identifier, rbp variable i
	mov rbx, 2; printExpression, right int
	sub rax, rbx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 90; printExpression, right char 'Z'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if16
	jmp .else_if16
.if16:
	movzx rax, word [rbp-127]; printExpression variable destinationsCount
	cmp rax, 6; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-135]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	sub rax, rbx
	pop r11
	mov qword [rbp-125+r11*8], rax; VAR_ASSIGNMENT ARRAY destinations
	movzx rax, word [rbp-127]; printExpression, left identifier, rbp variable destinationsCount
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [rbp-127], ax; VAR_ASSIGNMENT else variable destinationsCount
	jmp .end_if16
.else_if16:
	mov rax, qword [rbp-135]; printExpression, left identifier, rbp variable i
	mov rbx, 7; printExpression, right int
	sub rax, rbx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 90; printExpression, right char 'Z'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if17
	jmp .end_if17
.if17:
	movzx rax, word [rbp-127]; printExpression variable destinationsCount
	cmp rax, 6; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-135]; printExpression, left identifier, rbp variable i
	mov rbx, 9; printExpression, right int
	sub rax, rbx
	pop r11
	mov qword [rbp-125+r11*8], rax; VAR_ASSIGNMENT ARRAY destinations
	movzx rax, word [rbp-127]; printExpression, left identifier, rbp variable destinationsCount
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [rbp-127], ax; VAR_ASSIGNMENT else variable destinationsCount
	jmp .end_if17
.end_if17:
.end_if16:
.end_if15:
.end_if14:
	jmp .end_if13
.else_if13:
	movzx rax, byte [rbp-25]; printExpression variable parseInstructions
	test rax, rax
	jnz .if18
	jmp .end_if18
.if18:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable instructionSize
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable instructionSize
	jmp .end_if18
.end_if18:
.end_if13:
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-135]; LOOP i
	inc rax
	mov qword [rbp-135], rax; LOOP i
	jmp .label5
.not_label5:
	mov rax, 0
	mov qword [rbp-184], rax; VAR_DECL_ASSIGN ARRAY variable steps[0]
	mov rax, 0
	mov qword [rbp-176], rax; VAR_DECL_ASSIGN ARRAY variable steps[1]
	mov rax, 0
	mov qword [rbp-168], rax; VAR_DECL_ASSIGN ARRAY variable steps[2]
	mov rax, 0
	mov qword [rbp-160], rax; VAR_DECL_ASSIGN ARRAY variable steps[3]
	mov rax, 0
	mov qword [rbp-152], rax; VAR_DECL_ASSIGN ARRAY variable steps[4]
	mov rax, 0
	mov qword [rbp-144], rax; VAR_DECL_ASSIGN ARRAY variable steps[5]
	mov rax, 0
	mov byte [rbp-185], al; VAR_DECL_ASSIGN else variable stepCount
	mov rax, 0
	mov qword [rbp-193], rax; LOOP s
.label6:
	movzx rax, word [rbp-76]; printExpression variable sourcesCount
	cmp qword [rbp-193], rax; LOOP s
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 16
	mov rax, 0
	mov qword [rbp-201], rax; VAR_DECL_ASSIGN else variable step
	mov rax, qword [rbp-201]; printExpression, left identifier, rbp variable step
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable instructionSize
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov rax, rdx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-202], al; VAR_DECL_ASSIGN else variable instruction
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-193]; printExpression variable s
	cmp rax, 6; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp-74+rax*8]; printExpression array sources
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	movzx rax, byte [rbp-202]; printExpression, left identifier, rbp variable instruction
	mov rbx, 82; printExpression, right char 'R'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rsi, rax
	call Hash
	mov dword [rbp-206], eax; VAR_DECL_ASSIGN else variable currentHash
	mov rax, qword [rbp-201]; printExpression, left identifier, rbp variable step
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-201], rax; VAR_ASSIGNMENT else variable step
.label7:
	sub rsp, 16
	mov eax, dword [rbp-206]; printExpression variable currentHash
	mov rbx, 4
	mul rbx
	mov rbx, qword [rbp-16]
	add rax, rbx
	mov r11d, dword [rax]; printExpression ref hashBuffer
	mov rax, r11
	mov dword [rbp-210], eax; VAR_DECL_ASSIGN else variable offset
	mov rax, 0
	mov byte [rbp-211], al; VAR_DECL_ASSIGN else variable found
	mov rax, 0
	mov qword [rbp-219], rax; LOOP j
.label8:
	movzx rax, word [rbp-127]; printExpression variable destinationsCount
	cmp qword [rbp-219], rax; LOOP j
	jl .inside_label8
	jmp .not_label8
.inside_label8:
	mov rax, qword [rbp-219]; printExpression variable j
	cmp rax, 6; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp-125+rax*8]; printExpression array destinations
	mov rbx, r12; printExpression, nodeType=1, array index
	mov eax, dword [rbp-210]; printExpression, left identifier, rbp variable offset
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if19
	jmp .end_if19
.if19:
	mov rax, 1
	mov byte [rbp-211], al; VAR_ASSIGNMENT else variable found
	jmp .end_if19
.end_if19:
.skip_label8:
	mov rax, qword [rbp-219]; LOOP j
	inc rax
	mov qword [rbp-219], rax; LOOP j
	jmp .label8
.not_label8:
	movzx rax, byte [rbp-211]; printExpression variable found
	test rax, rax
	jnz .if20
	jmp .end_if20
.if20:
	jmp .not_label7
	jmp .end_if20
.end_if20:
	mov rax, qword [rbp-201]; printExpression, left identifier, rbp variable step
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable instructionSize
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov rax, rdx
	cmp rax, 13650; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-202], al; VAR_ASSIGNMENT else variable instruction
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov ebx, dword [rbp-210]; printExpression, right identifier, rbp variable offset
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	movzx rax, byte [rbp-202]; printExpression, left identifier, rbp variable instruction
	mov rbx, 82; printExpression, right char 'R'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rsi, rax
	call Hash
	mov dword [rbp-206], eax; VAR_ASSIGNMENT else variable currentHash
	mov rax, qword [rbp-201]; printExpression, left identifier, rbp variable step
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-201], rax; VAR_ASSIGNMENT else variable step
	add rsp, 16
.skip_label7:
	jmp .label7
.not_label7:
	movzx rax, byte [rbp-185]; printExpression variable stepCount
	cmp rax, 6; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-201]; printExpression variable step
	pop r11
	mov qword [rbp-184+r11*8], rax; VAR_ASSIGNMENT ARRAY steps
	movzx rax, byte [rbp-185]; printExpression, left identifier, rbp variable stepCount
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-185], al; VAR_ASSIGNMENT else variable stepCount
	add rsp, 16
.skip_label6:
	mov rax, qword [rbp-193]; LOOP s
	inc rax
	mov qword [rbp-193], rax; LOOP s
	jmp .label6
.not_label6:
	mov rax, 0
	cmp rax, 6; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp-184+rax*8]; printExpression array steps
	mov rax, r12
	mov qword [rbp-201], rax; VAR_DECL_ASSIGN else variable lcm
	mov rax, 1
	mov qword [rbp-209], rax; LOOP i
.label9:
	movzx rax, byte [rbp-185]; printExpression variable stepCount
	cmp qword [rbp-209], rax; LOOP i
	jl .inside_label9
	jmp .not_label9
.inside_label9:
	sub rsp, 40
	mov rax, qword [rbp-209]; printExpression variable i
	cmp rax, 6; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp-184+rax*8]; printExpression array steps
	mov rax, r12
	mov qword [rbp-217], rax; VAR_DECL_ASSIGN else variable step
	mov rax, qword [rbp-201]; printExpression variable lcm
	mov rdi, rax
	mov rax, qword [rbp-217]; printExpression variable step
	mov rsi, rax
	call LCM
	mov qword [rbp-201], rax; VAR_ASSIGNMENT else variable lcm
	add rsp, 40
.skip_label9:
	mov rax, qword [rbp-209]; LOOP i
	inc rax
	mov qword [rbp-209], rax; LOOP i
	jmp .label9
.not_label9:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-201]; variable lcm
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rsi, rax
	mov rax, qword [rbp-16]; printExpression variable hashBuffer
	mov rdi, rax
	mov rax, 11
	syscall
	mov rax, 0
	add rsp, 224
	jmp .exit
	add rsp, 224
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============
	global _start

_start:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 48
	mov rax, 1
	cmp rax, qword [rbp+16]; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp+16+rax*8]; printExpression array argv
	mov rax, r12
	mov rdi, rax
	mov rax, 0
	mov rsi, rax
	mov rax, 0
	mov rdx, rax
	mov rax, 2
	syscall
	mov dword [rbp-4], eax; VAR_DECL_ASSIGN else variable fd
	movsxd rax, dword [rbp-4]; printExpression, left identifier, rbp variable fd
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if21
	jmp .end_if21
.if21:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str8
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 48
	jmp .exit
	jmp .end_if21
.end_if21:
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 13627
	mov rdx, rax
	mov rax, 0
	syscall
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable size
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp variable size
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if22
	jmp .end_if22
.if22:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str9
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 48
	jmp .exit
	jmp .end_if22
.end_if22:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	mov qword [rbp-20], rax; VAR_DECL_ASSIGN else variable buffer
	mov rax, qword [rbp-20]; printExpression variable buffer
	mov rsi, rax
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 48
.exit:
	mov rax, 60
	syscall
