section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db " ",0
	str1: db "High card",0xA,0
	str2: db "One pair",0xA,0
	str3: db "Two pair",0xA,0
	str4: db "Three of a kind",0xA,0
	str5: db "Full house",0xA,0
	str6: db "Four of a kind",0xA,0
	str7: db "Five of a kind",0xA,0
	str8: db "Unreachable",0xA,0
	str9: db "Total winnings part 1: ",0
	str10: db " ",0
	str11: db "Total winnings part 2: ",0
	str12: db "Could not open file",0xA,0
	str13: db "Could not read from file",0xA,0
	s_bids_count dw 0
	s_cards_count dw 0
	s_types_count dw 0
section .bss
	s_bids resw 1000
	s_buffer resb 10000
	s_cards resb 5000
	s_types resb 1000

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

global GetValue
GetValue:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	movzx rax, byte dil; printExpression variable c
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if1
	jmp .else_if1
.if1:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 50; printExpression, right char '2'
	sub eax, ebx
	add rsp, 8
	jmp .exit
	jmp .end_if1
.else_if1:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 84; printExpression, right char 'T'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if2
	jmp .else_if2
.if2:
	mov rax, 8
	add rsp, 8
	jmp .exit
	jmp .end_if2
.else_if2:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 74; printExpression, right char 'J'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if3
	jmp .else_if3
.if3:
	mov rax, 9
	add rsp, 8
	jmp .exit
	jmp .end_if3
.else_if3:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 81; printExpression, right char 'Q'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if4
	jmp .else_if4
.if4:
	mov rax, 10
	add rsp, 8
	jmp .exit
	jmp .end_if4
.else_if4:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 75; printExpression, right char 'K'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if5
	jmp .else_if5
.if5:
	mov rax, 11
	add rsp, 8
	jmp .exit
	jmp .end_if5
.else_if5:
	mov rax, 12
	add rsp, 8
	jmp .exit
.end_if5:
.end_if4:
.end_if3:
.end_if2:
.end_if1:
	mov rax, 255
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetValueP2
GetValueP2:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	movzx rax, byte dil; printExpression variable c
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if6
	jmp .else_if6
.if6:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 49; printExpression, right char '1'
	sub eax, ebx
	add rsp, 8
	jmp .exit
	jmp .end_if6
.else_if6:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 84; printExpression, right char 'T'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if7
	jmp .else_if7
.if7:
	mov rax, 9
	add rsp, 8
	jmp .exit
	jmp .end_if7
.else_if7:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 74; printExpression, right char 'J'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if8
	jmp .else_if8
.if8:
	mov rax, 0
	add rsp, 8
	jmp .exit
	jmp .end_if8
.else_if8:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 81; printExpression, right char 'Q'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if9
	jmp .else_if9
.if9:
	mov rax, 10
	add rsp, 8
	jmp .exit
	jmp .end_if9
.else_if9:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable byte
	mov rbx, 75; printExpression, right char 'K'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if10
	jmp .else_if10
.if10:
	mov rax, 11
	add rsp, 8
	jmp .exit
	jmp .end_if10
.else_if10:
	mov rax, 12
	add rsp, 8
	jmp .exit
.end_if10:
.end_if9:
.end_if8:
.end_if7:
.end_if6:
	mov rax, 255
	add rsp, 8
	jmp .exit
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetType
GetType:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov rax, 0
	mov byte [rbp-14], al; VAR_DECL_ASSIGN ARRAY variable cardArr[0]
	mov rax, 0
	mov byte [rbp-13], al; VAR_DECL_ASSIGN ARRAY variable cardArr[1]
	mov rax, 0
	mov byte [rbp-12], al; VAR_DECL_ASSIGN ARRAY variable cardArr[2]
	mov rax, 0
	mov byte [rbp-11], al; VAR_DECL_ASSIGN ARRAY variable cardArr[3]
	mov rax, 0
	mov byte [rbp-10], al; VAR_DECL_ASSIGN ARRAY variable cardArr[4]
	mov rax, 0
	mov byte [rbp-9], al; VAR_DECL_ASSIGN ARRAY variable cardArr[5]
	mov rax, 0
	mov byte [rbp-8], al; VAR_DECL_ASSIGN ARRAY variable cardArr[6]
	mov rax, 0
	mov byte [rbp-7], al; VAR_DECL_ASSIGN ARRAY variable cardArr[7]
	mov rax, 0
	mov byte [rbp-6], al; VAR_DECL_ASSIGN ARRAY variable cardArr[8]
	mov rax, 0
	mov byte [rbp-5], al; VAR_DECL_ASSIGN ARRAY variable cardArr[9]
	mov rax, 0
	mov byte [rbp-4], al; VAR_DECL_ASSIGN ARRAY variable cardArr[10]
	mov rax, 0
	mov byte [rbp-3], al; VAR_DECL_ASSIGN ARRAY variable cardArr[11]
	mov rax, 0
	mov byte [rbp-2], al; VAR_DECL_ASSIGN ARRAY variable cardArr[12]
	mov rax, 0
	mov byte [rbp-15], al; LOOP i
