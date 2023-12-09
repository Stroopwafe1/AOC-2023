section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Hash collission!!",0xA,0
	str1: db "L with ",0
	str2: db " ",0xA,0
	str3: db "Hash collission!!",0xA,0
	str4: db "R with ",0
	str5: db " ",0xA,0
	str6: db "Number of steps: ",0
	str7: db "Could not open file",0xA,0
	str8: db "Could not read from file",0xA,0
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
.label2:
	mov rax, qword [rbp-17]; printExpression variable length
	cmp qword [rbp-45], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
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
	jnz .if3
	jmp .else_if3
.if3:
	movzx rax, byte [rbp-1]; printExpression variable parseInstructions
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
	mov rax, 0
	mov byte [rbp-1], al; VAR_ASSIGNMENT else variable parseInstructions
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-45], rax; VAR_ASSIGNMENT else variable i
	jmp .end_if4
.else_if4:
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
	jnz .if5
	jmp .end_if5
.if5:
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
	jmp .end_if5
.end_if5:
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
	jmp .end_if6
.end_if6:
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
	jnz .if7
	jmp .end_if7
.if7:
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
	jnz .if8
	jmp .else_if8
.if8:
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 9; printExpression, right int
	sub rax, rbx
	mov qword [rbp-29], rax; VAR_ASSIGNMENT else variable destOffset
	jmp .end_if8
.else_if8:
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
	jnz .if9
	jmp .end_if9
.if9:
	mov rax, qword [rbp-45]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	sub rax, rbx
	mov qword [rbp-29], rax; VAR_ASSIGNMENT else variable destOffset
	jmp .end_if9
.end_if9:
.end_if8:
	jmp .end_if7
.end_if7:
	add rsp, 16
.end_if4:
	jmp .end_if3
.else_if3:
	movzx rax, byte [rbp-1]; printExpression variable parseInstructions
	test rax, rax
	jnz .if10
	jmp .end_if10
.if10:
	mov rax, qword [rbp-9]; printExpression, left identifier, rbp variable instructionSize
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-9], rax; VAR_ASSIGNMENT else variable instructionSize
	jmp .end_if10
.end_if10:
.end_if3:
	add rsp, 8
.skip_label2:
	mov rax, qword [rbp-45]; LOOP i
	inc rax
	mov qword [rbp-45], rax; LOOP i
	jmp .label2
.not_label2:
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
.label3:
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
	jnz .if11
	jmp .end_if11
.if11:
	jmp .not_label3
	jmp .end_if11
.end_if11:
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
	jmp .label3
.not_label3:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 17
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-53]; variable steps
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
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
	mov rax, 0
	jmp .exit
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
	sub rsp, 16
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
	jnz .if12
	jmp .end_if12
.if12:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if12
.end_if12:
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
	jnz .if13
	jmp .end_if13
.if13:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str8
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if13
.end_if13:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
