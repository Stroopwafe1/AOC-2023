section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Line length: ",0
	str1: db "Furthest point part 1: ",0
	str2: db "Number of tiles enclosed by pipe: ",0
	str3: db "Could not open file",0xA,0
	str4: db "Could not read from file",0xA,0
	s_direction dw 0
	s_pipe_buffer_count dw 0
section .bss
	s_buffer resb 21300
	s_pipe_buffer resq 21300

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

global IsPipe
IsPipe:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov rax, 0
	mov qword [rbp-8], rax; LOOP i
.label1:
	movzx rax, word [s_pipe_buffer_count]; printExpression global variable s_pipe_buffer_count
	cmp qword [rbp-8], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	mov rax, qword [rbp-8]; printExpression variable i
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_pipe_buffer+rax*8]; printExpression array s_pipe_buffer
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword rdi; printExpression, right identifier, not rbp
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if16
	jmp .end_if16
.if16:
	mov rax, 1
	add rsp, 24
	jmp .exit
	jmp .end_if16
.end_if16:
.skip_label1:
	mov rax, qword [rbp-8]; LOOP i
	inc rax
	mov qword [rbp-8], rax; LOOP i
	jmp .label1
.not_label1:
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
.label2:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-48], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
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
	jnz .if17
	jmp .end_if17
.if17:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable lineLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if18
	jmp .end_if18
.if18:
	mov rax, qword [rbp-48]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable lineLength
	jmp .end_if18
.end_if18:
	jmp .end_if17
.end_if17:
	movzx rax, byte [rbp-49]; printExpression, left identifier, rbp variable byte
	mov rbx, 83; printExpression, right char 'S'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if19
	jmp .end_if19
.if19:
	mov rax, qword [rbp-48]; printExpression variable i
	mov qword [rbp-40], rax; VAR_ASSIGNMENT else variable start
	jmp .not_label2
	jmp .end_if19
.end_if19:
	add rsp, 8
.skip_label2:
	mov rax, qword [rbp-48]; LOOP i
	inc rax
	mov qword [rbp-48], rax; LOOP i
	jmp .label2
.not_label2:
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
	movzx rax, word [s_pipe_buffer_count]; printExpression global variable s_pipe_buffer_count
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-40]; printExpression variable start
	pop r11
	mov qword [s_pipe_buffer+r11*8], rax; VAR_ASSIGNMENT ARRAY s_pipe_buffer
	movzx rax, word [s_pipe_buffer_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_pipe_buffer_count], ax; VAR_ASSIGNMENT else variable s_pipe_buffer_count
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
	mov rax, 0
	mov byte [rbp-82], al; VAR_DECL_ASSIGN else variable prevDirection
.label3:
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable next
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if20
	jmp .end_if20
.if20:
	movzx rax, word [s_pipe_buffer_count]; printExpression global variable s_pipe_buffer_count
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-82]; printExpression variable prevDirection
	cmp rax, 4; check bounds
	jge array_out_of_bounds
	mov r12, qword [rbp-81+rax*8]; printExpression array cardinalities
	mov rax, r12
	pop r11
	mov qword [s_pipe_buffer+r11*8], rax; VAR_ASSIGNMENT ARRAY s_pipe_buffer
	movzx rax, word [s_pipe_buffer_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_pipe_buffer_count], ax; VAR_ASSIGNMENT else variable s_pipe_buffer_count
	jmp .not_label3
	jmp .end_if20
.end_if20:
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_direction], ax; VAR_ASSIGNMENT else variable s_direction
	movzx rax, word [s_direction]; printExpression global variable s_direction
	mov byte [rbp-82], al; VAR_ASSIGNMENT else variable prevDirection
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
.skip_label3:
	jmp .label3
.not_label3:
	mov rax, 1
	mov qword [rbp-90], rax; VAR_DECL_ASSIGN else variable totalLength
.label4:
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
	jnz .if21
	jmp .end_if21
.if21:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	movzx rbx, word [s_direction]; printExpression, right identifier, not rbp
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if22
	jmp .else_if22
.if22:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	or al, bl
	test rax, rax
	jnz .if23
	jmp .else_if23