.label1:
	mov rax, 5
	cmp byte [rbp-15], al; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 8
	mov rax, qword rdi; printExpression, left identifier, not rbp
	movzx rbx, byte [rbp-15]; printExpression, right identifier, rbp variable i
	add rax, rbx
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .end_if11
.if11:
	mov rax, 0
	add rsp, 32
	jmp .exit
	jmp .end_if11
.end_if11:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .else_if12
.if12:
	sub rsp, 8
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 50; printExpression, right char '2'
	sub eax, ebx
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable index
	movzx rax, byte [rbp-17]; printExpression variable index
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-17]; printExpression variable index
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	add rsp, 8
	jmp .end_if12
.else_if12:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 84; printExpression, right char 'T'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	mov rax, 8
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 8
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if13
.else_if13:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 74; printExpression, right char 'J'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if14
	jmp .else_if14
.if14:
	mov rax, 9
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 9
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if14
.else_if14:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 81; printExpression, right char 'Q'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if15
	jmp .else_if15
.if15:
	mov rax, 10
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 10
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if15
.else_if15:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 75; printExpression, right char 'K'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if16
	jmp .else_if16
.if16:
	mov rax, 11
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 11
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if16
.else_if16:
	mov rax, 12
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 12
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
.end_if16:
.end_if15:
.end_if14:
.end_if13:
.end_if12:
	add rsp, 8
.skip_label1:
	mov al, byte [rbp-15]; LOOP i
	inc rax
	mov byte [rbp-15], al; LOOP i
	jmp .label1
.not_label1:
	mov rax, 0
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else variable highest
	mov rax, 0
	mov byte [rbp-17], al; LOOP i
.label2:
	mov rax, 13
	cmp byte [rbp-17], al; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	movzx rax, byte [rbp-17]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if17
	jmp .else_if17
.if17:
	mov rax, 64
	add rsp, 24
	jmp .exit
	jmp .end_if17
.else_if17:
	movzx rax, byte [rbp-17]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 4; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if18
	jmp .else_if18
.if18:
	mov rax, 32
	add rsp, 24
	jmp .exit
	jmp .end_if18
.else_if18:
	movzx rax, byte [rbp-17]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 3; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if19
	jmp .else_if19
.if19:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if20
	jmp .else_if20
.if20:
	mov rax, 16
	add rsp, 24
	jmp .exit
	jmp .end_if20
.else_if20:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if21
	jmp .else_if21
.if21:
	mov rax, 8
	add rsp, 24
	jmp .exit
	jmp .end_if21
.else_if21:
	mov rax, 3
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable highest
.end_if21:
.end_if20:
	jmp .end_if19
.else_if19:
	movzx rax, byte [rbp-17]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if22
	jmp .else_if22
.if22:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if23
	jmp .else_if23
.if23:
	mov rax, 16
	add rsp, 24
	jmp .exit
	jmp .end_if23
.else_if23:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if24
	jmp .else_if24
.if24:
	mov rax, 4
	add rsp, 24
	jmp .exit
	jmp .end_if24
.else_if24:
	mov rax, 2
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable highest
.end_if24:
.end_if23:
	jmp .end_if22
.else_if22:
	movzx rax, byte [rbp-17]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if25
	jmp .end_if25
.if25:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if26
	jmp .else_if26
.if26:
	mov rax, 8
	add rsp, 24
	jmp .exit
	jmp .end_if26
.else_if26:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if27
	jmp .end_if27
.if27:
	mov rax, 1
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable highest
	jmp .end_if27
.end_if27:
.end_if26:
	jmp .end_if25
.end_if25:
.end_if22:
.end_if19:
.end_if18:
.end_if17:
.skip_label2:
	mov al, byte [rbp-17]; LOOP i
	inc rax
	mov byte [rbp-17], al; LOOP i
	jmp .label2
.not_label2:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if28
	jmp .end_if28
.if28:
	mov rax, 2
	add rsp, 24
	jmp .exit
	jmp .end_if28
