section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Sum of lengths part ",0
	str1: db ": ",0
	str2: db "Could not open file",0xA,0
	str3: db "Could not read from file",0xA,0
	s_empty_lines_count db 0
	s_galaxy_count dw 0
section .bss
	s_buffer resb 19750
	s_empty_lines resw 100
	s_x_coords resq 500
	s_y_coords resq 500

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

global AddGalaxy
AddGalaxy:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 64
	mov rax, qword rdx; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable toChange
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable toChangeX
	mov rax, 0
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable toChangeY
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov rax, rdx
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable x
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable y
	mov rax, 0
	mov qword [rbp-48], rax; LOOP i
.label1:
	movzx rax, byte [s_empty_lines_count]; printExpression global variable s_empty_lines_count
	cmp qword [rbp-48], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 8
	movzx rax, byte [s_empty_lines_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub ax, bx
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	movzx r12, word [s_empty_lines+rax*2]; printExpression array s_empty_lines
	mov rax, r12
	mov word [rbp-50], ax; VAR_DECL_ASSIGN else variable emptyLine
	movzx rax, word [rbp-50]; printExpression, left identifier, rbp variable emptyLine
	mov rbx, 1000; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	movzx rax, word [rbp-50]; printExpression, left identifier, rbp variable emptyLine
	mov rbx, 1000; printExpression, right int
	sub eax, ebx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable x
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable toChangeX
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable toChange
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable toChangeX
	jmp .end_if2
.end_if2:
	jmp .end_if1
.else_if1:
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable y
	movzx rbx, word [rbp-50]; printExpression, right identifier, rbp variable emptyLine
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .end_if3
.if3:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable toChangeY
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable toChange
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable toChangeY
	jmp .end_if3
.end_if3:
.end_if1:
	add rsp, 8
.skip_label1:
	mov rax, qword [rbp-48]; LOOP i
	inc rax
	mov qword [rbp-48], rax; LOOP i
	jmp .label1
.not_label1:
	movzx rax, word [s_galaxy_count]; printExpression global variable s_galaxy_count
	cmp rax, 500; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable x
	mov rbx, qword [rbp-16]; printExpression, right identifier, rbp variable toChangeX
	add rax, rbx
	pop r11
	mov qword [s_x_coords+r11*8], rax; VAR_ASSIGNMENT ARRAY s_x_coords
	movzx rax, word [s_galaxy_count]; printExpression global variable s_galaxy_count
	cmp rax, 500; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable y
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable toChangeY
	add rax, rbx
	pop r11
	mov qword [s_y_coords+r11*8], rax; VAR_ASSIGNMENT ARRAY s_y_coords
	movzx rax, word [s_galaxy_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_galaxy_count], ax; VAR_ASSIGNMENT else variable s_galaxy_count
	add rsp, 64
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Prepare
Prepare:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 48
	mov rax, 0
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable lineLength
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label2:
	mov rax, qword [rbp-16]; printExpression variable length
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	mov rax, qword [rbp-24]; printExpression variable i
	cmp rax, 19750; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 10; printExpression, right char '\n'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .end_if4
.if4:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable lineLength
	jmp .not_label2
	jmp .end_if4
.end_if4:
.skip_label2:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label2
.not_label2:
	mov rax, 0
	mov qword [rbp-32], rax; LOOP i
.label3:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable lineLength
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	cmp qword [rbp-32], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 8
	mov rax, 1
	mov byte [rbp-33], al; VAR_DECL_ASSIGN else variable empty
	mov rax, 0
	mov qword [rbp-41], rax; LOOP j
.label4:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable length
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable lineLength
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	cmp qword [rbp-41], rax; LOOP j
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable j
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable lineLength
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable i
	add rax, rbx
	cmp rax, 19750; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 35; printExpression, right char '#'
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
	mov rax, 0
	mov byte [rbp-33], al; VAR_ASSIGNMENT else variable empty
	jmp .not_label4
	jmp .end_if5
.end_if5:
.skip_label4:
	mov rax, qword [rbp-41]; LOOP j
	inc rax
	mov qword [rbp-41], rax; LOOP j
	jmp .label4
.not_label4:
	movzx rax, byte [rbp-33]; printExpression variable empty
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	movzx rax, byte [s_empty_lines_count]; printExpression global variable s_empty_lines_count
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable i
	mov rbx, 1000; printExpression, right int
	add rax, rbx
	pop r11
	mov word [s_empty_lines+r11*2], ax; VAR_ASSIGNMENT ARRAY s_empty_lines
	movzx rax, byte [s_empty_lines_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [s_empty_lines_count], al; VAR_ASSIGNMENT else variable s_empty_lines_count
	jmp .end_if6
.end_if6:
	add rsp, 8
.skip_label3:
	mov rax, qword [rbp-32]; LOOP i
	inc rax
	mov qword [rbp-32], rax; LOOP i
	jmp .label3
.not_label3:
	mov rax, 0
	mov qword [rbp-40], rax; LOOP i
.label5:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable length
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable lineLength
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	cmp qword [rbp-40], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	mov rax, 1
	mov byte [rbp-41], al; VAR_DECL_ASSIGN else variable empty
	mov rax, 0
	mov qword [rbp-49], rax; LOOP j
.label6:
	mov rax, qword [rbp-8]; printExpression variable lineLength
	cmp qword [rbp-49], rax; LOOP j
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable i
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable lineLength
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-49]; printExpression, left identifier, rbp variable j
	add rax, rbx
	cmp rax, 19750; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 35; printExpression, right char '#'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .end_if7
.if7:
	mov rax, 0
	mov byte [rbp-41], al; VAR_ASSIGNMENT else variable empty
	jmp .not_label6
	jmp .end_if7
.end_if7:
.skip_label6:
	mov rax, qword [rbp-49]; LOOP j
	inc rax
	mov qword [rbp-49], rax; LOOP j
	jmp .label6
.not_label6:
	movzx rax, byte [rbp-41]; printExpression variable empty
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	movzx rax, byte [s_empty_lines_count]; printExpression global variable s_empty_lines_count
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-40]; printExpression variable i
	pop r11
	mov word [s_empty_lines+r11*2], ax; VAR_ASSIGNMENT ARRAY s_empty_lines
	movzx rax, byte [s_empty_lines_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [s_empty_lines_count], al; VAR_ASSIGNMENT else variable s_empty_lines_count
	jmp .end_if8
.end_if8:
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-40]; LOOP i
	inc rax
	mov qword [rbp-40], rax; LOOP i
	jmp .label5
