section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Sum of histories part 1: ",0
	str1: db "Sum of histories part 2: ",0
	str2: db "-",0
	str3: db "Could not open file",0xA,0
	str4: db "Could not read from file",0xA,0
	s_line_buffer_count db 0
section .bss
	s_buffer resb 21300
	s_line_buffer resq 21

section .text
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

global RecurseHistory
RecurseHistory:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 32
	movzx rax, byte sil; printExpression variable size
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable length
	mov rax, 1
	mov byte [rbp-2], al; VAR_DECL_ASSIGN else variable allZeroes
	mov rax, qword rdi; printExpression variable arr
	mov qword [rbp-10], rax; VAR_DECL_ASSIGN else variable buffer
	mov rax, 0
	mov qword [rbp-18], rax; LOOP i
.label1:
	movzx rax, byte [rbp-1]; printExpression variable length
	cmp qword [rbp-18], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	mov rax, qword [rbp-18]; printExpression variable i
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
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
	jnz .if1
	jmp .end_if1
.if1:
	mov rax, 0
	mov byte [rbp-2], al; VAR_ASSIGNMENT else variable allZeroes
	jmp .end_if1
.end_if1:
.skip_label1:
	mov rax, qword [rbp-18]; LOOP i
	inc rax
	mov qword [rbp-18], rax; LOOP i
	jmp .label1
.not_label1:
	movzx rax, byte [rbp-2]; printExpression variable allZeroes
	test rax, rax
	jnz .if2
	jmp .else_if2
.if2:
	mov rax, 0
	add rsp, 32
	jmp .exit
	jmp .end_if2
.else_if2:
	sub rsp, 32
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable length
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, 8; printExpression, left int
	mul word bx
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
	mov qword [rbp-26], rax; VAR_DECL_ASSIGN else variable next
	mov rax, 0
	mov qword [rbp-34], rax; LOOP i
.label2:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable length
	mov rbx, 1; printExpression, right int
	sub ax, bx
	cmp qword [rbp-34], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	mov rax, qword [rbp-34]; printExpression variable i
	lea r11, qword [rbp-26]
	mov r11, qword [r11]
	mov rbx, 8
	mul rbx
	add r11, rax
	push r11
	mov rax, qword [rbp-34]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-34]; printExpression variable i
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
	mov rbx, r11; printExpression, nodeType=1, ref index
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	pop r11
	mov qword [r11], rax; VAR_ASSIGNMENT REF next
.skip_label2:
	mov rax, qword [rbp-34]; LOOP i
	inc rax
	mov qword [rbp-34], rax; LOOP i
	jmp .label2
.not_label2:
	movzx rax, byte sil; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-26]; printExpression variable next
	mov rdi, rax
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable length
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rsi, rax
	call RecurseHistory
	mov rbx, rax; printExpression, nodeType=1, function call
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	add rsp, 64
	jmp .exit
	add rsp, 32
.end_if2:
	mov rax, 0
	add rsp, 32
	jmp .exit
	add rsp, 32
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global RecurseHistoryP2
RecurseHistoryP2:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 32
	movzx rax, byte sil; printExpression variable size
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable length
	mov rax, 1
	mov byte [rbp-2], al; VAR_DECL_ASSIGN else variable allZeroes
	mov rax, qword rdi; printExpression variable arr
	mov qword [rbp-10], rax; VAR_DECL_ASSIGN else variable buffer
	mov rax, 0
	mov qword [rbp-18], rax; LOOP i
.label3:
	movzx rax, byte [rbp-1]; printExpression variable length
	cmp qword [rbp-18], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	mov rax, qword [rbp-18]; printExpression variable i
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
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
	jnz .if3
	jmp .end_if3
.if3:
	mov rax, 0
	mov byte [rbp-2], al; VAR_ASSIGNMENT else variable allZeroes
	jmp .end_if3
.end_if3:
.skip_label3:
	mov rax, qword [rbp-18]; LOOP i
	inc rax
	mov qword [rbp-18], rax; LOOP i
	jmp .label3
.not_label3:
	movzx rax, byte [rbp-2]; printExpression variable allZeroes
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
	mov rax, 0
	add rsp, 32
	jmp .exit
	jmp .end_if4
.else_if4:
	sub rsp, 32
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable length
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, 8; printExpression, left int
	mul word bx
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
	mov qword [rbp-26], rax; VAR_DECL_ASSIGN else variable next
	mov rax, 0
	mov qword [rbp-34], rax; LOOP i
.label4:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable length
	mov rbx, 1; printExpression, right int
	sub ax, bx
	cmp qword [rbp-34], rax; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	mov rax, qword [rbp-34]; printExpression variable i
	lea r11, qword [rbp-26]
	mov r11, qword [r11]
	mov rbx, 8
	mul rbx
	add r11, rax
	push r11
	mov rax, qword [rbp-34]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-34]; printExpression variable i
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
	mov rbx, r11; printExpression, nodeType=1, ref index
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	pop r11
	mov qword [r11], rax; VAR_ASSIGNMENT REF next
.skip_label4:
	mov rax, qword [rbp-34]; LOOP i
	inc rax
	mov qword [rbp-34], rax; LOOP i
	jmp .label4
.not_label4:
	mov rax, 0
	mov rbx, 8
	mul rbx
	mov rbx, qword [rbp-10]
	add rax, rbx
	mov r11, qword [rax]; printExpression ref buffer
	mov rax, r11
	push rax; printExpression, leftPrinted, save left
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-26]; printExpression variable next
	mov rdi, rax
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable length
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov rsi, rax
	call RecurseHistoryP2
	mov rbx, rax; printExpression, nodeType=1, function call
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	add rsp, 64
	jmp .exit
	add rsp, 32