.end_if28:
	mov rax, 1
	add rsp, 24
	jmp .exit
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetTypeP2
GetTypeP2:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	mov rax, 0
	mov byte [rbp-14], al; VAR_DECL_ASSIGN ARRAY variable cardArr[0]
	mov rax, 0
	mov byte [rbp-13], al; VAR_DECL_ASSIGN ARRAY variable cardArr[1]
	mov rax, 0
	mov byte [rbp-12], al; VAR_DECL_ASSIGN ARRAY variable cardArr[2]
	mov rax, 0
	mov byte [rbp-11], al; VAR_DECL_ASSIGN ARRAY variable cardArr[3]
	mov rax, 0
	mov byte [rbp-10], al; VAR_DECL_ASSIGN ARRAY variable cardArr[4]
	mov rax, 0
	mov byte [rbp-9], al; VAR_DECL_ASSIGN ARRAY variable cardArr[5]
	mov rax, 0
	mov byte [rbp-8], al; VAR_DECL_ASSIGN ARRAY variable cardArr[6]
	mov rax, 0
	mov byte [rbp-7], al; VAR_DECL_ASSIGN ARRAY variable cardArr[7]
	mov rax, 0
	mov byte [rbp-6], al; VAR_DECL_ASSIGN ARRAY variable cardArr[8]
	mov rax, 0
	mov byte [rbp-5], al; VAR_DECL_ASSIGN ARRAY variable cardArr[9]
	mov rax, 0
	mov byte [rbp-4], al; VAR_DECL_ASSIGN ARRAY variable cardArr[10]
	mov rax, 0
	mov byte [rbp-3], al; VAR_DECL_ASSIGN ARRAY variable cardArr[11]
	mov rax, 0
	mov byte [rbp-2], al; VAR_DECL_ASSIGN ARRAY variable cardArr[12]
	mov rax, 0
	mov byte [rbp-15], al; LOOP i
.label3:
	mov rax, 5
	cmp byte [rbp-15], al; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 8
	mov rax, qword rdi; printExpression, left identifier, not rbp
	movzx rbx, byte [rbp-15]; printExpression, right identifier, rbp variable i
	add rax, rbx
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if29
	jmp .end_if29
.if29:
	mov rax, 0
	add rsp, 32
	jmp .exit
	jmp .end_if29
.end_if29:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 57; printExpression, right char '9'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovle rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if30
	jmp .else_if30
.if30:
	sub rsp, 8
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 50; printExpression, right char '2'
	sub eax, ebx
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable index
	movzx rax, byte [rbp-17]; printExpression variable index
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-17]; printExpression variable index
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	add rsp, 8
	jmp .end_if30
.else_if30:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 84; printExpression, right char 'T'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if31
	jmp .else_if31
.if31:
	mov rax, 8
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 8
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if31
.else_if31:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 74; printExpression, right char 'J'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if32
	jmp .else_if32
.if32:
	mov rax, 9
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 9
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if32
.else_if32:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 81; printExpression, right char 'Q'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if33
	jmp .else_if33
.if33:
	mov rax, 10
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 10
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if33
.else_if33:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable byte
	mov rbx, 75; printExpression, right char 'K'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if34
	jmp .else_if34
.if34:
	mov rax, 11
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 11
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
	jmp .end_if34
.else_if34:
	mov rax, 12
	cmp rax, 13; check bounds	jge array_out_of_bounds
	push rax
	mov rax, 12
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	pop r11
	mov byte [rbp-14+r11*1], al; VAR_ASSIGNMENT ARRAY cardArr
.end_if34:
.end_if33:
.end_if32:
.end_if31:
.end_if30:
	add rsp, 8
.skip_label3:
	mov al, byte [rbp-15]; LOOP i
	inc rax
	mov byte [rbp-15], al; LOOP i
	jmp .label3
.not_label3:
	mov rax, 0
	mov byte [rbp-16], al; VAR_DECL_ASSIGN else variable highest
	mov rax, 0
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable foundTwo
	mov rax, 0
	mov byte [rbp-18], al; LOOP i
.label4:
	mov rax, 13
	cmp byte [rbp-18], al; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	movzx rax, byte [rbp-18]; printExpression, left identifier, rbp variable i
	mov rbx, 9; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if35
	jmp .end_if35
.if35:
	jmp .skip_label4
	jmp .end_if35
.end_if35:
	movzx rax, byte [rbp-18]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if36
	jmp .else_if36
.if36:
	mov rax, 64
	add rsp, 24
	jmp .exit
	jmp .end_if36
.else_if36:
	movzx rax, byte [rbp-18]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-16]; printExpression, right identifier, rbp variable highest
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if37
	jmp .else_if37
.if37:
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if38
	jmp .end_if38
.if38:
	mov rax, 1
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable foundTwo
	jmp .end_if38
.end_if38:
	movzx rax, byte [rbp-18]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	mov byte [rbp-16], al; VAR_ASSIGNMENT else variable highest
	jmp .end_if37
.else_if37:
	movzx rax, byte [rbp-18]; printExpression variable i
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rax, r12
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if39
	jmp .end_if39
.if39:
	mov rax, 1
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable foundTwo
	jmp .end_if39
.end_if39:
.end_if37:
.end_if36:
.skip_label4:
	mov al, byte [rbp-18]; LOOP i
	inc rax
	mov byte [rbp-18], al; LOOP i
	jmp .label4
.not_label4:
	mov rax, 9
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rbx, r12; printExpression, nodeType=1, array index
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
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
	mov rax, 64
	add rsp, 24
	jmp .exit
	jmp .end_if40
