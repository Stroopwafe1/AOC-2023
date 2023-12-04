section .data
	str0: db "Sum part 1: ",0
	str1: db "Sum part 2: ",0
	str2: db "Could not open file",0xA,0
	str3: db "Could not read from file",0xA,0
section .bss
	s_buffer resb 24110
	s_game_copies resd 206

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

global Part1_and_2
Part1_and_2:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 55
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable gameCount
	mov rax, 0
	mov byte [rbp-21], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[0]
	mov rax, 0
	mov byte [rbp-20], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[1]
	mov rax, 0
	mov byte [rbp-19], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[2]
	mov rax, 0
	mov byte [rbp-22], al; VAR_DECL_ASSIGN else variable buffLength
	mov rax, 0
	mov byte [rbp-33], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[0]
	mov rax, 0
	mov byte [rbp-32], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[1]
	mov rax, 0
	mov byte [rbp-31], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[2]
	mov rax, 0
	mov byte [rbp-30], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[3]
	mov rax, 0
	mov byte [rbp-29], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[4]
	mov rax, 0
	mov byte [rbp-28], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[5]
	mov rax, 0
	mov byte [rbp-27], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[6]
	mov rax, 0
	mov byte [rbp-26], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[7]
	mov rax, 0
	mov byte [rbp-25], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[8]
	mov rax, 0
	mov byte [rbp-24], al; VAR_DECL_ASSIGN ARRAY variable winningNumbers[9]
	mov rax, 0
	mov byte [rbp-34], al; VAR_DECL_ASSIGN else variable winningNumbersSize
	mov rax, 0
	mov dword [rbp-38], eax; VAR_DECL_ASSIGN else variable parseOurNumbers
	mov rax, 0
	mov byte [rbp-39], al; VAR_DECL_ASSIGN else variable currentGame
	mov rax, 0
	mov byte [rbp-40], al; VAR_DECL_ASSIGN else variable matches
	mov rax, 0
	mov qword [rbp-48], rax; LOOP i
.label1:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-48], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 13
	mov rax, qword [rbp-48]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-49], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
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
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	sub eax, ebx
	mov byte [rbp-50], al; VAR_DECL_ASSIGN else variable number
	movzx rax, byte [rbp-22]; printExpression, left identifier, rbp variable buffLength
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
	movzx rax, byte [rbp-50]; printExpression variable number
	pop r11
	mov byte [rbp-21+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if2
.else_if2:
	movzx rax, byte [rbp-22]; printExpression, left identifier, rbp variable buffLength
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
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-21+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 2
	push rax
	movzx rax, byte [rbp-50]; printExpression variable number
	pop r11
	mov byte [rbp-21+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if3
.else_if3:
	mov rax, 0
	push rax
	mov rax, 1
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-21+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	push rax
	mov rax, 2
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-21+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 2
	push rax
	movzx rax, byte [rbp-50]; printExpression variable number
	pop r11
	mov byte [rbp-21+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
.end_if3:
.end_if2:
	movzx rax, byte [rbp-22]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-22], al; VAR_ASSIGNMENT else variable buffLength
	jmp .end_if1
.else_if1:
	sub rsp, 12
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
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
	sub rsp, 24
	mov rax, 0
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 100; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
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
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov qword [rbp-57], rax; VAR_DECL_ASSIGN else variable number
	mov rax, 0
	mov qword [rbp-65], rax; LOOP j
.label2:
	movzx rax, byte [rbp-34]; printExpression variable winningNumbersSize
	cmp qword [rbp-65], rax; LOOP j
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	mov rax, qword [rbp-65]; printExpression variable j
	movzx r12, byte [rbp-33+rax*1]; printExpression array winningNumbers
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-57]; printExpression, right identifier, rbp variable number
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .end_if5
.if5:
	movzx rax, byte [rbp-40]; printExpression, left identifier, rbp variable matches
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-40], al; VAR_ASSIGNMENT else variable matches
	jmp .end_if5
.end_if5:
.skip_label2:
	mov rax, qword [rbp-65]; LOOP j
	inc rax
	mov qword [rbp-65], rax; LOOP j
	jmp .label2
