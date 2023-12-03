section .data
	str0: db "Sum part 1: ",0
	str1: db "Sum part 2: ",0
	str2: db "Could not open file",0xA,0
	str3: db "Could not read from file",0xA,0
	s_numbers_size dw 0
section .bss
	s_buffer resb 19750
	s_lengths resd 1224
	s_not_addeds resb 1224
	s_numbers resd 1224
	s_offsets resd 1224

section .text
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
	push rbp
	mov rbp, rsp
	push rbx
	mov rbx, rdi ; Count characters in string
	mov rdx, 0
strCountLoop:
	cmp byte [rbx], 0x0
	je strCountDone
	inc rdx
	inc rbx
	jmp strCountLoop
strCountDone:
	cmp rdx, 0
	je prtDone
	; Actually call the syscall now
	mov rax, 1
	mov rsi, rdi
	mov rdi, 1
	syscall
prtDone:
	pop rbx
	pop rbp
	ret

global Part1
Part1:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 33
	mov rax, 0
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov byte [rbp-12], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[0]
	mov rax, 0
	mov byte [rbp-11], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[1]
	mov rax, 0
	mov byte [rbp-10], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[2]
	mov rax, 0
	mov byte [rbp-13], al; VAR_DECL_ASSIGN else variable buffLength
	mov rax, 0
	mov byte [rbp-14], al; VAR_DECL_ASSIGN else variable lineLength
	mov rax, 0
	mov qword [rbp-22], rax; LOOP i
.label1:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-22], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 25
	mov rax, qword [rbp-22]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-23], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-23]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-23]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	sub rsp, 1
	movzx rax, byte [rbp-23]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	sub eax, ebx
	mov byte [rbp-24], al; VAR_DECL_ASSIGN else variable number
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .else_if2
.if2:
	mov rax, 2
	push rax
	movzx rax, byte [rbp-24]; printExpression variable number
	pop r11
	mov byte [rbp-12+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if2
.else_if2:
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .else_if3
.if3:
	mov rax, 1
	push rax
	mov rax, 2
	movzx r12, byte [rbp-12+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-12+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 2
	push rax
	movzx rax, byte [rbp-24]; printExpression variable number
	pop r11
	mov byte [rbp-12+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if3
.else_if3:
	mov rax, 0
	push rax
	mov rax, 1
	movzx r12, byte [rbp-12+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-12+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	push rax
	mov rax, 2
	movzx r12, byte [rbp-12+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-12+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 2
	push rax
	movzx rax, byte [rbp-24]; printExpression variable number
	pop r11
	mov byte [rbp-12+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
.end_if3:
.end_if2:
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-13], al; VAR_ASSIGNMENT else variable buffLength
	add rsp, 1
	jmp .end_if1
.else_if1:
	sub rsp, 24
	movzx rax, byte [rbp-23]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .end_if4
.if4:
	movzx rax, byte [rbp-14]; printExpression, left identifier, rbp variable lineLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .end_if5
.if5:
	mov rax, qword [rbp-22]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov byte [rbp-14], al; VAR_ASSIGNMENT else variable lineLength
	jmp .end_if5
.end_if5:
	jmp .end_if4
.end_if4:
	movzx rax, byte [rbp-13]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	sub rsp, 32
	mov rax, 0
	movzx r12, byte [rbp-12+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 100; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-12+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 10; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 2
	movzx r12, byte [rbp-12+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov qword [rbp-31], rax; VAR_DECL_ASSIGN else variable number
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	push rax
	mov rax, qword [rbp-31]; printExpression variable number
	pop r11
	mov dword [s_numbers+r11*4], eax; VAR_ASSIGNMENT ARRAY s_numbers
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	push rax
	mov rax, qword [rbp-22]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-13]; printExpression, right identifier, rbp variable buffLength
	sub rax, rbx
	pop r11
	mov dword [s_offsets+r11*4], eax; VAR_ASSIGNMENT ARRAY s_offsets
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	push rax
	movzx rax, byte [rbp-13]; printExpression variable buffLength
	pop r11
	mov dword [s_lengths+r11*4], eax; VAR_ASSIGNMENT ARRAY s_lengths
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	push rax
	mov rax, 1
	pop r11
	mov byte [s_not_addeds+r11*1], al; VAR_ASSIGNMENT ARRAY s_not_addeds
	movzx rax, word [s_numbers_size]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_numbers_size], ax; VAR_ASSIGNMENT else variable s_numbers_size
	mov rax, 0
	mov byte [rbp-12], al; VAR_ASSIGNMENT ARRAY numBuffer[0]
	mov rax, 0
	mov byte [rbp-11], al; VAR_ASSIGNMENT ARRAY numBuffer[1]
	mov rax, 0
	mov byte [rbp-10], al; VAR_ASSIGNMENT ARRAY numBuffer[2]
	mov rax, 0
	mov byte [rbp-13], al; VAR_ASSIGNMENT else variable buffLength
	add rsp, 32
	jmp .end_if6
.end_if6:
	add rsp, 24
.end_if1:
	add rsp, 25
.skip_label1:
	mov rax, qword [rbp-22]; LOOP i
	inc rax
	mov qword [rbp-22], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, 0
	mov qword [rbp-30], rax; LOOP i
.label2:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-30], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 49
	mov rax, qword [rbp-30]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-31], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable byte
	mov rbx, 46; printExpression, right char '.'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or ax, bx
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or ax, bx
	test rax, rax
	jnz .if7
	jmp .end_if7
.if7:
	jmp .skip_label2
	jmp .end_if7
.end_if7:
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-14]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov dword [rbp-64], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[0]
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-14]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	mov dword [rbp-60], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[1]
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-14]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov dword [rbp-56], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[2]
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	mov dword [rbp-52], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[3]
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov dword [rbp-48], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[4]
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-14]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov dword [rbp-44], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[5]
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-14]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	mov dword [rbp-40], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[6]
	mov rax, qword [rbp-30]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-14]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov dword [rbp-36], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[7]
	mov rax, 0
	mov qword [rbp-72], rax; LOOP j
