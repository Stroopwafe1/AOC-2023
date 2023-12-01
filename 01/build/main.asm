section .data
	str0: db "Calibration sum part 1: ",0
	str1: db " + ",0
	str2: db " = ",0
	str3: db "Calibration sum part 2: ",0
	str4: db "Could not open file",0xA,0
	str5: db "Could not read from file",0xA,0
section .bss
	s_buffer resb 22050

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
	sub rsp, 27
	mov rax, 0
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else
	mov rax, 0
	mov byte [rbp-15], al
	mov rax, 0
	mov byte [rbp-14], al
	mov rax, 0
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else
	mov rax, 0
	mov qword [rbp-24], rax
.label1:
	mov rax, qword rdi
	cmp qword [rbp-24], rax
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 1
	mov rax, qword [rbp-24]
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
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
	sub rsp, 4
	mov rax, 0
	movzx r11, byte [rbp-15+rax*1]
	mov rax, r11
	mov rbx, 10; printExpression, right int
	mul word bx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r11, byte [rbp-15+rax*1]
	mov rbx, r11; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add al, bl
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp
	movzx rbx, byte [rbp-26]; printExpression, right identifier, rbp
	add rax, rbx
	mov qword [rbp-12], rax
	mov rax, 0
	mov byte [rbp-16], al
	mov rax, 0
	mov byte [rbp-15], al
	mov rax, 0
	mov byte [rbp-14], al
	add rsp, 4
	jmp .end_if1
.else_if1:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 48; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
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
	jnz .if2
	jmp .end_if2
.if2:
	movzx rax, byte [rbp-16]
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if2
.end_if2:
.end_if1:
	add rsp, 1
.skip_label1:
	mov rax, qword [rbp-24]
	inc rax
	mov qword [rbp-24], rax
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
	mov rsi, str0
	mov rdx, 24
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
	mov rdi, qword [rbp-12]
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
	add rsp, 27
	jmp .exit
	add rsp, 27
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
	sub rsp, 27
	mov rax, 0
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else
	mov rax, 0
	mov byte [rbp-15], al
	mov rax, 0
	mov byte [rbp-14], al
	mov rax, 0
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else
	mov rax, 0
	mov qword [rbp-24], rax
.label2:
	mov rax, qword rdi
	cmp qword [rbp-24], rax
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 1
	mov rax, qword [rbp-24]
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 10; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .else_if3
.if3:
	sub rsp, 4
	mov rax, 0
	movzx r11, byte [rbp-15+rax*1]
	mov rax, r11
	mov rbx, 10; printExpression, right int
	mul word bx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r11, byte [rbp-15+rax*1]
	mov rbx, r11; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add al, bl
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-12]
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
	movzx rdi, byte [rbp-26]
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
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp
	movzx rbx, byte [rbp-26]; printExpression, right identifier, rbp
	add rax, rbx
	mov qword [rbp-12], rax
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-12]
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
	mov byte [rbp-16], al
	mov rax, 0
	mov byte [rbp-15], al
	mov rax, 0
	mov byte [rbp-14], al
	add rsp, 4
	jmp .end_if3
.else_if3:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 48; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
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
	movzx rax, byte [rbp-16]
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if4
.else_if4:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 111; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 110; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 1
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 1
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if5
.else_if5:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 105; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 103; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 3; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 104; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 4; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 116; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if6
	jmp .else_if6
.if6:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 8
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 8
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if6
.else_if6:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 110; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 105; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 110; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 3; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 9
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 9
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if7
.else_if7:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 116; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 104; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 114; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 3; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 4; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if8
	jmp .else_if8
.if8:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 3
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 3
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if8
.else_if8:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 116; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 119; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 111; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 2
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 2
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if9
.else_if9:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 102; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 111; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 117; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 3; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 114; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 4
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 4
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if10
.else_if10:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 102; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 105; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 118; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 3; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 5
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 5
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if11
.else_if11:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 115; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 105; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 120; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if12
	jmp .else_if12
.if12:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 6
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 6
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if12
.else_if12:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp
	mov rbx, 115; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 2; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 118; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 3; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 101; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp
	mov rbx, 4; printExpression, right int
	add rax, rbx
	movzx r11, byte [s_buffer+rax*1]
	mov rax, r11
	mov rbx, 110; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and al, bl
	test rax, rax
	jnz .if13
	jmp .end_if13
.if13:
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 7
	pop r11
	mov byte [rbp-15+r11*1], al
	mov rax, 1
	mov byte [rbp-16], al
	movzx rax, byte [rbp-16]
	push rax
	mov rax, 7
	pop r11
	mov byte [rbp-15+r11*1], al
	jmp .end_if13
.end_if13:
.end_if12:
.end_if11:
.end_if10:
.end_if9:
.end_if8:
.end_if7:
.end_if6:
.end_if5:
.end_if4:
.end_if3:
	add rsp, 1
.skip_label2:
	mov rax, qword [rbp-24]
	inc rax
	mov qword [rbp-24], rax
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
	mov rsi, str3
	mov rdx, 24
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
	mov rdi, qword [rbp-12]
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
	add rsp, 27
	jmp .exit
	add rsp, 27
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
	mov r11, qword [rbp+16+rax*8]
	mov rax, r11
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
	mov dword [rbp-4], eax; VAR_DECL_ASSIGN else
	movsxd rax, dword [rbp-4]; printExpression, left identifier, rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovl rcx, rdx
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
	mov rsi, str4
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
	jmp .end_if14
.end_if14:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 0
	mov eax, dword [rbp-4]
	mov rdi, rax
	mov rax, s_buffer
	mov rsi, rax
	mov rax, 22039
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
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
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
	mov rsi, str5
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
	jmp .end_if15
.end_if15:
	mov rax, qword [rbp-12]
	mov rdi, rax
	call Part1
	mov rax, qword [rbp-12]
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 12
.exit:
	mov rax, 60
	syscall