.not_label2:
	movzx rax, byte [rbp-40]; printExpression, left identifier, rbp variable matches
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	sub rsp, 20
	movzx rax, byte [rbp-40]; printExpression, left identifier, rbp variable matches
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, 1; printExpression, left int
	mov rcx, rbx; printExpression, shift left
	shl rax, cl
	mov dword [rbp-69], eax; VAR_DECL_ASSIGN else variable points
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov ebx, dword [rbp-69]; printExpression, right identifier, rbp variable points
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	mov rax, 0
	mov qword [rbp-77], rax; LOOP k
.label3:
	movzx rax, byte [rbp-40]; printExpression variable matches
	cmp qword [rbp-77], rax; LOOP k
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 4
	movzx rax, byte [rbp-17]; printExpression, left identifier, rbp variable gameCount
	mov rbx, qword [rbp-77]; printExpression, right identifier, rbp variable k
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov byte [rbp-78], al; VAR_DECL_ASSIGN else variable index
	movzx rax, byte [rbp-78]; printExpression variable index
	push rax
	movzx rax, byte [rbp-78]; printExpression variable index
	mov r12d, dword [s_game_copies+rax*4]; printExpression array s_game_copies
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-17]; printExpression variable gameCount
	mov r12d, dword [s_game_copies+rax*4]; printExpression array s_game_copies
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov dword [s_game_copies+r11*4], eax; VAR_ASSIGNMENT ARRAY s_game_copies
.skip_label3:
	mov rax, qword [rbp-77]; LOOP k
	inc rax
	mov qword [rbp-77], rax; LOOP k
	jmp .label3
.not_label3:
	jmp .end_if6
.end_if6:
	mov rax, qword [rbp-48]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	add rax, rbx
	mov qword [rbp-48], rax; VAR_ASSIGNMENT else variable i
	mov rax, 0
	mov dword [rbp-38], eax; VAR_ASSIGNMENT else variable parseOurNumbers
	mov rax, 0
	mov byte [rbp-33], al; VAR_ASSIGNMENT ARRAY winningNumbers[0]
	mov rax, 0
	mov byte [rbp-32], al; VAR_ASSIGNMENT ARRAY winningNumbers[1]
	mov rax, 0
	mov byte [rbp-31], al; VAR_ASSIGNMENT ARRAY winningNumbers[2]
	mov rax, 0
	mov byte [rbp-30], al; VAR_ASSIGNMENT ARRAY winningNumbers[3]
	mov rax, 0
	mov byte [rbp-29], al; VAR_ASSIGNMENT ARRAY winningNumbers[4]
	mov rax, 0
	mov byte [rbp-28], al; VAR_ASSIGNMENT ARRAY winningNumbers[5]
	mov rax, 0
	mov byte [rbp-27], al; VAR_ASSIGNMENT ARRAY winningNumbers[6]
	mov rax, 0
	mov byte [rbp-26], al; VAR_ASSIGNMENT ARRAY winningNumbers[7]
	mov rax, 0
	mov byte [rbp-25], al; VAR_ASSIGNMENT ARRAY winningNumbers[8]
	mov rax, 0
	mov byte [rbp-24], al; VAR_ASSIGNMENT ARRAY winningNumbers[9]
	mov rax, 0
	mov byte [rbp-34], al; VAR_ASSIGNMENT else variable winningNumbersSize
	mov rax, 0
	mov byte [rbp-39], al; VAR_ASSIGNMENT else variable currentGame
	mov rax, 0
	mov byte [rbp-40], al; VAR_ASSIGNMENT else variable matches
	mov rax, 0
	mov byte [rbp-21], al; VAR_ASSIGNMENT ARRAY numBuffer[0]
	mov rax, 0
	mov byte [rbp-20], al; VAR_ASSIGNMENT ARRAY numBuffer[1]
	mov rax, 0
	mov byte [rbp-19], al; VAR_ASSIGNMENT ARRAY numBuffer[2]
	mov rax, 0
	mov byte [rbp-22], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-17]; printExpression, left identifier, rbp variable gameCount
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable gameCount
	jmp .end_if4
.else_if4:
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
	mov rbx, 124; printExpression, right char '|'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .end_if7
.if7:
	mov rax, 1
	mov dword [rbp-38], eax; VAR_ASSIGNMENT else variable parseOurNumbers
	jmp .end_if7