.else_if40:
	mov rax, 9
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rbx, r12; printExpression, nodeType=1, array index
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 4; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if41
	jmp .else_if41
.if41:
	mov rax, 32
	add rsp, 24
	jmp .exit
	jmp .end_if41
.else_if41:
	mov rax, 9
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rbx, r12; printExpression, nodeType=1, array index
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 3; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if42
	jmp .else_if42
.if42:
	movzx rax, byte [rbp-17]; printExpression variable foundTwo
	test rax, rax
	jnz .if43
	jmp .else_if43
.if43:
	mov rax, 16
	add rsp, 24
	jmp .exit
	jmp .end_if43
.else_if43:
	mov rax, 8
	add rsp, 24
	jmp .exit
.end_if43:
	jmp .end_if42
.else_if42:
	mov rax, 9
	cmp rax, 13; check bounds
	jge array_out_of_bounds
	movzx r12, byte [rbp-14+rax*1]; printExpression array cardArr
	mov rbx, r12; printExpression, nodeType=1, array index
	movzx rax, byte [rbp-16]; printExpression, left identifier, rbp variable highest
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
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
	movzx rax, byte [rbp-17]; printExpression variable foundTwo
	test rax, rax
	jnz .if45
	jmp .else_if45
.if45:
	mov rax, 4
	add rsp, 24
	jmp .exit
	jmp .end_if45
.else_if45:
	mov rax, 2
	add rsp, 24
	jmp .exit
.end_if45:
	jmp .end_if44
.end_if44:
.end_if42:
.end_if41:
.end_if40:
	mov rax, 1
	add rsp, 24
	jmp .exit
	add rsp, 24
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global PrintType
PrintType:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 8
	movzx rax, byte dil; printExpression variable type
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable t
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 1
	syscall
; =============== END FUNC CALL + STRING ===============
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable t
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if46
	jmp .else_if46
.if46:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 10
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if46
.else_if46:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable t
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if47
	jmp .else_if47
.if47:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 9
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if47
.else_if47:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable t
	mov rbx, 4; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if48
	jmp .else_if48
.if48:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 9
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if48
.else_if48:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable t
	mov rbx, 8; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if49
	jmp .else_if49
.if49:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 16
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if49
.else_if49:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable t
	mov rbx, 16; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if50
	jmp .else_if50
.if50:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 11
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if50
.else_if50:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable t
	mov rbx, 32; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if51
	jmp .else_if51
.if51:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 15
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if51
.else_if51:
	movzx rax, byte [rbp-1]; printExpression, left identifier, rbp variable t
	mov rbx, 64; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if52
	jmp .else_if52
.if52:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 15
	syscall
; =============== END FUNC CALL + STRING ===============
	jmp .end_if52
.else_if52:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str8
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
.end_if52:
.end_if51:
.end_if50:
.end_if49:
.end_if48:
.end_if47:
.end_if46:
	add rsp, 8
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global Sort
Sort:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 24
	movzx rax, byte dil; printExpression variable part1
	mov byte [rbp-1], al; VAR_DECL_ASSIGN else variable p1
	mov rax, 0
	mov qword [rbp-9], rax; LOOP i
.label5:
	movzx rax, word [s_bids_count]; printExpression global variable s_bids_count
	cmp qword [rbp-9], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 8
	mov rax, 0
	mov byte [rbp-10], al; VAR_DECL_ASSIGN else variable swapped
	mov rax, 0
	mov qword [rbp-18], rax; LOOP j
.label6:
	movzx rax, word [s_bids_count]; printExpression, left identifier, not rbp
	mov rbx, qword [rbp-9]; printExpression, right identifier, rbp variable i
	sub rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	sub rax, rbx
	cmp qword [rbp-18], rax; LOOP j
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 32
	mov rax, qword [rbp-18]; printExpression variable j
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_types+rax*1]; printExpression array s_types
	mov rax, r12
	mov byte [rbp-19], al; VAR_DECL_ASSIGN else variable typeA
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_types+rax*1]; printExpression array s_types
	mov rax, r12
	mov byte [rbp-20], al; VAR_DECL_ASSIGN else variable typeB
	movzx rax, byte [rbp-19]; printExpression, left identifier, rbp variable typeA
	movzx rbx, byte [rbp-20]; printExpression, right identifier, rbp variable typeB
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if53
	jmp .else_if53
.if53:
	sub rsp, 40
	mov rax, 0
	mov byte [rbp-21], al; LOOP k
.label7:
	mov rax, 5
	cmp byte [rbp-21], al; LOOP k
	jl .inside_label7
	jmp .not_label7
.inside_label7:
	sub rsp, 8
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-21]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_cards+rax*1]; printExpression array s_cards
	mov rax, r12
	mov byte [rbp-22], al; VAR_DECL_ASSIGN else variable toSwap
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-21]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 5; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-21]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_cards+rax*1]; printExpression array s_cards
	mov rax, r12
	pop r11
	mov byte [s_cards+r11*1], al; VAR_ASSIGNMENT ARRAY s_cards
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 5; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-21]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-22]; printExpression variable toSwap
	pop r11
	mov byte [s_cards+r11*1], al; VAR_ASSIGNMENT ARRAY s_cards
	add rsp, 8