.end_if4:
	mov rax, 0
	add rsp, 32
	jmp .exit
	add rsp, 32
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
	sub rsp, 40
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label5:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_line_buffer]; printExpression variable s_line_buffer
	mov rdi, rax
	movzx rax, byte [s_line_buffer_count]; printExpression global variable s_line_buffer_count
	mov rsi, rax
	call RecurseHistory
	mov rbx, rax; printExpression, nodeType=1, function call
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	mov rax, 0
	mov byte [s_line_buffer_count], al; VAR_ASSIGNMENT else variable s_line_buffer_count
	jmp .end_if5
.else_if5:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
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
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 45; printExpression, right char '-'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or ax, bx
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	sub rsp, 16
	mov rax, 0
	mov qword [rbp-33], rax; VAR_DECL_ASSIGN else variable num
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 45; printExpression, right char '-'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-33], rax; VAR_ASSIGNMENT else variable num
	mov rax, qword [rbp-33]; printExpression -num
	neg rax
	mov qword [rbp-33], rax; VAR_ASSIGNMENT else variable num
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable i
	jmp .end_if7
.else_if7:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-33], rax; VAR_ASSIGNMENT else variable num
.end_if7:
	mov rax, 0
	mov byte [rbp-34], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-35], al; LOOP j
.label6:
	mov rax, 20
	cmp byte [rbp-35], al; LOOP j
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-35]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-36], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-36]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-36]; printExpression, left identifier, rbp variable numByte
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
	jnz .if8
	jmp .else_if8
.if8:
	movzx rax, byte [rbp-34]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-34], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if8
.else_if8:
	jmp .not_label6
.end_if8:
	add rsp, 8
.skip_label6:
	mov al, byte [rbp-35]; LOOP j
	inc rax
	mov byte [rbp-35], al; LOOP j
	jmp .label6
.not_label6:
	movzx rax, byte [rbp-34]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov byte [rbp-34], al; VAR_ASSIGNMENT else variable numLength
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-34]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable i
	movzx rax, byte [s_line_buffer_count]; printExpression global variable s_line_buffer_count
	cmp rax, 21; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-33]; printExpression variable num
	pop r11
	mov qword [s_line_buffer+r11*8], rax; VAR_ASSIGNMENT ARRAY s_line_buffer
	movzx rax, byte [s_line_buffer_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [s_line_buffer_count], al; VAR_ASSIGNMENT else variable s_line_buffer_count
	add rsp, 16
	jmp .end_if6
.end_if6:
.end_if5:
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label5
.not_label5:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
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
	sub rsp, 24
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label7:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label7
	jmp .not_label7
.inside_label7:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-25], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_line_buffer]; printExpression variable s_line_buffer
	mov rdi, rax
	movzx rax, byte [s_line_buffer_count]; printExpression global variable s_line_buffer_count
	mov rsi, rax
	call RecurseHistoryP2
	mov rbx, rax; printExpression, nodeType=1, function call
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	mov rax, 0
	mov byte [s_line_buffer_count], al; VAR_ASSIGNMENT else variable s_line_buffer_count
	jmp .end_if9
.else_if9:
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
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
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 45; printExpression, right char '-'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or ax, bx
	test rax, rax
	jnz .if10
	jmp .end_if10
.if10:
	sub rsp, 16
	mov rax, 0
	mov qword [rbp-33], rax; VAR_DECL_ASSIGN else variable num
	movzx rax, byte [rbp-25]; printExpression, left identifier, rbp variable byte
	mov rbx, 45; printExpression, right char '-'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-33], rax; VAR_ASSIGNMENT else variable num
	mov rax, qword [rbp-33]; printExpression -num
	neg rax
	mov qword [rbp-33], rax; VAR_ASSIGNMENT else variable num
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable i
	jmp .end_if11
.else_if11:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-33], rax; VAR_ASSIGNMENT else variable num
.end_if11:
	mov rax, 0
	mov byte [rbp-34], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-35], al; LOOP j
.label8:
	mov rax, 20
	cmp byte [rbp-35], al; LOOP j
	jl .inside_label8
	jmp .not_label8
.inside_label8:
	sub rsp, 8
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-35]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-36], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-36]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-36]; printExpression, left identifier, rbp variable numByte
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
	jnz .if12
	jmp .else_if12
.if12:
	movzx rax, byte [rbp-34]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-34], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if12
.else_if12:
	jmp .not_label8
.end_if12:
	add rsp, 8
.skip_label8:
	mov al, byte [rbp-35]; LOOP j
	inc rax
	mov byte [rbp-35], al; LOOP j
	jmp .label8
.not_label8:
	movzx rax, byte [rbp-34]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov byte [rbp-34], al; VAR_ASSIGNMENT else variable numLength
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-34]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable i
	movzx rax, byte [s_line_buffer_count]; printExpression global variable s_line_buffer_count
	cmp rax, 21; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-33]; printExpression variable num
	pop r11
	mov qword [s_line_buffer+r11*8], rax; VAR_ASSIGNMENT ARRAY s_line_buffer
	movzx rax, byte [s_line_buffer_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [s_line_buffer_count], al; VAR_ASSIGNMENT else variable s_line_buffer_count
	add rsp, 16
	jmp .end_if10
.end_if10:
.end_if9:
	add rsp, 8
.skip_label7:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label7
.not_label7:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	sub rsp, 40
	mov rax, qword [rbp-16]; printExpression -sum
	neg rax
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable converted
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 1
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-32]; variable converted
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 40
	jmp .end_if13
.else_if13:
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
.end_if13:
	mov rax, 0
	add rsp, 24
	jmp .exit
	add rsp, 24
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
	jnz .if14
	jmp .end_if14
.if14:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
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
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 21290
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
	jnz .if15
	jmp .end_if15
.if15:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if15
.end_if15:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