.not_label5:
	mov rax, qword [rbp-8]; printExpression variable lineLength
	add rsp, 48
	jmp .exit
	add rsp, 48
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Solve
Solve:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 48
	mov rax, 0
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable sum
	movzx rax, word dx; printExpression variable p
	mov word [rbp-10], ax; VAR_DECL_ASSIGN else variable part
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-18], rax; VAR_DECL_ASSIGN else variable length
	mov rax, qword rsi; printExpression variable lineLength
	mov qword [rbp-26], rax; VAR_DECL_ASSIGN else variable lineLen
	mov rax, 0
	mov qword [rbp-34], rax; LOOP i
.label7:
	mov rax, qword [rbp-18]; printExpression variable length
	cmp qword [rbp-34], rax; LOOP i
	jl .inside_label7
	jmp .not_label7
.inside_label7:
	sub rsp, 8
	mov rax, qword [rbp-34]; printExpression variable i
	cmp rax, 19750; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-35], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-35]; printExpression, left identifier, rbp variable byte
	mov rbx, 35; printExpression, right char '#'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .end_if9
.if9:
	movzx rax, word [rbp-10]; printExpression, left identifier, rbp variable part
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	mov rax, 2
	mov rdx, rax
	mov rax, qword [rbp-26]; printExpression variable lineLen
	mov rsi, rax
	mov rax, qword [rbp-34]; printExpression variable i
	mov rdi, rax
	call AddGalaxy
	jmp .end_if10
.else_if10:
	mov rax, 1000000
	mov rdx, rax
	mov rax, qword [rbp-26]; printExpression variable lineLen
	mov rsi, rax
	mov rax, qword [rbp-34]; printExpression variable i
	mov rdi, rax
	call AddGalaxy
.end_if10:
	jmp .end_if9
.end_if9:
	add rsp, 8
.skip_label7:
	mov rax, qword [rbp-34]; LOOP i
	inc rax
	mov qword [rbp-34], rax; LOOP i
	jmp .label7
.not_label7:
	mov rax, 0
	mov qword [rbp-42], rax; LOOP i
.label8:
	movzx rax, word [s_galaxy_count]; printExpression global variable s_galaxy_count
	cmp qword [rbp-42], rax; LOOP i
	jl .inside_label8
	jmp .not_label8
