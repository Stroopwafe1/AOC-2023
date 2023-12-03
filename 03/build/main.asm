section .data
	str0: db " ",0
	str1: db " ",0xA,0
	str2: db "k: ",0
	str3: db " index: ",0
	str4: db " offset: ",0
	str5: db " length: ",0
	str6: db " char: ",0
	str7: db " ",0
	str8: db " + ",0
	str9: db " = ",0
	str10: db "Sum part 1: ",0
	str11: db "Could not open file",0xA,0
	str12: db "Could not read from file",0xA,0
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
	sub rsp, 40
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
	mov dword [rbp-17], eax; VAR_DECL_ASSIGN else variable lineLength
	mov rax, 0
	mov qword [rbp-25], rax; LOOP i
.label1:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-25], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 25
	mov rax, qword [rbp-25]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
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
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	sub eax, ebx
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable number
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
	movzx rax, byte [rbp-27]; printExpression variable number
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
	movzx rax, byte [rbp-27]; printExpression variable number
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
	movzx rax, byte [rbp-27]; printExpression variable number
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
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
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
	mov eax, dword [rbp-17]; printExpression, left identifier, rbp variable lineLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .end_if5
.if5:
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov dword [rbp-17], eax; VAR_ASSIGNMENT else variable lineLength
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
	mov qword [rbp-34], rax; VAR_DECL_ASSIGN else variable number
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	push rax
	mov rax, qword [rbp-34]; printExpression variable number
	pop r11
	mov dword [s_numbers+r11*4], eax; VAR_ASSIGNMENT ARRAY s_numbers
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	push rax
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
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
	mov rax, qword [rbp-25]; LOOP i
	inc rax
	mov qword [rbp-25], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, 0
	mov qword [rbp-33], rax; LOOP i
.label2:
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	cmp qword [rbp-33], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 16
	mov rax, qword [rbp-33]; printExpression variable i
	mov r12d, dword [s_numbers+rax*4]; printExpression array s_numbers
	mov rax, r12
	mov dword [rbp-37], eax; VAR_DECL_ASSIGN else variable num
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + VARIABLE ===============
	mov edi, dword [rbp-37]; variable num
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 1
	syscall
; =============== END FUNC CALL + STRING ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	add rsp, 16
.skip_label2:
	mov rax, qword [rbp-33]; LOOP i
	inc rax
	mov qword [rbp-33], rax; LOOP i
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
	mov rdx, 1
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
	mov edi, dword [rbp-17]; variable lineLength
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
	mov qword [rbp-41], rax; LOOP i
.label3:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-41], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 49
	mov rax, qword [rbp-41]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-42], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
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
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 46; printExpression, right char '.'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
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
	jmp .skip_label3
	jmp .end_if7
.end_if7:
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov ebx, dword [rbp-17]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov dword [rbp-75], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[0]
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov ebx, dword [rbp-17]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	mov dword [rbp-71], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[1]
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov ebx, dword [rbp-17]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov dword [rbp-67], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[2]
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	mov dword [rbp-63], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[3]
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov dword [rbp-59], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[4]
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov ebx, dword [rbp-17]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	mov dword [rbp-55], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[5]
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov ebx, dword [rbp-17]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	mov dword [rbp-51], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[6]
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov ebx, dword [rbp-17]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov dword [rbp-47], eax; VAR_DECL_ASSIGN ARRAY variable cardinalities[7]
	mov rax, 0
	mov qword [rbp-83], rax; LOOP j
.label4:
	movzx rax, word [s_numbers_size]; printExpression global variable s_numbers_size
	cmp qword [rbp-83], rax; LOOP j
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 13
	mov rax, 0
	mov byte [rbp-84], al; LOOP k