.skip_label7:
	mov al, byte [rbp-21]; LOOP k
	inc rax
	mov byte [rbp-21], al; LOOP k
	jmp .label7
.not_label7:
	mov rax, qword [rbp-18]; printExpression variable j
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-20]; printExpression variable typeB
	pop r11
	mov byte [s_types+r11*1], al; VAR_ASSIGNMENT ARRAY s_types
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-19]; printExpression variable typeA
	pop r11
	mov byte [s_types+r11*1], al; VAR_ASSIGNMENT ARRAY s_types
	mov rax, qword [rbp-18]; printExpression variable j
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, word [s_bids+rax*2]; printExpression array s_bids
	mov rax, r12
	mov qword [rbp-29], rax; VAR_DECL_ASSIGN else variable toSwap
	mov rax, qword [rbp-18]; printExpression variable j
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, word [s_bids+rax*2]; printExpression array s_bids
	mov rax, r12
	pop r11
	mov word [s_bids+r11*2], ax; VAR_ASSIGNMENT ARRAY s_bids
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-29]; printExpression variable toSwap
	pop r11
	mov word [s_bids+r11*2], ax; VAR_ASSIGNMENT ARRAY s_bids
	mov rax, 1
	mov byte [rbp-10], al; VAR_ASSIGNMENT else variable swapped
	add rsp, 40
	jmp .end_if53
.else_if53:
	movzx rax, byte [rbp-19]; printExpression, left identifier, rbp variable typeA
	movzx rbx, byte [rbp-20]; printExpression, right identifier, rbp variable typeB
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if54
	jmp .end_if54
.if54:
	sub rsp, 32
	mov rax, 0
	mov byte [rbp-21], al; VAR_DECL_ASSIGN else variable aIsGreater
	mov rax, 0
	mov byte [rbp-22], al; LOOP k
.label8:
	mov rax, 5
	cmp byte [rbp-22], al; LOOP k
	jl .inside_label8
	jmp .not_label8
.inside_label8:
	sub rsp, 8
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 5; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-22]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_cards+rax*1]; printExpression array s_cards
	mov rax, r12
	mov byte [rbp-23], al; VAR_DECL_ASSIGN else variable a
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-22]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_cards+rax*1]; printExpression array s_cards
	mov rax, r12
	mov byte [rbp-24], al; VAR_DECL_ASSIGN else variable b
	mov rax, 0
	mov word [rbp-26], ax; VAR_DECL_ASSIGN else variable aVal
	mov rax, 0
	mov word [rbp-28], ax; VAR_DECL_ASSIGN else variable bVal
	movzx rax, byte [rbp-1]; printExpression variable p1
	test rax, rax
	jnz .if55
	jmp .else_if55
.if55:
	movzx rax, byte [rbp-23]; printExpression variable a
	mov rdi, rax
	call GetValue
	mov word [rbp-26], ax; VAR_ASSIGNMENT else variable aVal
	movzx rax, byte [rbp-24]; printExpression variable b
	mov rdi, rax
	call GetValue
	mov word [rbp-28], ax; VAR_ASSIGNMENT else variable bVal
	jmp .end_if55
.else_if55:
	movzx rax, byte [rbp-23]; printExpression variable a
	mov rdi, rax
	call GetValueP2
	mov word [rbp-26], ax; VAR_ASSIGNMENT else variable aVal
	movzx rax, byte [rbp-24]; printExpression variable b
	mov rdi, rax
	call GetValueP2
	mov word [rbp-28], ax; VAR_ASSIGNMENT else variable bVal
.end_if55:
	movzx rax, word [rbp-26]; printExpression, left identifier, rbp variable aVal
	movzx rbx, word [rbp-28]; printExpression, right identifier, rbp variable bVal
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if56
	jmp .end_if56
.if56:
	jmp .not_label8
	jmp .end_if56
.end_if56:
	movzx rax, word [rbp-26]; printExpression, left identifier, rbp variable aVal
	movzx rbx, word [rbp-28]; printExpression, right identifier, rbp variable bVal
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovg rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if57
	jmp .end_if57
.if57:
	mov rax, 1
	mov byte [rbp-21], al; VAR_ASSIGNMENT else variable aIsGreater
	jmp .not_label8
	jmp .end_if57
.end_if57:
	add rsp, 8
.skip_label8:
	mov al, byte [rbp-22]; LOOP k
	inc rax
	mov byte [rbp-22], al; LOOP k
	jmp .label8
.not_label8:
	movzx rax, byte [rbp-21]; printExpression variable aIsGreater
	test rax, rax
	jnz .if58
	jmp .end_if58
