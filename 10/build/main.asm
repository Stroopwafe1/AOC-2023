section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Line length: ",0
	str1: db "Furthest point part 1: ",0
	str2: db "Could not open file",0xA,0
	str3: db "Could not read from file",0xA,0
	s_direction dw 0
section .bss
	s_buffer resb 21300

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

global GetNext
GetNext:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 124; printExpression, right char '|'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .else_if2
.if2:
	mov rax, 0
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	sub rax, rbx
	jmp .exit
	jmp .end_if2
.else_if2:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 55; printExpression, right char '7'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .else_if3
.if3:
	mov rax, 1
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	jmp .exit
	jmp .end_if3
.else_if3:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 70; printExpression, right char 'F'
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
	mov rax, 2
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	jmp .exit
	jmp .end_if4
.end_if4:
.end_if3:
.end_if2:
	jmp .end_if1
.else_if1:
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 45; printExpression, right char '-'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .else_if6
.if6:
	mov rax, 1
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	jmp .exit
	jmp .end_if6
.else_if6:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 76; printExpression, right char 'L'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	mov rax, 0
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	sub rax, rbx
	jmp .exit
	jmp .end_if7
.else_if7:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 70; printExpression, right char 'F'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	mov rax, 3
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	add rax, rbx
	jmp .exit
	jmp .end_if8
.end_if8:
.end_if7:
.end_if6:
	jmp .end_if5
.else_if5:
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 45; printExpression, right char '-'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	mov rax, 2
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	jmp .exit
	jmp .end_if10
.else_if10:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 74; printExpression, right char 'J'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	mov rax, 0
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	sub rax, rbx
	jmp .exit
	jmp .end_if11
.else_if11:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 55; printExpression, right char '7'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .end_if12
.if12:
	mov rax, 3
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	add rax, rbx
	jmp .exit
	jmp .end_if12
.end_if12:
.end_if11:
.end_if10:
	jmp .end_if9
.else_if9:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 124; printExpression, right char '|'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	mov rax, 3
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	add rax, rbx
	jmp .exit
	jmp .end_if13
.else_if13:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 76; printExpression, right char 'L'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if14
	jmp .else_if14
.if14:
	mov rax, 2
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add rax, rbx
	jmp .exit
	jmp .end_if14
.else_if14:
	mov rax, qword rdi; printExpression variable source
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 74; printExpression, right char 'J'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if15
	jmp .end_if15
.if15:
	mov rax, 1
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	mov rax, qword rdi; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	jmp .exit
	jmp .end_if15
.end_if15:
.end_if14:
.end_if13:
.end_if9:
.end_if5:
.end_if1:
	mov rax, 0
	jmp .exit
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
	sub rsp, 120
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, 0
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable lineLength
	mov rax, 0
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable next
	mov rax, 0
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable start
	mov rax, 0
	mov qword [rbp-48], rax; LOOP i
.label1:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-48], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 8
	mov rax, qword [rbp-48]; printExpression variable i
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-49], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if16
	jmp .end_if16
.if16:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable lineLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if17
	jmp .end_if17
.if17:
	mov rax, qword [rbp-48]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable lineLength
	jmp .end_if17
.end_if17:
	jmp .end_if16
.end_if16:
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
	mov rbx, 83; printExpression, right char 'S'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if18
	jmp .end_if18
.if18:
	mov rax, qword [rbp-48]; printExpression variable i
	mov qword [rbp-40], rax; VAR_ASSIGNMENT else variable start
	jmp .not_label1
	jmp .end_if18
.end_if18:
	add rsp, 8
.skip_label1:
	mov rax, qword [rbp-48]; LOOP i
	inc rax
	mov qword [rbp-48], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable start
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable lineLength
	sub rax, rbx
	mov qword [rbp-81], rax; VAR_DECL_ASSIGN ARRAY variable cardinalities[0]
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable start
	mov rbx, 1; printExpression, right int
	sub rax, rbx
	mov qword [rbp-73], rax; VAR_DECL_ASSIGN ARRAY variable cardinalities[1]
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable start
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-65], rax; VAR_DECL_ASSIGN ARRAY variable cardinalities[2]
	mov rax, qword [rbp-40]; printExpression, left identifier, rbp variable start
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	mov qword [rbp-57], rax; VAR_DECL_ASSIGN ARRAY variable cardinalities[3]
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 13
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-24]; variable lineLength
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	movzx rax, word [s_direction]; printExpression global variable s_direction
	cmp rax, 4; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp-81+rax*8]; printExpression array cardinalities
	mov rax, r12
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable lineLength
	mov rsi, rax
	call GetNext
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-32], rax; VAR_ASSIGNMENT else variable next
.label2:
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable next
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if19
	jmp .end_if19
.if19:
	jmp .not_label2
	jmp .end_if19
.end_if19:
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	movzx rax, word [s_direction]; printExpression global variable s_direction
	cmp rax, 4; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp-81+rax*8]; printExpression array cardinalities
	mov rax, r12
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable lineLength
	mov rsi, rax
	call GetNext
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-32], rax; VAR_ASSIGNMENT else variable next
.skip_label2:
	jmp .label2
.not_label2:
	mov rax, 1
	mov qword [rbp-89], rax; VAR_DECL_ASSIGN else variable totalLength
.label3:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 83; printExpression, right char 'S'
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if20
	jmp .end_if20
.if20:
	jmp .not_label3
	jmp .end_if20
.end_if20:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-32]; printExpression variable next
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable lineLength
	mov rsi, rax
	call GetNext
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov qword [rbp-32], rax; VAR_ASSIGNMENT else variable next
	mov rax, qword [rbp-89]; printExpression, left identifier, rbp variable totalLength
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-89], rax; VAR_ASSIGNMENT else variable totalLength
.skip_label3:
	jmp .label3
.not_label3:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 23
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-89]; printExpression, left identifier, rbp variable totalLength
	mov rbx, 2; printExpression, right int
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov qword [rbp-97], rax; VAR_DECL_ASSIGN else variable furthestLength
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-97]; variable furthestLength
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	add rsp, 120
	jmp .exit
	add rsp, 120
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
	sub rsp, 48
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable sum
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
	jnz .if21
	jmp .end_if21
.if21:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if21
.end_if21:
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
	jnz .if22
	jmp .end_if22
.if22:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if22
.end_if22:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part1
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