.label3:
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	cmp qword [rbp-72], rax; LOOP j
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 13
	mov rax, 0
	mov byte [rbp-73], al; LOOP k
.label4:
	mov rax, 8
	cmp byte [rbp-73], al; LOOP k
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 16
	movzx rax, byte [rbp-73]; printExpression variable k
	mov r12d, dword [rbp-64+rax*4]; printExpression array cardinalities
	mov rax, r12
	mov dword [rbp-77], eax; VAR_DECL_ASSIGN else variable cardinality
	mov rax, qword [rbp-72]; printExpression variable j
	mov r12d, dword [s_offsets+rax*4]; printExpression array s_offsets
	mov rbx, r12; printExpression, nodeType=1, array index
	mov eax, dword [rbp-77]; printExpression, left identifier, rbp variable cardinality
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-72]; printExpression variable j
	mov r12d, dword [s_offsets+rax*4]; printExpression array s_offsets
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-72]; printExpression variable j
	mov r12d, dword [s_lengths+rax*4]; printExpression array s_lengths
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov eax, dword [rbp-77]; printExpression, left identifier, rbp variable cardinality
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	sub rsp, 12
	mov rax, qword [rbp-72]; printExpression variable j
	movzx r12, byte [s_not_addeds+rax*1]; printExpression array s_not_addeds
	mov rax, r12
	test rax, rax
	jnz .if9
	jmp .end_if9
.if9:
	sub rsp, 16
	mov rax, qword [rbp-72]; printExpression variable j
	mov r12d, dword [s_numbers+rax*4]; printExpression array s_numbers
	mov rax, r12
	mov dword [rbp-81], eax; VAR_DECL_ASSIGN else variable num
	mov rax, qword [rbp-72]; printExpression variable j
	mov r12d, dword [s_numbers+rax*4]; printExpression array s_numbers
	mov rbx, r12; printExpression, nodeType=1, array index
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable sum
	mov rax, qword [rbp-72]; printExpression variable j
	push rax
	mov rax, 0
	pop r11
	mov byte [s_not_addeds+r11*1], al; VAR_ASSIGNMENT ARRAY s_not_addeds
	jmp .not_label4
	add rsp, 16
	jmp .end_if9
.end_if9:
	add rsp, 12
	jmp .end_if8
.end_if8:
	add rsp, 16
.skip_label4:
	mov al, byte [rbp-73]; LOOP k
	inc rax
	mov byte [rbp-73], al; LOOP k
	jmp .label4
.not_label4:
	add rsp, 13
.skip_label3:
	mov rax, qword [rbp-72]; LOOP j
	inc rax
	mov qword [rbp-72], rax; LOOP j
	jmp .label3
.not_label3:
	add rsp, 49
.skip_label2:
	mov rax, qword [rbp-30]; LOOP i
	inc rax
	mov qword [rbp-30], rax; LOOP i
	jmp .label2
.not_label2:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-8]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	movzx rax, byte [rbp-14]; printExpression variable lineLength
	add rsp, 33
	jmp .exit
	add rsp, 33
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
	sub rsp, 25
	movzx rax, byte sil; printExpression variable lineLen
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable lineLength
	mov rax, 0
	mov qword [rbp-9], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov qword [rbp-17], rax; LOOP i
.label5:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-17], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 42
	mov rax, qword [rbp-17]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-18], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-18]; printExpression, left identifier, rbp variable byte
	mov rbx, 42; printExpression, right char '*'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .end_if10