.if58:
	sub rsp, 40
	mov rax, 0
	mov byte [rbp-23], al; LOOP k
.label9:
	mov rax, 5
	cmp byte [rbp-23], al; LOOP k
	jl .inside_label9
	jmp .not_label9
.inside_label9:
	sub rsp, 8
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-23]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_cards+rax*1]; printExpression array s_cards
	mov rax, r12
	mov byte [rbp-24], al; VAR_DECL_ASSIGN else variable toSwap
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 5; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-23]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 5; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-23]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_cards+rax*1]; printExpression array s_cards
	mov rax, r12
	pop r11
	mov byte [s_cards+r11*1], al; VAR_ASSIGNMENT ARRAY s_cards
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 5; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-23]; printExpression, right identifier, rbp variable k
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-24]; printExpression variable toSwap
	pop r11
	mov byte [s_cards+r11*1], al; VAR_ASSIGNMENT ARRAY s_cards
	add rsp, 8
.skip_label9:
	mov al, byte [rbp-23]; LOOP k
	inc rax
	mov byte [rbp-23], al; LOOP k
	jmp .label9
.not_label9:
	mov rax, qword [rbp-18]; printExpression variable j
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-20]; printExpression variable typeB
	pop r11
	mov byte [s_types+r11*1], al; VAR_ASSIGNMENT ARRAY s_types
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-19]; printExpression variable typeA
	pop r11
	mov byte [s_types+r11*1], al; VAR_ASSIGNMENT ARRAY s_types
	mov rax, qword [rbp-18]; printExpression variable j
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, word [s_bids+rax*2]; printExpression array s_bids
	mov rax, r12
	mov qword [rbp-31], rax; VAR_DECL_ASSIGN else variable toSwap
	mov rax, qword [rbp-18]; printExpression variable j
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, word [s_bids+rax*2]; printExpression array s_bids
	mov rax, r12
	pop r11
	mov word [s_bids+r11*2], ax; VAR_ASSIGNMENT ARRAY s_bids
	mov rax, qword [rbp-18]; printExpression, left identifier, rbp variable j
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-31]; printExpression variable toSwap
	pop r11
	mov word [s_bids+r11*2], ax; VAR_ASSIGNMENT ARRAY s_bids
	mov rax, 1
	mov byte [rbp-10], al; VAR_ASSIGNMENT else variable swapped
	add rsp, 40
	jmp .end_if58
.end_if58:
	add rsp, 32
	jmp .end_if54
.end_if54:
.end_if53:
	add rsp, 32
.skip_label6:
	mov rax, qword [rbp-18]; LOOP j
	inc rax
	mov qword [rbp-18], rax; LOOP j
	jmp .label6
.not_label6:
	movzx rax, byte [rbp-10]; printExpression !swapped
	xor rax, 1
	test rax, rax
	jnz .if59
	jmp .end_if59
.if59:
	jmp .not_label5
	jmp .end_if59
.end_if59:
	add rsp, 8
.skip_label5:
	mov rax, qword [rbp-9]; LOOP i
	inc rax
	mov qword [rbp-9], rax; LOOP i
	jmp .label5
.not_label5:
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
	sub rsp, 56
	mov rax, 0
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 1
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable parseCard
	mov rax, 0
	mov qword [rbp-25], rax; LOOP i
.label10:
	mov rax, qword [rbp-16]; printExpression variable length
	cmp qword [rbp-25], rax; LOOP i
	jl .inside_label10
	jmp .not_label10
.inside_label10:
	sub rsp, 8
	mov rax, qword [rbp-25]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 32; printExpression, right char ' '
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if60
	jmp .else_if60
.if60:
	sub rsp, 8
	mov rax, 0
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable parseCard
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	mov rbx, 5; printExpression, right int
	sub rax, rbx
	mov rdi, rax
	call GetType
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable type
	movzx rax, word [s_types_count]; printExpression global variable s_types_count
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-27]; printExpression variable type
	pop r11
	mov byte [s_types+r11*1], al; VAR_ASSIGNMENT ARRAY s_types
	movzx rax, word [s_types_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_types_count], ax; VAR_ASSIGNMENT else variable s_types_count
	add rsp, 8
	jmp .end_if60
.else_if60:
	movzx rax, byte [rbp-17]; printExpression variable parseCard
	test rax, rax
	jnz .if61
	jmp .else_if61
.if61:
	movzx rax, word [s_cards_count]; printExpression global variable s_cards_count
	cmp rax, 5000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-26]; printExpression variable byte
	pop r11
	mov byte [s_cards+r11*1], al; VAR_ASSIGNMENT ARRAY s_cards
	movzx rax, word [s_cards_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_cards_count], ax; VAR_ASSIGNMENT else variable s_cards_count
	jmp .end_if61
.else_if61:
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if62
	jmp .else_if62
.if62:
	mov rax, 1
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable parseCard
	jmp .end_if62
.else_if62:
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
	jnz .if63
	jmp .end_if63