.inside_label8:
	sub rsp, 40
	mov rax, qword [rbp-42]; printExpression variable i
	cmp rax, 500; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_x_coords+rax*8]; printExpression array s_x_coords
	mov rax, r12
	mov qword [rbp-50], rax; VAR_DECL_ASSIGN else variable x
	mov rax, qword [rbp-42]; printExpression variable i
	cmp rax, 500; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_y_coords+rax*8]; printExpression array s_y_coords
	mov rax, r12
	mov qword [rbp-58], rax; VAR_DECL_ASSIGN else variable y
	mov rax, qword [rbp-42]; printExpression variable i
	mov qword [rbp-66], rax; LOOP j
.label9:
	movzx rax, word [s_galaxy_count]; printExpression global variable s_galaxy_count
	cmp qword [rbp-66], rax; LOOP j
	jl .inside_label9
	jmp .not_label9
.inside_label9:
	sub rsp, 40
	mov rax, qword [rbp-66]; printExpression variable j
	cmp rax, 500; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_x_coords+rax*8]; printExpression array s_x_coords
	mov rax, r12
	mov qword [rbp-74], rax; VAR_DECL_ASSIGN else variable jx
	mov rax, qword [rbp-66]; printExpression variable j
	cmp rax, 500; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_y_coords+rax*8]; printExpression array s_y_coords
	mov rax, r12
	mov qword [rbp-82], rax; VAR_DECL_ASSIGN else variable jy
	mov rax, 0
	mov qword [rbp-90], rax; VAR_DECL_ASSIGN else variable dx
	mov rax, 0
	mov qword [rbp-98], rax; VAR_DECL_ASSIGN else variable dy
	mov rax, qword [rbp-74]; printExpression, left identifier, rbp variable jx
	mov rbx, qword [rbp-50]; printExpression, right identifier, rbp variable x
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	mov rax, qword [rbp-74]; printExpression, left identifier, rbp variable jx
	mov rbx, qword [rbp-50]; printExpression, right identifier, rbp variable x
	sub rax, rbx
	mov qword [rbp-90], rax; VAR_ASSIGNMENT else variable dx
	jmp .end_if11
.else_if11:
	mov rax, qword [rbp-50]; printExpression, left identifier, rbp variable x
	mov rbx, qword [rbp-74]; printExpression, right identifier, rbp variable jx
	sub rax, rbx
	mov qword [rbp-90], rax; VAR_ASSIGNMENT else variable dx
.end_if11:
	mov rax, qword [rbp-82]; printExpression, left identifier, rbp variable jy
	mov rbx, qword [rbp-58]; printExpression, right identifier, rbp variable y
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .else_if12
.if12:
	mov rax, qword [rbp-82]; printExpression, left identifier, rbp variable jy
	mov rbx, qword [rbp-58]; printExpression, right identifier, rbp variable y
	sub rax, rbx
	mov qword [rbp-98], rax; VAR_ASSIGNMENT else variable dy
	jmp .end_if12
.else_if12:
	mov rax, qword [rbp-58]; printExpression, left identifier, rbp variable y
	mov rbx, qword [rbp-82]; printExpression, right identifier, rbp variable jy
	sub rax, rbx
	mov qword [rbp-98], rax; VAR_ASSIGNMENT else variable dy
.end_if12:
	mov rax, qword [rbp-90]; printExpression, left identifier, rbp variable dx
	mov rbx, qword [rbp-98]; printExpression, right identifier, rbp variable dy
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable sum
	add rsp, 40
.skip_label9:
	mov rax, qword [rbp-66]; LOOP j
	inc rax
	mov qword [rbp-66], rax; LOOP j
	jmp .label9
.not_label9:
	add rsp, 40
.skip_label8:
	mov rax, qword [rbp-42]; LOOP i
	inc rax
	mov qword [rbp-42], rax; LOOP i
	jmp .label8
.not_label8:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	movzx rdi, word [rbp-10]; variable part
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 2
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-8]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	add rsp, 48
	jmp .exit
	add rsp, 48
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
	jnz .if13
	jmp .end_if13
.if13:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 48
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
	mov rax, 19750
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
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 48
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
	call Prepare
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-20], rax; VAR_DECL_ASSIGN else variable lineLen
	mov rax, 1
	mov rdx, rax
	mov rax, qword [rbp-20]; printExpression variable lineLen
	mov rsi, rax
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Solve
	mov rax, 0
	mov word [s_galaxy_count], ax; VAR_ASSIGNMENT else variable s_galaxy_count
	mov rax, 2
	mov rdx, rax
	mov rax, qword [rbp-20]; printExpression variable lineLen
	mov rsi, rax
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Solve
	mov rax, 0
	mov rdi, rax
	add rsp, 48
.exit:
	mov rax, 60
	syscall