.if10:
	jmp .skip_label5
	jmp .end_if10
.end_if10:
	mov rax, 0
	mov word [rbp-23], ax; VAR_DECL_ASSIGN ARRAY variable parts[0]
	mov rax, 0
	mov word [rbp-21], ax; VAR_DECL_ASSIGN ARRAY variable parts[1]
	mov rax, 0
	mov byte [rbp-24], al; VAR_DECL_ASSIGN else variable partNum
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-1]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov dword [rbp-57], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[0]
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-1]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	mov dword [rbp-53], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[1]
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-1]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov dword [rbp-49], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[2]
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	mov dword [rbp-45], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[3]
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov dword [rbp-41], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[4]
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-1]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov dword [rbp-37], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[5]
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-1]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	mov dword [rbp-33], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[6]
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-1]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov dword [rbp-29], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[7]
	mov rax, 0
	mov qword [rbp-65], rax; LOOP j
.label6:
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	cmp qword [rbp-65], rax; LOOP j
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 4
	mov rax, 0
	mov byte [rbp-66], al; LOOP k
.label7:
	mov rax, 8
	cmp byte [rbp-66], al; LOOP k
	jl .inside_label7
	jmp .not_label7
.inside_label7:
	sub rsp, 4
	movzx rax, byte [rbp-66]; printExpression variable k
	mov r12d, dword [rbp-57+rax*4]; printExpression array cardinalities
	mov rax, r12
	mov dword [rbp-70], eax; VAR_DECL_ASSIGN else variable cardinality
	mov rax, qword [rbp-65]; printExpression variable j
	mov r12d, dword [s_offsets+rax*4]; printExpression array s_offsets
	mov rbx, r12; printExpression, nodeType=1, array index
	mov eax, dword [rbp-70]; printExpression, left identifier, rbp variable cardinality
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-65]; printExpression variable j
	mov r12d, dword [s_offsets+rax*4]; printExpression array s_offsets
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-65]; printExpression variable j
	mov r12d, dword [s_lengths+rax*4]; printExpression array s_lengths
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov eax, dword [rbp-70]; printExpression, left identifier, rbp variable cardinality
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if11
	jmp .end_if11
.if11:
	movzx rax, byte [rbp-24]; printExpression variable partNum
	push rax
	mov rax, qword [rbp-65]; printExpression variable j
	mov r12d, dword [s_numbers+rax*4]; printExpression array s_numbers
	mov rax, r12
	pop r11
	mov word [rbp-23+r11*2], ax; VAR_ASSIGNMENT ARRAY parts
	movzx rax, byte [rbp-24]; printExpression, left identifier, rbp variable partNum
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-24], al; VAR_ASSIGNMENT else variable partNum
	jmp .not_label7
	jmp .end_if11
.end_if11:
	add rsp, 4
.skip_label7:
	mov al, byte [rbp-66]; LOOP k
	inc rax
	mov byte [rbp-66], al; LOOP k
	jmp .label7
.not_label7:
	add rsp, 4
.skip_label6:
	mov rax, qword [rbp-65]; LOOP j
	inc rax
	mov qword [rbp-65], rax; LOOP j
	jmp .label6
.not_label6:
	movzx rax, byte [rbp-24]; printExpression, left identifier, rbp variable partNum
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .end_if12
.if12:
	mov rax, 0
	movzx r12, word [rbp-23+rax*2]; printExpression array parts
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, word [rbp-23+rax*2]; printExpression array parts
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-9]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-9], rax; VAR_ASSIGNMENT else variable sum
	jmp .end_if12
.end_if12:
	add rsp, 42
.skip_label5:
	mov rax, qword [rbp-17]; LOOP i
	inc rax
	mov qword [rbp-17], rax; LOOP i
	jmp .label5
.not_label5:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-9]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, 0
	add rsp, 25
	jmp .exit
	add rsp, 25
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
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 1
	mov r12, qword [rbp+16+rax*8]; printExpression array argv
	mov rax, r12
	mov rdi, rax
	mov rax, 0
	mov rsi, rax
	mov rax, 0
	mov rdx, rax
	mov rax, 2
	syscall
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov dword [rbp-4], eax; VAR_DECL_ASSIGN else variable fd
	movsxd rax, dword [rbp-4]; printExpression, left identifier, rbp variable fd
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .end_if13
.if13:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if13
.end_if13:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 19740
	mov rdx, rax
	mov rax, 0
	syscall
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable size
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp variable size
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if14
.end_if14:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-13], al; VAR_DECL_ASSIGN else variable lineLength
	movzx rax, byte [rbp-13]; printExpression variable lineLength
	mov rsi, rax
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