.label5:
	mov rax, 8
	cmp byte [rbp-84], al; LOOP k
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 16
	movzx rax, byte [rbp-84]; printExpression variable k
	mov r12d, dword [rbp-75+rax*4]; printExpression array cardinalities
	mov rax, r12
	mov dword [rbp-88], eax; VAR_DECL_ASSIGN else variable cardinality
	mov rax, qword [rbp-83]; printExpression variable j
	mov r12d, dword [s_offsets+rax*4]; printExpression array s_offsets
	mov rbx, r12; printExpression, nodeType=1, array index
	mov eax, dword [rbp-88]; printExpression, left identifier, rbp variable cardinality
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-83]; printExpression variable j
	mov r12d, dword [s_offsets+rax*4]; printExpression array s_offsets
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-83]; printExpression variable j
	mov r12d, dword [s_lengths+rax*4]; printExpression array s_lengths
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov eax, dword [rbp-88]; printExpression, left identifier, rbp variable cardinality
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
	mov rax, qword [rbp-83]; printExpression variable j
	movzx r12, byte [s_not_addeds+rax*1]; printExpression array s_not_addeds
	mov rax, r12
	test rax, rax
	jnz .if9
	jmp .end_if9
.if9:
	sub rsp, 24
	mov rax, qword [rbp-83]; printExpression variable j
	mov r12d, dword [s_numbers+rax*4]; printExpression array s_numbers
	mov rax, r12
	mov dword [rbp-92], eax; VAR_DECL_ASSIGN else variable num
	mov rax, qword [rbp-83]; printExpression variable j
	mov r12d, dword [s_offsets+rax*4]; printExpression array s_offsets
	mov rax, r12
	mov dword [rbp-96], eax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-83]; printExpression variable j
	mov r12d, dword [s_lengths+rax*4]; printExpression array s_lengths
	mov rax, r12
	mov dword [rbp-100], eax; VAR_DECL_ASSIGN else variable length
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
	mov rdx, 3
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
	movzx rdi, byte [rbp-84]; variable k
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 8
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
	mov edi, dword [rbp-88]; variable cardinality
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 9
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
	mov edi, dword [rbp-96]; variable offset
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 9
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
	mov edi, dword [rbp-100]; variable length
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 7
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
	movzx rdi, byte [rbp-42]; variable byte
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 1
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
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str8
	mov rdx, 3
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
	mov edi, dword [rbp-92]; variable num
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str9
	mov rdx, 3
	syscall
; =============== END FUNC CALL + STRING ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, qword [rbp-83]; printExpression variable j
	mov r12d, dword [s_numbers+rax*4]; printExpression array s_numbers
	mov rbx, r12; printExpression, nodeType=1, array index
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable sum
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
	mov rax, qword [rbp-83]; printExpression variable j
	push rax
	mov rax, 0
	pop r11
	mov byte [s_not_addeds+r11*1], al; VAR_ASSIGNMENT ARRAY s_not_addeds
	jmp .not_label5
	add rsp, 24
	jmp .end_if9
.end_if9:
	add rsp, 12
	jmp .end_if8
.end_if8:
	add rsp, 16
.skip_label5:
	mov al, byte [rbp-84]; LOOP k
	inc rax
	mov byte [rbp-84], al; LOOP k
	jmp .label5
.not_label5:
	add rsp, 13
.skip_label4:
	mov rax, qword [rbp-83]; LOOP j
	inc rax
	mov qword [rbp-83], rax; LOOP j
	jmp .label4
.not_label4:
	add rsp, 49
.skip_label3:
	mov rax, qword [rbp-41]; LOOP i
	inc rax
	mov qword [rbp-41], rax; LOOP i
	jmp .label3
.not_label3:
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
	mov rsi, str10
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
	mov rax, 0
	add rsp, 40
	jmp .exit
	add rsp, 40
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
	sub rsp, 12
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
	jnz .if10
	jmp .end_if10
.if10:
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
	mov rsi, str11
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
	add rsp, 12
	jmp .exit
	jmp .end_if10
.end_if10:
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
	jnz .if11
	jmp .end_if11
.if11:
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
	mov rsi, str12
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
	add rsp, 12
	jmp .exit
	jmp .end_if11
.end_if11:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	mov rax, 0
	mov rdi, rax
	add rsp, 12
.exit:
	mov rax, 60
	syscall
