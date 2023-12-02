section .data
	str0: db "Game: ",0
	str1: db " possible! Sum is now ",0
	str2: db "Game: ",0
	str3: db " impossible! Sum is still ",0
	str4: db "Game ",0
	str5: db " set ",0
	str6: db " red = ",0
	str7: db "Game ",0
	str8: db " set ",0
	str9: db " green = ",0
	str10: db "Game ",0
	str11: db " set ",0
	str12: db " blue = ",0
	str13: db "Possible games sum part 1: ",0
	str14: db "Could not open file",0xA,0
	str15: db "Could not read from file",0xA,0
section .bss
	s_buffer resb 10300

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
	sub rsp, 43
	mov rax, 0
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov byte [rbp-16], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[0]
	mov rax, 0
	mov byte [rbp-15], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[1]
	mov rax, 0
	mov byte [rbp-14], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[2]
	mov rax, 0
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable buffLength
	mov rax, 0
	mov byte [rbp-18], al; VAR_DECL_ASSIGN else variable currentGame
	mov rax, 0
	mov dword [rbp-31], eax; VAR_DECL_ASSIGN STRUCT Set currentSet.red
	mov rax, 0
	mov dword [rbp-27], eax; VAR_DECL_ASSIGN STRUCT Set currentSet.green
	mov rax, 0
	mov dword [rbp-23], eax; VAR_DECL_ASSIGN STRUCT Set currentSet.blue
	mov rax, 0
	mov byte [rbp-32], al; VAR_DECL_ASSIGN else variable setCount
	mov rax, 1
	mov byte [rbp-33], al; VAR_DECL_ASSIGN else variable possible
	mov rax, 0
	mov qword [rbp-41], rax; LOOP i
.label1:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-41], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 7
	mov rax, qword [rbp-41]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-42], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	mov eax, dword [rbp-31]; printExpression struct Set.red
	push rax; printExpression, leftPrinted, save left
	mov rbx, 12; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov eax, dword [rbp-27]; printExpression struct Set.green
	push rax; printExpression, leftPrinted, save left
	mov rbx, 13; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or eax, ebx
	push rax; printExpression, leftPrinted, save left
	mov eax, dword [rbp-23]; printExpression struct Set.blue
	push rax; printExpression, leftPrinted, save left
	mov rbx, 14; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or eax, ebx
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	mov rax, 0
	mov byte [rbp-33], al; VAR_ASSIGNMENT else variable possible
	jmp .end_if2
.end_if2:
	movzx rax, byte [rbp-33]; printExpression variable possible
	test rax, rax
	jnz .if3
	jmp .else_if3
.if3:
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
	mov rdx, 6
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
	movzx rdi, byte [rbp-18]; variable currentGame
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
	mov rsi, str1
	mov rdx, 22
	syscall
; =============== END FUNC CALL + STRING ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp variable sum
	movzx rbx, byte [rbp-18]; printExpression, right identifier, rbp variable currentGame
	add rax, rbx
	mov qword [rbp-12], rax; VAR_ASSIGNMENT else variable sum
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-12]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	jmp .end_if3
.else_if3:
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
	mov rdx, 6
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
	movzx rdi, byte [rbp-18]; variable currentGame
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
	mov rdx, 26
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
	mov rdi, qword [rbp-12]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
.end_if3:
	mov rax, 0
	mov byte [rbp-18], al; VAR_ASSIGNMENT else variable currentGame
	mov rax, 0
	mov byte [rbp-32], al; VAR_ASSIGNMENT else variable setCount
	mov rax, 0
	mov dword [rbp-31], eax; VAR_ASSIGNMENT STRUCT Set.red
	mov rax, 0
	mov dword [rbp-27], eax; VAR_ASSIGNMENT STRUCT Set.green
	mov rax, 0
	mov dword [rbp-23], eax; VAR_ASSIGNMENT STRUCT Set.blue
	mov rax, 1
	mov byte [rbp-33], al; VAR_ASSIGNMENT else variable possible
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	add rax, rbx
	mov qword [rbp-41], rax; VAR_ASSIGNMENT else variable i
	jmp .end_if1