.if23:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 124; CHAR_LITERAL '|'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if23
.else_if23:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 45; CHAR_LITERAL '-'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
.end_if23:
	jmp .end_if22
.else_if22:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if24
	jmp .else_if24
.if24:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 76; CHAR_LITERAL 'L'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if24
.else_if24:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if25
	jmp .else_if25
.if25:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 74; CHAR_LITERAL 'J'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if25
.else_if25:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if26
	jmp .else_if26
.if26:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 55; CHAR_LITERAL '7'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if26
.else_if26:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if27
	jmp .else_if27
.if27:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 74; CHAR_LITERAL 'J'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if27
.else_if27:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if28
	jmp .else_if28
.if28:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 70; CHAR_LITERAL 'F'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if28
.else_if28:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if29
	jmp .else_if29
.if29:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 76; CHAR_LITERAL 'L'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if29
.else_if29:
	movzx rax, byte [rbp-82]; printExpression, left identifier, rbp variable prevDirection
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, word [s_direction]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if30
	jmp .else_if30
.if30:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 55; CHAR_LITERAL '7'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
	jmp .end_if30
.else_if30:
	mov rax, qword [rbp-32]; printExpression variable next
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, 70; CHAR_LITERAL 'F'
	pop r11
	mov byte [s_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_buffer
.end_if30:
.end_if29:
.end_if28:
.end_if27:
.end_if26:
.end_if25:
.end_if24:
.end_if22:
	jmp .not_label4
	jmp .end_if21
.end_if21:
	movzx rax, word [s_pipe_buffer_count]; printExpression global variable s_pipe_buffer_count
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-32]; printExpression variable next
	pop r11
	mov qword [s_pipe_buffer+r11*8], rax; VAR_ASSIGNMENT ARRAY s_pipe_buffer
	movzx rax, word [s_pipe_buffer_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_pipe_buffer_count], ax; VAR_ASSIGNMENT else variable s_pipe_buffer_count
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
	mov rax, qword [rbp-90]; printExpression, left identifier, rbp variable totalLength
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-90], rax; VAR_ASSIGNMENT else variable totalLength
.skip_label4:
	jmp .label4
.not_label4:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 23
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-90]; printExpression, left identifier, rbp variable totalLength
	mov rbx, 2; printExpression, right int
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov qword [rbp-98], rax; VAR_DECL_ASSIGN else variable furthestLength
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-98]; variable furthestLength
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
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable lineLength
	mov rax, 0
	mov qword [rbp-32], rax; LOOP i
.label5:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-32], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	mov rax, qword [rbp-32]; printExpression variable i
	cmp rax, 21300; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-33], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-33]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if31
	jmp .end_if31
.if31:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable lineLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if32
	jmp .end_if32
.if32:
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable lineLength
	jmp .end_if32
.end_if32:
	jmp .end_if31
.end_if31:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-32]; printExpression variable i
	mov rdi, rax
	call IsPipe
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	test rax, rax
	jnz .if33
	jmp .end_if33
.if33:
	jmp .skip_label5
	jmp .end_if33
.end_if33:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable lineLength
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovne rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if34
	jmp .end_if34
.if34:
	sub rsp, 16
	mov rax, 0
	mov qword [rbp-41], rax; VAR_DECL_ASSIGN else variable verticalWalls
	mov rax, 0
	mov byte [rbp-42], al; VAR_DECL_ASSIGN else variable foundL
	mov rax, 0
	mov byte [rbp-43], al; VAR_DECL_ASSIGN else variable foundF
	mov rax, qword [rbp-32]; printExpression variable i
	mov qword [rbp-51], rax; LOOP j
.label6:
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable i
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable lineLength
	add rax, rbx
	cmp qword [rbp-51], rax; LOOP j
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 8
	mov rax, qword [rbp-51]; printExpression variable j
	cmp rax, 21300; check bounds
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
	jnz .if35
	jmp .end_if35
.if35:
	jmp .not_label6
	jmp .end_if35
.end_if35:
	push rdi
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	push r10
	mov rax, qword [rbp-51]; printExpression variable j
	mov rdi, rax
	call IsPipe
	pop r10
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	mov byte [rbp-52], al; VAR_DECL_ASSIGN else variable isPipe
	movzx rax, byte [rbp-52]; printExpression !isPipe
	xor rax, 1
	test rax, rax
	jnz .if36
	jmp .end_if36