.if63:
	sub rsp, 8
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-25]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	mov word [rbp-28], ax; VAR_DECL_ASSIGN else variable num
	mov rax, 0
	mov byte [rbp-29], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-30], al; LOOP j
.label11:
	mov rax, 20
	cmp byte [rbp-30], al; LOOP j
	jl .inside_label11
	jmp .not_label11
.inside_label11:
	sub rsp, 8
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-30]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-31], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable numByte
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
	jnz .if64
	jmp .else_if64
.if64:
	movzx rax, byte [rbp-29]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-29], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if64
.else_if64:
	jmp .not_label11
.end_if64:
	add rsp, 8
.skip_label11:
	mov al, byte [rbp-30]; LOOP j
	inc rax
	mov byte [rbp-30], al; LOOP j
	jmp .label11
.not_label11:
	movzx rax, byte [rbp-29]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov byte [rbp-29], al; VAR_ASSIGNMENT else variable numLength
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-29]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-25], rax; VAR_ASSIGNMENT else variable i
	movzx rax, word [s_bids_count]; printExpression global variable s_bids_count
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, word [rbp-28]; printExpression variable num
	pop r11
	mov word [s_bids+r11*2], ax; VAR_ASSIGNMENT ARRAY s_bids
	movzx rax, word [s_bids_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_bids_count], ax; VAR_ASSIGNMENT else variable s_bids_count
	add rsp, 8
	jmp .end_if63
.end_if63:
.end_if62:
.end_if61:
.end_if60:
	add rsp, 8
.skip_label10:
	mov rax, qword [rbp-25]; LOOP i
	inc rax
	mov qword [rbp-25], rax; LOOP i
	jmp .label10
.not_label10:
	mov rax, 1
	mov rdi, rax
	call Sort
	mov rax, 0
	mov qword [rbp-33], rax; LOOP i
.label12:
	movzx rax, word [s_bids_count]; printExpression global variable s_bids_count
	cmp qword [rbp-33], rax; LOOP i
	jl .inside_label12
	jmp .not_label12
.inside_label12:
	sub rsp, 40
	mov rax, qword [rbp-33]; printExpression variable i
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, word [s_bids+rax*2]; printExpression array s_bids
	mov rax, r12
	mov qword [rbp-41], rax; VAR_DECL_ASSIGN else variable bid
	mov rax, qword [rbp-33]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-41]; printExpression, right identifier, rbp variable bid
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable sum
	add rsp, 40
.skip_label12:
	mov rax, qword [rbp-33]; LOOP i
	inc rax
	mov qword [rbp-33], rax; LOOP i
	jmp .label12
.not_label12:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str9
	mov rdx, 23
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-8]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	add rsp, 56
	jmp .exit
	add rsp, 56
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
	sub rsp, 56
	mov rax, 0
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable sum
	mov rax, qword rdi; printExpression variable size
	mov qword [rbp-16], rax; VAR_DECL_ASSIGN else variable length
	mov rax, 1
	mov byte [rbp-17], al; VAR_DECL_ASSIGN else variable parseCard
	mov rax, 0
	mov qword [rbp-25], rax; LOOP i
.label13:
	mov rax, qword [rbp-16]; printExpression variable length
	cmp qword [rbp-25], rax; LOOP i
	jl .inside_label13
	jmp .not_label13
.inside_label13:
	sub rsp, 8
	mov rax, qword [rbp-25]; printExpression variable i
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-26], al; VAR_DECL_ASSIGN else variable byte
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 32; printExpression, right char ' '
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if65
	jmp .else_if65
.if65:
	sub rsp, 8
	mov rax, 0
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable parseCard
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	mov rbx, 5; printExpression, right int
	sub rax, rbx
	mov rdi, rax
	call GetTypeP2
	mov byte [rbp-27], al; VAR_DECL_ASSIGN else variable type
	movzx rax, word [s_types_count]; printExpression global variable s_types_count
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-27]; printExpression variable type
	pop r11
	mov byte [s_types+r11*1], al; VAR_ASSIGNMENT ARRAY s_types
	movzx rax, word [s_types_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_types_count], ax; VAR_ASSIGNMENT else variable s_types_count
	add rsp, 8
	jmp .end_if65
.else_if65:
	movzx rax, byte [rbp-17]; printExpression variable parseCard
	test rax, rax
	jnz .if66
	jmp .else_if66
.if66:
	movzx rax, word [s_cards_count]; printExpression global variable s_cards_count
	cmp rax, 5000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, byte [rbp-26]; printExpression variable byte
	pop r11
	mov byte [s_cards+r11*1], al; VAR_ASSIGNMENT ARRAY s_cards
	movzx rax, word [s_cards_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_cards_count], ax; VAR_ASSIGNMENT else variable s_cards_count
	jmp .end_if66
.else_if66:
	movzx rax, byte [rbp-26]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if67
	jmp .else_if67
