section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Number of ways to beat the record: ",0
	str1: db "Options part 2: ",0
	str2: db "Could not open file",0xA,0
	str3: db "Could not read from file",0xA,0
	s_distances_count db 0
	s_times_count db 0
section .bss
	s_buffer resb 100
	s_distances resq 4
	s_times resq 4
	s_trimmed_buffer resb 100

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

global GetOptions
GetOptions:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable time
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable maxTime
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-24], rax; LOOP i
.label1:
	mov rax, qword [rbp-8]; printExpression variable maxTime
	cmp qword [rbp-24], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable maxTime
	mov rbx, qword [rbp-24]; printExpression, right identifier, rbp variable i
	sub rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable i
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword rsi; printExpression, right identifier, not rbp
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .end_if1
.if1:
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable returnValue
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable returnValue
	jmp .end_if1
.end_if1:
.skip_label1:
	mov rax, qword [rbp-24]; LOOP i
	inc rax
	mov qword [rbp-24], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, qword [rbp-16]; printExpression variable returnValue
	add rsp, 40
	jmp .exit
	add rsp, 40
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
	mov dword [rbp-12], eax; VAR_DECL_ASSIGN else variable parseDistances
	mov rax, 0
	mov qword [rbp-20], rax; LOOP i
.label2:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-20], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 8
	mov rax, qword [rbp-20]; printExpression variable i
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-21], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-21]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .else_if2
.if2:
	mov rax, 1
	mov dword [rbp-12], eax; VAR_ASSIGNMENT else variable parseDistances
	jmp .end_if2
.else_if2:
	movzx rax, byte [rbp-21]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-21]; printExpression, left identifier, rbp variable byte
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
	jnz .if3
	jmp .end_if3
.if3:
	sub rsp, 16
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-20]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	mov qword [rbp-29], rax; VAR_DECL_ASSIGN else variable num
	mov rax, 0
	mov byte [rbp-30], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-31], al; LOOP j
.label3:
	mov rax, 20
	cmp byte [rbp-31], al; LOOP j
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 8
	mov rax, qword [rbp-20]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-31]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-32], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-32]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-32]; printExpression, left identifier, rbp variable numByte
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
	jnz .if4
	jmp .else_if4
.if4:
	movzx rax, byte [rbp-30]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-30], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if4
.else_if4:
	jmp .not_label3
.end_if4:
	add rsp, 8
.skip_label3:
	mov al, byte [rbp-31]; LOOP j
	inc rax
	mov byte [rbp-31], al; LOOP j
	jmp .label3
.not_label3:
	movzx rax, byte [rbp-30]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov byte [rbp-30], al; VAR_ASSIGNMENT else variable numLength
	mov rax, qword [rbp-20]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-30]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-20], rax; VAR_ASSIGNMENT else variable i
	mov eax, dword [rbp-12]; printExpression !parseDistances
	xor rax, 1
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
	movzx rax, byte [s_times_count]; printExpression global variable s_times_count
	cmp rax, 4; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-29]; printExpression variable num
	pop r11
	mov qword [s_times+r11*8], rax; VAR_ASSIGNMENT ARRAY s_times
	movzx rax, byte [s_times_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [s_times_count], al; VAR_ASSIGNMENT else variable s_times_count
	jmp .end_if5
.else_if5:
	movzx rax, byte [s_distances_count]; printExpression global variable s_distances_count
	cmp rax, 4; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-29]; printExpression variable num
	pop r11
	mov qword [s_distances+r11*8], rax; VAR_ASSIGNMENT ARRAY s_distances
	movzx rax, byte [s_distances_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [s_distances_count], al; VAR_ASSIGNMENT else variable s_distances_count
.end_if5:
	add rsp, 16
	jmp .end_if3
.end_if3:
.end_if2:
	add rsp, 8
.skip_label2:
	mov rax, qword [rbp-20]; LOOP i
	inc rax
	mov qword [rbp-20], rax; LOOP i
	jmp .label2
.not_label2:
	mov rax, 1
	mov qword [rbp-28], rax; VAR_DECL_ASSIGN else variable optionsProduct
	mov rax, 0
	mov qword [rbp-36], rax; LOOP i
.label4:
	movzx rax, byte [s_times_count]; printExpression global variable s_times_count
	cmp qword [rbp-36], rax; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 24
	mov rax, qword [rbp-36]; printExpression variable i
	cmp rax, 4; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_times+rax*8]; printExpression array s_times
	mov rax, r12
	mov rdi, rax
	mov rax, qword [rbp-36]; printExpression variable i
	cmp rax, 4; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_distances+rax*8]; printExpression array s_distances
	mov rax, r12
	mov rsi, rax
	call GetOptions
	mov dword [rbp-40], eax; VAR_DECL_ASSIGN else variable options
	mov rax, qword [rbp-28]; printExpression, left identifier, rbp variable optionsProduct
	mov ebx, dword [rbp-40]; printExpression, right identifier, rbp variable options
	mul qword rbx
	mov qword [rbp-28], rax; VAR_ASSIGNMENT else variable optionsProduct
	add rsp, 24