.if36:
	mov rax, 0
	mov byte [rbp-42], al; VAR_ASSIGNMENT else variable foundL
	mov rax, 0
	mov byte [rbp-43], al; VAR_ASSIGNMENT else variable foundF
	jmp .skip_label6
	jmp .end_if36
.end_if36:
	mov rax, qword [rbp-51]; printExpression variable j
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
	jnz .if37
	jmp .else_if37
.if37:
	mov rax, 0
	mov byte [rbp-42], al; VAR_ASSIGNMENT else variable foundL
	mov rax, 0
	mov byte [rbp-43], al; VAR_ASSIGNMENT else variable foundF
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable verticalWalls
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-41], rax; VAR_ASSIGNMENT else variable verticalWalls
	jmp .end_if37
.else_if37:
	mov rax, qword [rbp-51]; printExpression variable j
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
	jnz .if38
	jmp .else_if38
.if38:
	mov rax, 0
	mov byte [rbp-43], al; VAR_ASSIGNMENT else variable foundF
	mov rax, 1
	mov byte [rbp-42], al; VAR_ASSIGNMENT else variable foundL
	jmp .end_if38
.else_if38:
	mov rax, qword [rbp-51]; printExpression variable j
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
	jnz .if39
	jmp .else_if39
.if39:
	mov rax, 0
	mov byte [rbp-42], al; VAR_ASSIGNMENT else variable foundL
	mov rax, 1
	mov byte [rbp-43], al; VAR_ASSIGNMENT else variable foundF
	jmp .end_if39
.else_if39:
	mov rax, qword [rbp-51]; printExpression variable j
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
	jnz .if40
	jmp .else_if40
.if40:
	movzx rax, byte [rbp-42]; printExpression variable foundL
	test rax, rax
	jnz .if41
	jmp .end_if41
.if41:
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable verticalWalls
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-41], rax; VAR_ASSIGNMENT else variable verticalWalls
	jmp .end_if41
.end_if41:
	mov rax, 0
	mov byte [rbp-42], al; VAR_ASSIGNMENT else variable foundL
	mov rax, 0
	mov byte [rbp-43], al; VAR_ASSIGNMENT else variable foundF
	jmp .end_if40
.else_if40:
	mov rax, qword [rbp-51]; printExpression variable j
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
	jnz .if42
	jmp .end_if42
.if42:
	movzx rax, byte [rbp-43]; printExpression variable foundF
	test rax, rax
	jnz .if43
	jmp .end_if43
.if43:
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable verticalWalls
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-41], rax; VAR_ASSIGNMENT else variable verticalWalls
	jmp .end_if43
.end_if43:
	mov rax, 0
	mov byte [rbp-43], al; VAR_ASSIGNMENT else variable foundF
	mov rax, 0
	mov byte [rbp-42], al; VAR_ASSIGNMENT else variable foundL
	jmp .end_if42
.end_if42:
.end_if40:
.end_if39:
.end_if38:
.end_if37:
	add rsp, 8
.skip_label6:
	mov rax, qword [rbp-51]; LOOP j
	inc rax
	mov qword [rbp-51], rax; LOOP j
	jmp .label6
.not_label6:
	mov rax, qword [rbp-41]; printExpression, left identifier, rbp variable verticalWalls
	mov rbx, 2; printExpression, right int
	cqo
	xor rdx, rdx; Clearing rdx for division
	div rax, rbx
	mov rax, rdx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if44
	jmp .end_if44
.if44:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable sum
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable sum
	jmp .end_if44
.end_if44:
	add rsp, 16
	jmp .end_if34
.end_if34:
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-32]; LOOP i
	inc rax
	mov qword [rbp-32], rax; LOOP i
	jmp .label5
.not_label5:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 34
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-16]; variable sum
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
	jnz .if45
	jmp .end_if45
.if45:
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
	jmp .end_if45
.end_if45:
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
	jnz .if46
	jmp .end_if46
.if46:
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
	jmp .end_if46
.end_if46:
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