.if67:
	mov rax, 1
	mov byte [rbp-17], al; VAR_ASSIGNMENT else variable parseCard
	jmp .end_if67
.else_if67:
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
	jnz .if68
	jmp .end_if68
.if68:
	sub rsp, 8
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-25]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	mov word [rbp-28], ax; VAR_DECL_ASSIGN else variable num
	mov rax, 0
	mov byte [rbp-29], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-30], al; LOOP j
.label14:
	mov rax, 20
	cmp byte [rbp-30], al; LOOP j
	jl .inside_label14
	jmp .not_label14
.inside_label14:
	sub rsp, 8
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-30]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 10000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-31], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-31]; printExpression, left identifier, rbp variable numByte
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
	jnz .if69
	jmp .else_if69
.if69:
	movzx rax, byte [rbp-29]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-29], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if69
.else_if69:
	jmp .not_label14
.end_if69:
	add rsp, 8
.skip_label14:
	mov al, byte [rbp-30]; LOOP j
	inc rax
	mov byte [rbp-30], al; LOOP j
	jmp .label14
.not_label14:
	movzx rax, byte [rbp-29]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov byte [rbp-29], al; VAR_ASSIGNMENT else variable numLength
	mov rax, qword [rbp-25]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-29]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-25], rax; VAR_ASSIGNMENT else variable i
	movzx rax, word [s_bids_count]; printExpression global variable s_bids_count
	cmp rax, 1000; check bounds	jge array_out_of_bounds
	push rax
	movzx rax, word [rbp-28]; printExpression variable num
	pop r11
	mov word [s_bids+r11*2], ax; VAR_ASSIGNMENT ARRAY s_bids
	movzx rax, word [s_bids_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_bids_count], ax; VAR_ASSIGNMENT else variable s_bids_count
	add rsp, 8
	jmp .end_if68
.end_if68:
.end_if67:
.end_if66:
.end_if65:
	add rsp, 8
.skip_label13:
	mov rax, qword [rbp-25]; LOOP i
	inc rax
	mov qword [rbp-25], rax; LOOP i
	jmp .label13
.not_label13:
	mov rax, 0
	mov rdi, rax
	call Sort
	mov rax, 0
	mov qword [rbp-33], rax; LOOP i
.label15:
	movzx rax, word [s_bids_count]; printExpression global variable s_bids_count
	cmp qword [rbp-33], rax; LOOP i
	jl .inside_label15
	jmp .not_label15
.inside_label15:
	sub rsp, 40
	mov rax, 0
	mov byte [rbp-34], al; LOOP j
.label16:
	mov rax, 5
	cmp byte [rbp-34], al; LOOP j
	jl .inside_label16
	jmp .not_label16
.inside_label16:
	sub rsp, 8
	mov rax, qword [rbp-33]; printExpression, left identifier, rbp variable i
	mov rbx, 5; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	movzx rbx, byte [rbp-34]; printExpression, right identifier, rbp variable j
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 5000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_cards+rax*1]; printExpression array s_cards
	mov rax, r12
	mov byte [rbp-35], al; VAR_DECL_ASSIGN else variable byte
; =============== FUNC CALL + VARIABLE ===============
	mov rax, 1
	mov rdi, 1
	lea rsi, [rbp-35]
	mov rdx, 1
	syscall
; =============== END FUNC CALL + VARIABLE ===============
	add rsp, 8
.skip_label16:
	mov al, byte [rbp-34]; LOOP j
	inc rax
	mov byte [rbp-34], al; LOOP j
	jmp .label16
.not_label16:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 1
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-33]; printExpression variable i
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, word [s_bids+rax*2]; printExpression array s_bids
	mov rax, r12
	mov qword [rbp-42], rax; VAR_DECL_ASSIGN else variable bid
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-42]; variable bid
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, qword [rbp-33]; printExpression variable i
	cmp rax, 1000; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_types+rax*1]; printExpression array s_types
	mov rax, r12
	mov byte [rbp-43], al; VAR_DECL_ASSIGN else variable type
	movzx rax, byte [rbp-43]; printExpression variable type
	mov rdi, rax
	call PrintType
	mov rax, qword [rbp-33]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-42]; printExpression, right identifier, rbp variable bid
	pop rax; printExpression, leftPrinted, recover left
	mul qword rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable sum
	add rax, rbx
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable sum
	add rsp, 40
.skip_label15:
	mov rax, qword [rbp-33]; LOOP i
	inc rax
	mov qword [rbp-33], rax; LOOP i
	jmp .label15
.not_label15:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str11
	mov rdx, 23
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-8]; variable sum
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, 0
	add rsp, 56
	jmp .exit
	add rsp, 56
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
	jnz .if70
	jmp .end_if70
.if70:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str12
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if70
.end_if70:
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 10000
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
	jnz .if71
	jmp .end_if71
.if71:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str13
	mov rdx, 25
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if71
.end_if71:
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
