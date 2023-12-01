section .data
	str0: db "Calibration sum part 1: ",0
	str1: db " + ",0
	str2: db " = ",0
	str3: db "one",0
	str4: db "eight",0
	str5: db "nine",0
	str6: db "three",0
	str7: db "two",0
	str8: db "four",0
	str9: db "five",0
	str10: db "six",0
	str11: db "seven",0
	str12: db "Calibration sum part 2: ",0
	str13: db "Could not open file",0xA,0
	str14: db "Could not read from file",0xA,0
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

global GetNextNBytes
GetNextNBytes:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 32
	mov rax, qword rsi; printExpression variable n
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable N
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-12]; printExpression variable N
	mov rdi, rax
	mov rax, 9
	mov rsi, rdi
	xor rdi, rdi
	mov rdx, 3
	mov r10, 34
	xor r8, r8
	xor r9, r9
	syscall
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-20], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-28], rax; LOOP i
.label1:
	mov rax, qword [rbp-12]; printExpression variable N
	cmp qword [rbp-28], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	mov rax, qword [rbp-28]; printExpression variable i
	lea r11, byte [rbp-20]
	mov r11, qword [r11]
	mov rbx, 1
	mul rbx
	add r11, rax
	mov rax, rdi; printExpression, left identifier, not rbp
	mov rbx, qword [rbp-28]; printExpression, right identifier, rbp variable i
	add rax, rbx
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [r11], al; VAR_ASSIGNMENT REF returnValue
.skip_label1:
	mov rax, qword [rbp-28]; LOOP i
	inc rax
	mov qword [rbp-28], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, qword [rbp-20]; printExpression variable returnValue
	add rsp, 32
	jmp .exit
	add rsp, 32
.exit:
; =============== EPILOGUE ===============
	pop rbp
	ret
; =============== END EPILOGUE ===============

global StrEquals
StrEquals:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov rax, qword rdx; printExpression variable len
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-20], rax; LOOP i
.label2:
	mov rax, qword [rbp-12]; printExpression variable length
	cmp qword [rbp-20], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	mov rax, qword [rbp-20]; printExpression variable i
	mov rbx, 1
	mul rbx
	mov rbx, qword rdi
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref s1
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-20]; printExpression variable i
	mov rbx, 1
	mul rbx
	mov rbx, qword rsi
	add rax, rbx
	movzx r11, byte [rax]; printExpression ref s2
	mov rbx, r11; printExpression, nodeType=1, ref index
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .end_if1
.if1:
	mov rax, 0
	add rsp, 24
	jmp .exit
	jmp .end_if1
.end_if1:
.skip_label2:
	mov rax, qword [rbp-20]; LOOP i
	inc rax
	mov qword [rbp-20], rax; LOOP i
	jmp .label2
.not_label2:
	mov rax, 1
	add rsp, 24
	jmp .exit
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Part1
Part1:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 27
	mov rax, 0
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov byte [rbp-15], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[0]
	mov rax, 0
	mov byte [rbp-14], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[1]
	mov rax, 0
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else variable buffLength
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label3:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 1
	mov rax, qword [rbp-24]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .else_if2
.if2:
	sub rsp, 4
	mov rax, 0
	movzx r12, byte [rbp-15+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 10; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-15+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable tempSum
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp variable sum
	movzx rbx, byte [rbp-26]; printExpression, right identifier, rbp variable tempSum
	add rax, rbx
	mov qword [rbp-12], rax; VAR_ASSIGNMENT else variable sum
	mov rax, 0
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	mov rax, 0
	mov byte [rbp-15], al; VAR_ASSIGNMENT ARRAY numBuffer[0]
	mov rax, 0
	mov byte [rbp-14], al; VAR_ASSIGNMENT ARRAY numBuffer[1]
	add rsp, 4
	jmp .end_if2
.else_if2:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
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
	jnz .if3
	jmp .end_if3
.if3:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if3
.end_if3:
.end_if2:
	add rsp, 1
.skip_label3:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
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
	mov qword [rbp-12], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov byte [rbp-15], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[0]
	mov rax, 0
	mov byte [rbp-14], al; VAR_DECL_ASSIGN ARRAY variable numBuffer[1]
	mov rax, 0
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else variable buffLength
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label4:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 9
	mov rax, qword [rbp-24]; printExpression variable i
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-24]; printExpression variable i
	mov rdi, rax
	mov rax, 5
	mov rsi, rax
	call GetNextNBytes
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-33], rax; VAR_DECL_ASSIGN else variable nextBytes
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
	sub rsp, 4
	mov rax, 0
	movzx r12, byte [rbp-15+rax*1]; printExpression array numBuffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 10; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rax, 1
	movzx r12, byte [rbp-15+rax*1]; printExpression array numBuffer
	mov rbx, r12; printExpression, nodeType=1, array index
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov byte [rbp-34], al; VAR_DECL_ASSIGN else variable tempSum
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-12]; variable sum
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
	movzx rdi, byte [rbp-34]; variable tempSum
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
	mov rax, qword [rbp-12]; printExpression, left identifier, rbp variable sum
	movzx rbx, byte [rbp-34]; printExpression, right identifier, rbp variable tempSum
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
	mov rax, 0
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	mov rax, 0
	mov byte [rbp-15], al; VAR_ASSIGNMENT ARRAY numBuffer[0]
	mov rax, 0
	mov byte [rbp-14], al; VAR_ASSIGNMENT ARRAY numBuffer[1]
	add rsp, 4
	jmp .end_if4
.else_if4:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
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
	jnz .if5
	jmp .else_if5
.if5:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right int
	sub ax, bx
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if5
.else_if5:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str3
	mov rax, 3
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if6
	jmp .else_if6
.if6:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 1
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 1
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if6
.else_if6:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str4
	mov rax, 5
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 8
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 8
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if7
.else_if7:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str5
	mov rax, 4
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if8
	jmp .else_if8
.if8:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 9
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 9
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if8
.else_if8:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str6
	mov rax, 5
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 3
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 3
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if9
.else_if9:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str7
	mov rax, 3
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 2
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 2
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if10
.else_if10:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str8
	mov rax, 4
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 4
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 4
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if11
.else_if11:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str9
	mov rax, 4
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if12
	jmp .else_if12
.if12:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 5
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 5
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if12
.else_if12:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str10
	mov rax, 3
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 6
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 6
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if13
.else_if13:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rsi, str11
	mov rax, 5
	mov rdx, rax
	call StrEquals
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if14
	jmp .end_if14
.if14:
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 7
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable buffLength
	movzx rax, byte [rbp-16]; printExpression variable buffLength
	push rax
	mov rax, 7
	pop r11
	mov byte [rbp-15+r11*1], al; VAR_ASSIGNMENT ARRAY numBuffer
	jmp .end_if14
.end_if14:
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
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, 5
	mov rsi, rax
	mov rax, qword [rbp-33]; printExpression variable nextBytes
	mov rdi, rax
	mov rax, 11
	syscall
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	add rsp, 9
.skip_label4:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label4
.not_label4:
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
	mov rsi, str13
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
	mov rsi, str14
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
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 12
.exit:
	mov rax, 60
	syscall