.skip_label4:
	mov rax, qword [rbp-36]; LOOP i
	inc rax
	mov qword [rbp-36], rax; LOOP i
	jmp .label4
.not_label4:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 35
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-28]; variable optionsProduct
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
	sub rsp, 72
	mov rax, 0
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable trimmedCount
	mov rax, 0
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable time
	mov rax, 0
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable distance
	mov rax, 0
	mov qword [rbp-32], rax; LOOP i
.label5:
	mov rax, qword rdi; printExpression variable size
	cmp qword [rbp-32], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	mov rax, qword [rbp-32]; printExpression variable i
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-33], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-33]; printExpression, left identifier, rbp variable byte
	mov rbx, 32; printExpression, right char ' '
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	jmp .skip_label5
	jmp .end_if6
.end_if6:
	mov rax, qword [rbp-8]; printExpression variable trimmedCount
	cmp rax, 100; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-33]; printExpression variable byte
	pop r11
	mov byte [s_trimmed_buffer+r11*1], al; VAR_ASSIGNMENT ARRAY s_trimmed_buffer
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable trimmedCount
	mov rbx, 1; printExpression, right int
	add rax, rbx
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable trimmedCount
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-32]; LOOP i
	inc rax
	mov qword [rbp-32], rax; LOOP i
	jmp .label5
.not_label5:
	mov rax, 0
	mov dword [rbp-36], eax; VAR_DECL_ASSIGN else variable parseDistances
	mov rax, 0
	mov qword [rbp-44], rax; LOOP i
.label6:
	mov rax, qword [rbp-8]; printExpression variable trimmedCount
	cmp qword [rbp-44], rax; LOOP i
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 8
	mov rax, qword [rbp-44]; printExpression variable i
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_trimmed_buffer+rax*1]; printExpression array s_trimmed_buffer
	mov rax, r12
	mov byte [rbp-45], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-45]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	mov rax, 1
	mov dword [rbp-36], eax; VAR_ASSIGNMENT else variable parseDistances
	jmp .end_if7
.else_if7:
	movzx rax, byte [rbp-45]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-45]; printExpression, left identifier, rbp variable byte
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
	jmp .end_if8
.if8:
	sub rsp, 16
	lea rax, [s_trimmed_buffer]; printExpression variable s_trimmed_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-44]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	mov qword [rbp-53], rax; VAR_DECL_ASSIGN else variable num
	mov rax, 0
	mov byte [rbp-54], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-55], al; LOOP j
.label7:
	mov rax, 20
	cmp byte [rbp-55], al; LOOP j
	jl .inside_label7
	jmp .not_label7
.inside_label7:
	sub rsp, 8
	mov rax, qword [rbp-44]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-55]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 100; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_trimmed_buffer+rax*1]; printExpression array s_trimmed_buffer
	mov rax, r12
	mov byte [rbp-56], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-56]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-56]; printExpression, left identifier, rbp variable numByte
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
	jnz .if9
	jmp .else_if9
.if9:
	movzx rax, byte [rbp-54]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-54], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if9
.else_if9:
	jmp .not_label7
.end_if9:
	add rsp, 8
.skip_label7:
	mov al, byte [rbp-55]; LOOP j
	inc rax
	mov byte [rbp-55], al; LOOP j
	jmp .label7
.not_label7:
	movzx rax, byte [rbp-54]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov byte [rbp-54], al; VAR_ASSIGNMENT else variable numLength
	mov rax, qword [rbp-44]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-54]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-44], rax; VAR_ASSIGNMENT else variable i
	mov eax, dword [rbp-36]; printExpression !parseDistances
	xor rax, 1
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	mov rax, qword [rbp-53]; printExpression variable num
	mov qword [rbp-16], rax; VAR_ASSIGNMENT else variable time
	jmp .end_if10
.else_if10:
	mov rax, qword [rbp-53]; printExpression variable num
	mov qword [rbp-24], rax; VAR_ASSIGNMENT else variable distance
.end_if10:
	add rsp, 16
	jmp .end_if8
.end_if8:
.end_if7:
	add rsp, 8
.skip_label6:
	mov rax, qword [rbp-44]; LOOP i
	inc rax
	mov qword [rbp-44], rax; LOOP i
	jmp .label6
.not_label6:
	mov rax, qword [rbp-16]; printExpression variable time
	mov rdi, rax
	mov rax, qword [rbp-24]; printExpression variable distance
	mov rsi, rax
	call GetOptions
	mov qword [rbp-52], rax; VAR_DECL_ASSIGN else variable options
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 16
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-52]; variable options
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	add rsp, 72
	jmp .exit
	add rsp, 72
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
	mov dword [rbp-4], eax; VAR_DECL_ASSIGN else variable fd
	movsxd rax, dword [rbp-4]; printExpression, left identifier, rbp variable fd
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp eax, ebx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .end_if11
.if11:
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
	jmp .end_if11
.end_if11:
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 74
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
	jnz .if12
	jmp .end_if12
.if12:
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
	jmp .end_if12
.end_if12:
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