.else_if1:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
	sub rsp, 1
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	sub ax, bx
	mov byte [rbp-43], al; VAR_DECL_ASSIGN else variable number
	movzx rax, byte [rbp-17]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
	mov rax, 2
	push rax
	movzx rax, byte [rbp-43]; printExpression variable number
	pop r11
	mov byte [rbp-16+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if5
.else_if5:
	movzx rax, byte [rbp-17]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .else_if6
.if6:
	mov rax, 1
	push rax
	mov rax, 2
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-16+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 2
	push rax
	movzx rax, byte [rbp-43]; printExpression variable number
	pop r11
	mov byte [rbp-16+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if6
.else_if6:
	mov rax, 0
	push rax
	mov rax, 1
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-16+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	push rax
	mov rax, 2
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rax, r12
	pop r11
	mov byte [rbp-16+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 2
	push rax
	movzx rax, byte [rbp-43]; printExpression variable number
	pop r11
	mov byte [rbp-16+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
.end_if6:
.end_if5:
	movzx rax, byte [rbp-17]; printExpression, left identifier, rbp variable buffLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable buffLength
	add rsp, 1
	jmp .end_if4
.else_if4:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 32; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 48; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 57; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	mov rax, 0
	mov byte [rbp-16], al; VAR_ASSIGNMENT ARRAY numBuffer[0]
	mov rax, 0
	mov byte [rbp-15], al; VAR_ASSIGNMENT ARRAY numBuffer[1]
	mov rax, 0
	mov byte [rbp-14], al; VAR_ASSIGNMENT ARRAY numBuffer[2]
	mov rax, 0
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable buffLength
	jmp .end_if8
.end_if8:
	jmp .end_if7
.else_if7:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 58; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	mov rax, 0
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 100; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
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
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov byte [rbp-18], al; VAR_ASSIGNMENT else variable currentGame
	jmp .end_if9
.else_if9:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 59; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	mov eax, dword [rbp-31]; printExpression struct Set.red
	push rax; printExpression, leftPrinted, save left
	mov rbx, 12; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov eax, dword [rbp-27]; printExpression struct Set.green
	push rax; printExpression, leftPrinted, save left
	mov rbx, 13; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or eax, ebx
	push rax; printExpression, leftPrinted, save left
	mov eax, dword [rbp-23]; printExpression struct Set.blue
	push rax; printExpression, leftPrinted, save left
	mov rbx, 14; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or eax, ebx
	test rax, rax
	jnz .if11
	jmp .end_if11
.if11:
	mov rax, 0
	mov byte [rbp-33], al; VAR_ASSIGNMENT else variable possible
	jmp .end_if11
.end_if11:
	mov rax, 0
	mov dword [rbp-31], eax; VAR_ASSIGNMENT STRUCT Set.red
	mov rax, 0
	mov dword [rbp-27], eax; VAR_ASSIGNMENT STRUCT Set.green
	mov rax, 0
	mov dword [rbp-23], eax; VAR_ASSIGNMENT STRUCT Set.blue
	movzx rax, byte [rbp-32]; printExpression, left identifier, rbp variable setCount
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-32], al; VAR_ASSIGNMENT else variable setCount
	jmp .end_if10
.else_if10:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 114; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .else_if12
.if12:
	sub rsp, 8
	mov rax, 0
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 100; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
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
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov word [rbp-44], ax; VAR_DECL_ASSIGN else variable number
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
	mov rdx, 5
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
	movzx rdi, byte [rbp-18]; variable currentGame
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
	mov rdx, 5
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
	movzx rdi, byte [rbp-32]; variable setCount
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
	movzx rdi, word [rbp-44]; variable number
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	movzx rax, word [rbp-44]; printExpression variable number
	mov dword [rbp-31], eax; VAR_ASSIGNMENT STRUCT currentSet.red
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 2; printExpression, right int
	add rax, rbx
	mov qword [rbp-41], rax; VAR_ASSIGNMENT else variable i
	add rsp, 8
	jmp .end_if12
.else_if12:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 103; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	sub rsp, 8
	mov rax, 0
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 100; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
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
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov word [rbp-44], ax; VAR_DECL_ASSIGN else variable number
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
	mov rdx, 5
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
	movzx rdi, byte [rbp-18]; variable currentGame
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
	mov rdx, 5
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
	movzx rdi, byte [rbp-32]; variable setCount
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
	movzx rdi, word [rbp-44]; variable number
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	movzx rax, word [rbp-44]; printExpression variable number
	mov dword [rbp-27], eax; VAR_ASSIGNMENT STRUCT currentSet.green
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 4; printExpression, right int
	add rax, rbx
	mov qword [rbp-41], rax; VAR_ASSIGNMENT else variable i
	add rsp, 8
	jmp .end_if13
.else_if13:
	movzx rax, byte [rbp-42]; printExpression, left identifier, rbp variable byte
	mov rbx, 98; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	sub rsp, 8
	mov rax, 0
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 100; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
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
	movzx r12, byte [rbp-16+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov word [rbp-44], ax; VAR_DECL_ASSIGN else variable number
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
	mov rdx, 5
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
	movzx rdi, byte [rbp-18]; variable currentGame
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
	mov rdx, 5
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
	movzx rdi, byte [rbp-32]; variable setCount
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
	mov rsi, str12
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
	movzx rdi, word [rbp-44]; variable number
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	movzx rax, word [rbp-44]; printExpression variable number
	mov dword [rbp-23], eax; VAR_ASSIGNMENT STRUCT currentSet.blue
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	add rax, rbx
	mov qword [rbp-41], rax; VAR_ASSIGNMENT else variable i
	add rsp, 8
	jmp .end_if14
.end_if14:
.end_if13:
.end_if12:
.end_if10:
.end_if9:
.end_if7:
.end_if4:
.end_if1:
	add rsp, 7
.skip_label1:
	mov rax, qword [rbp-41]; LOOP i
	inc rax
	mov qword [rbp-41], rax; LOOP i
	jmp .label1
.not_label1:
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
	mov rsi, str13
	mov rdx, 27
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
	mov rdi, qword [rbp-12]; variable sum
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
	add rsp, 43
	jmp .exit
	add rsp, 43
.exit:
; =============== EPILOGUE ===============
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
	jnz .if15
	jmp .end_if15
.if15:
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
	mov rsi, str14
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
	jmp .end_if15
.end_if15:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	mov rax, s_buffer
	mov rsi, rax
	mov rax, 10290
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
	jnz .if16
	jmp .end_if16
.if16:
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
	mov rsi, str15
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
	jmp .end_if16
.end_if16:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	mov rax, 0
	mov rdi, rax
	add rsp, 12
.exit:
	mov rax, 60
	syscall