.end_if7:
.end_if4:
	movzx rax, byte [rbp-22]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	sub rsp, 20
	mov rax, 0
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 100; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
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
	movzx r12, byte [rbp-21+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov qword [rbp-57], rax; VAR_DECL_ASSIGN else variable number
	movzx rax, byte [rbp-39]; printExpression, left identifier, rbp variable currentGame
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	mov rax, qword [rbp-57]; printExpression variable number
	mov byte [rbp-39], al; VAR_ASSIGNMENT else variable currentGame
	jmp .end_if9
.else_if9:
	mov eax, dword [rbp-38]; printExpression !parseOurNumbers
	xor rax, 1
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	movzx rax, byte [rbp-34]; printExpression variable winningNumbersSize
	push rax
	mov rax, qword [rbp-57]; printExpression variable number
	pop r11
	mov byte [rbp-33+r11*1], al; VAR_ASSIGNMENT ARRAY winningNumbers
	movzx rax, byte [rbp-34]; printExpression, left identifier, rbp variable winningNumbersSize
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-34], al; VAR_ASSIGNMENT else variable winningNumbersSize
	jmp .end_if10
.else_if10:
	sub rsp, 16
	mov rax, 0
	mov qword [rbp-65], rax; LOOP j
.label4:
	movzx rax, byte [rbp-34]; printExpression variable winningNumbersSize
	cmp qword [rbp-65], rax; LOOP j
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	mov rax, qword [rbp-65]; printExpression variable j
	movzx r12, byte [rbp-33+rax*1]; printExpression array winningNumbers
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-57]; printExpression, right identifier, rbp variable number
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .end_if11
.if11:
	movzx rax, byte [rbp-40]; printExpression, left identifier, rbp variable matches
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-40], al; VAR_ASSIGNMENT else variable matches
	jmp .end_if11
.end_if11:
.skip_label4:
	mov rax, qword [rbp-65]; LOOP j
	inc rax
	mov qword [rbp-65], rax; LOOP j
	jmp .label4
.not_label4:
.end_if10:
.end_if9:
	mov rax, 0
	mov byte [rbp-21], al; VAR_ASSIGNMENT ARRAY numBuffer[0]
	mov rax, 0
	mov byte [rbp-20], al; VAR_ASSIGNMENT ARRAY numBuffer[1]
	mov rax, 0
	mov byte [rbp-19], al; VAR_ASSIGNMENT ARRAY numBuffer[2]
	mov rax, 0
	mov byte [rbp-22], al; VAR_ASSIGNMENT else variable buffLength
	jmp .end_if8
.end_if8:
.end_if1:
.skip_label1:
	mov rax, qword [rbp-48]; LOOP i
	inc rax
	mov qword [rbp-48], rax; LOOP i
	jmp .label1
.not_label1:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	mov rax, 0
	mov qword [rbp-56], rax; LOOP i
.label5:
	movzx rax, byte [rbp-17]; printExpression variable gameCount
	cmp qword [rbp-56], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 16
	mov rax, qword [rbp-56]; printExpression variable i
	mov r12d, dword [s_game_copies+rax*4]; printExpression array s_game_copies
	mov rax, r12
	mov dword [rbp-60], eax; VAR_DECL_ASSIGN else variable copies
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov ebx, dword [rbp-60]; printExpression, right identifier, rbp variable copies
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
.skip_label5:
	mov rax, qword [rbp-56]; LOOP i
	inc rax
	mov qword [rbp-56], rax; LOOP i
	jmp .label5
.not_label5:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	add rsp, 181
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
	sub rsp, 29
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
	mov rsi, str2
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 29
	jmp .exit
	jmp .end_if12
.end_if12:
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 24102
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
	mov rsi, str3
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 29
	jmp .exit
	jmp .end_if13
.end_if13:
	mov rax, 206
	mov byte [rbp-13], al; VAR_DECL_ASSIGN else variable gameSize
	mov rax, 0
	mov qword [rbp-21], rax; LOOP i
.label6:
	movzx rax, byte [rbp-13]; printExpression variable gameSize
	cmp qword [rbp-21], rax; LOOP i
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	mov rax, qword [rbp-21]; printExpression variable i
	push rax
	mov rax, 1
	pop r11
	mov dword [s_game_copies+r11*4], eax; VAR_ASSIGNMENT ARRAY s_game_copies
.skip_label6:
	mov rax, qword [rbp-21]; LOOP i
	inc rax
	mov qword [rbp-21], rax; LOOP i
	jmp .label6
.not_label6:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1_and_2
	mov rax, 0
	mov rdi, rax
.exit:
	mov rax, 60
	syscall
