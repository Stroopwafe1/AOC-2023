section .data
	Array_OOB: db "Array index out of bounds!",0xA,0
	str0: db "Seed: ",0
	str1: db " is on soil ",0
	str2: db " and has fertilizer ",0
	str3: db ", water ",0
	str4: db ", light ",0
	str5: db ", temperature ",0
	str6: db ", humidity ",0
	str7: db ", location ",0
	str8: db "Lowest location part 1: ",0
	str9: db "Lowest location part 2: ",0
	str10: db "Could not open file",0xA,0
	str11: db "Could not read from file",0xA,0
	s_fertilizer_to_water_count dw 0
	s_humidity_to_location_count dw 0
	s_light_to_temperature_count dw 0
	s_seed_count dw 0
	s_seeds_to_soil_count dw 0
	s_soil_to_fertilizer_count dw 0
	s_temperature_to_humidity_count dw 0
	s_water_to_light_count dw 0
section .bss
	s_buffer resb 6150
	s_fertilizer_to_water resq 48
	s_humidity_to_location resq 78
	s_light_to_temperature resq 141
	s_seeds resq 20
	s_seeds_to_soil resq 36
	s_soil_to_fertilizer resq 63
	s_temperature_to_humidity resq 69
	s_water_to_light resq 135

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

global GetSoil
GetSoil:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable seed
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-16], rax; LOOP i
.label1:
	movzx rax, word [s_seeds_to_soil_count]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP i
	jl .inside_label1
	jmp .not_label1
.inside_label1:
	sub rsp, 56
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	cmp rax, 36; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_seeds_to_soil+rax*8]; printExpression array s_seeds_to_soil
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable destination
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 36; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_seeds_to_soil+rax*8]; printExpression array s_seeds_to_soil
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable source
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 36; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_seeds_to_soil+rax*8]; printExpression array s_seeds_to_soil
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable source
	mov rbx, qword [rbp-40]; printExpression, right identifier, rbp variable range
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if1
	jmp .end_if1
.if1:
	sub rsp, 40
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	sub rax, rbx
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable destination
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	add rsp, 136
	jmp .exit
	add rsp, 40
	jmp .end_if1
.end_if1:
	add rsp, 56
.skip_label1:
	mov rax, qword [rbp-16]; LOOP i
	inc rax
	mov qword [rbp-16], rax; LOOP i
	jmp .label1
.not_label1:
	mov rax, qword [rbp-8]; printExpression variable returnValue
	add rsp, 40
	jmp .exit
	add rsp, 40
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetFertilizer
GetFertilizer:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable soil
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-16], rax; LOOP i
.label2:
	movzx rax, word [s_soil_to_fertilizer_count]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP i
	jl .inside_label2
	jmp .not_label2
.inside_label2:
	sub rsp, 56
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	cmp rax, 63; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_soil_to_fertilizer+rax*8]; printExpression array s_soil_to_fertilizer
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable destination
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 63; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_soil_to_fertilizer+rax*8]; printExpression array s_soil_to_fertilizer
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable source
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 63; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_soil_to_fertilizer+rax*8]; printExpression array s_soil_to_fertilizer
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable source
	mov rbx, qword [rbp-40]; printExpression, right identifier, rbp variable range
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if2
	jmp .end_if2
.if2:
	sub rsp, 40
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	sub rax, rbx
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable destination
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	add rsp, 136
	jmp .exit
	add rsp, 40
	jmp .end_if2
.end_if2:
	add rsp, 56
.skip_label2:
	mov rax, qword [rbp-16]; LOOP i
	inc rax
	mov qword [rbp-16], rax; LOOP i
	jmp .label2
.not_label2:
	mov rax, qword [rbp-8]; printExpression variable returnValue
	add rsp, 40
	jmp .exit
	add rsp, 40
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetWater
GetWater:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable fert
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-16], rax; LOOP i
.label3:
	movzx rax, word [s_fertilizer_to_water_count]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP i
	jl .inside_label3
	jmp .not_label3
.inside_label3:
	sub rsp, 56
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	cmp rax, 48; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_fertilizer_to_water+rax*8]; printExpression array s_fertilizer_to_water
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable destination
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 48; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_fertilizer_to_water+rax*8]; printExpression array s_fertilizer_to_water
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable source
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 48; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_fertilizer_to_water+rax*8]; printExpression array s_fertilizer_to_water
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable source
	mov rbx, qword [rbp-40]; printExpression, right identifier, rbp variable range
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if3
	jmp .end_if3
.if3:
	sub rsp, 40
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	sub rax, rbx
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable destination
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	add rsp, 136
	jmp .exit
	add rsp, 40
	jmp .end_if3
.end_if3:
	add rsp, 56
.skip_label3:
	mov rax, qword [rbp-16]; LOOP i
	inc rax
	mov qword [rbp-16], rax; LOOP i
	jmp .label3
.not_label3:
	mov rax, qword [rbp-8]; printExpression variable returnValue
	add rsp, 40
	jmp .exit
	add rsp, 40
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetLight
GetLight:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable water
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-16], rax; LOOP i
.label4:
	movzx rax, word [s_water_to_light_count]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP i
	jl .inside_label4
	jmp .not_label4
.inside_label4:
	sub rsp, 56
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	cmp rax, 135; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_water_to_light+rax*8]; printExpression array s_water_to_light
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable destination
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 135; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_water_to_light+rax*8]; printExpression array s_water_to_light
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable source
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 135; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_water_to_light+rax*8]; printExpression array s_water_to_light
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable source
	mov rbx, qword [rbp-40]; printExpression, right identifier, rbp variable range
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if4
	jmp .end_if4
.if4:
	sub rsp, 40
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	sub rax, rbx
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable destination
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	add rsp, 136
	jmp .exit
	add rsp, 40
	jmp .end_if4
.end_if4:
	add rsp, 56
.skip_label4:
	mov rax, qword [rbp-16]; LOOP i
	inc rax
	mov qword [rbp-16], rax; LOOP i
	jmp .label4
.not_label4:
	mov rax, qword [rbp-8]; printExpression variable returnValue
	add rsp, 40
	jmp .exit
	add rsp, 40
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetTemp
GetTemp:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable light
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-16], rax; LOOP i
.label5:
	movzx rax, word [s_light_to_temperature_count]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP i
	jl .inside_label5
	jmp .not_label5
.inside_label5:
	sub rsp, 56
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	cmp rax, 141; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_light_to_temperature+rax*8]; printExpression array s_light_to_temperature
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable destination
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 141; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_light_to_temperature+rax*8]; printExpression array s_light_to_temperature
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable source
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 141; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_light_to_temperature+rax*8]; printExpression array s_light_to_temperature
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable source
	mov rbx, qword [rbp-40]; printExpression, right identifier, rbp variable range
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if5
	jmp .end_if5
.if5:
	sub rsp, 40
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	sub rax, rbx
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable destination
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	add rsp, 136
	jmp .exit
	add rsp, 40
	jmp .end_if5
.end_if5:
	add rsp, 56
.skip_label5:
	mov rax, qword [rbp-16]; LOOP i
	inc rax
	mov qword [rbp-16], rax; LOOP i
	jmp .label5
.not_label5:
	mov rax, qword [rbp-8]; printExpression variable returnValue
	add rsp, 40
	jmp .exit
	add rsp, 40
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetHumidity
GetHumidity:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable temp
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-16], rax; LOOP i
.label6:
	movzx rax, word [s_temperature_to_humidity_count]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP i
	jl .inside_label6
	jmp .not_label6
.inside_label6:
	sub rsp, 56
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	cmp rax, 69; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_temperature_to_humidity+rax*8]; printExpression array s_temperature_to_humidity
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable destination
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 69; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_temperature_to_humidity+rax*8]; printExpression array s_temperature_to_humidity
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable source
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 69; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_temperature_to_humidity+rax*8]; printExpression array s_temperature_to_humidity
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable source
	mov rbx, qword [rbp-40]; printExpression, right identifier, rbp variable range
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if6
	jmp .end_if6
.if6:
	sub rsp, 40
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	sub rax, rbx
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable destination
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	add rsp, 136
	jmp .exit
	add rsp, 40
	jmp .end_if6
.end_if6:
	add rsp, 56
.skip_label6:
	mov rax, qword [rbp-16]; LOOP i
	inc rax
	mov qword [rbp-16], rax; LOOP i
	jmp .label6
.not_label6:
	mov rax, qword [rbp-8]; printExpression variable returnValue
	add rsp, 40
	jmp .exit
	add rsp, 40
.exit:
; =============== EPILOGUE ===============
	mov rsp, rbp
	pop rbp
	ret
; =============== END EPILOGUE ===============

global GetLocation
GetLocation:
; =============== PROLOGUE ===============
	push rbp
	mov rbp, rsp
; =============== END PROLOGUE ===============
	sub rsp, 40
	mov rax, qword rdi; printExpression variable humidity
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable returnValue
	mov rax, 0
	mov qword [rbp-16], rax; LOOP i
.label7:
	movzx rax, word [s_humidity_to_location_count]; printExpression, left identifier, not rbp
	mov rbx, 3; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP i
	jl .inside_label7
	jmp .not_label7
.inside_label7:
	sub rsp, 56
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	cmp rax, 78; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_humidity_to_location+rax*8]; printExpression array s_humidity_to_location
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable destination
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 78; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_humidity_to_location+rax*8]; printExpression array s_humidity_to_location
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable source
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable i
	mov rbx, 3; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 2; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 78; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_humidity_to_location+rax*8]; printExpression array s_humidity_to_location
	mov rax, r12
	mov qword [rbp-40], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	mov rax, qword [rbp-32]; printExpression, left identifier, rbp variable source
	mov rbx, qword [rbp-40]; printExpression, right identifier, rbp variable range
	add rax, rbx
	mov rbx, rax; printExpression, nodeType=1
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and rax, rbx
	test rax, rax
	jnz .if7
	jmp .end_if7
.if7:
	sub rsp, 40
	mov rax, qword [rbp-8]; printExpression, left identifier, rbp variable returnValue
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable source
	sub rax, rbx
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable offset
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable destination
	mov rbx, qword [rbp-48]; printExpression, right identifier, rbp variable offset
	add rax, rbx
	add rsp, 136
	jmp .exit
	add rsp, 40
	jmp .end_if7
.end_if7:
	add rsp, 56
.skip_label7:
	mov rax, qword [rbp-16]; LOOP i
	inc rax
	mov qword [rbp-16], rax; LOOP i
	jmp .label7
.not_label7:
	mov rax, qword [rbp-8]; printExpression variable returnValue
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
	mov byte [rbp-9], al; VAR_DECL_ASSIGN else variable parsingMapCount
	mov rax, 0
	mov qword [rbp-17], rax; LOOP i
.label8:
	mov rax, qword [rbp-8]; printExpression variable length
	cmp qword [rbp-17], rax; LOOP i
	jl .inside_label8
	jmp .not_label8
.inside_label8:
	sub rsp, 8
	mov rax, qword [rbp-17]; printExpression variable i
	cmp rax, 6150; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-18], al; VAR_DECL_ASSIGN else variable byte
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	mov rbx, 1; printExpression, right int
	add rax, rbx
	cmp rax, 6150; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-19], al; VAR_DECL_ASSIGN else variable nextByte
	movzx rax, byte [rbp-18]; printExpression, left identifier, rbp variable byte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-19]; printExpression, left identifier, rbp variable nextByte
	mov rbx, 10; printExpression, right char '\n'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	mov rbx, rax; printExpression, nodeType=1
	pop rax; printExpression, leftPrinted, recover left
	and ax, bx
	test rax, rax
	jnz .if8
	jmp .end_if8
.if8:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-9], al; VAR_ASSIGNMENT else variable parsingMapCount
	jmp .end_if8
.end_if8:
	movzx rax, byte [rbp-18]; printExpression, left identifier, rbp variable byte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-18]; printExpression, left identifier, rbp variable byte
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
	jmp .end_if9
.if9:
	sub rsp, 16
	lea rax, [s_buffer]; printExpression variable s_buffer
	push rax; printExpression, leftPrinted, save left
	mov rbx, qword [rbp-17]; printExpression, right identifier, rbp variable i
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	mov rdi, rax
	call find_ui64_in_string
	mov qword [rbp-27], rax; VAR_DECL_ASSIGN else variable num
	mov rax, 0
	mov byte [rbp-28], al; VAR_DECL_ASSIGN else variable numLength
	mov rax, 0
	mov byte [rbp-29], al; LOOP j
.label9:
	mov rax, 20
	cmp byte [rbp-29], al; LOOP j
	jl .inside_label9
	jmp .not_label9
.inside_label9:
	sub rsp, 8
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-29]; printExpression, right identifier, rbp variable j
	add rax, rbx
	cmp rax, 6150; check bounds
	jge array_out_of_bounds
	movzx r12, byte [s_buffer+rax*1]; printExpression array s_buffer
	mov rax, r12
	mov byte [rbp-30], al; VAR_DECL_ASSIGN else variable numByte
	movzx rax, byte [rbp-30]; printExpression, left identifier, rbp variable numByte
	mov rbx, 48; printExpression, right char '0'
	mov rcx, 0
	mov rdx, 1
	cmp ax, bx
	cmovge rcx, rdx
	mov rax, rcx; printConditionalMove
	push rax; printExpression, leftPrinted, save left
	movzx rax, byte [rbp-30]; printExpression, left identifier, rbp variable numByte
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
	jnz .if10
	jmp .else_if10
.if10:
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	add al, bl
	mov byte [rbp-28], al; VAR_ASSIGNMENT else variable numLength
	jmp .end_if10
.else_if10:
	jmp .not_label9
.end_if10:
	add rsp, 8
.skip_label9:
	mov al, byte [rbp-29]; LOOP j
	inc rax
	mov byte [rbp-29], al; LOOP j
	jmp .label9
.not_label9:
	movzx rax, byte [rbp-28]; printExpression, left identifier, rbp variable numLength
	mov rbx, 1; printExpression, right int
	sub ax, bx
	mov byte [rbp-28], al; VAR_ASSIGNMENT else variable numLength
	mov rax, qword [rbp-17]; printExpression, left identifier, rbp variable i
	movzx rbx, byte [rbp-28]; printExpression, right identifier, rbp variable numLength
	add rax, rbx
	mov qword [rbp-17], rax; VAR_ASSIGNMENT else variable i
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 0; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if11
	jmp .else_if11
.if11:
	movzx rax, word [s_seed_count]; printExpression global variable s_seed_count
	cmp rax, 20; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_seeds+r11*8], rax; VAR_ASSIGNMENT ARRAY s_seeds
	movzx rax, word [s_seed_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_seed_count], ax; VAR_ASSIGNMENT else variable s_seed_count
	jmp .end_if11
.else_if11:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 1; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if12
	jmp .else_if12
.if12:
	movzx rax, word [s_seeds_to_soil_count]; printExpression global variable s_seeds_to_soil_count
	cmp rax, 36; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_seeds_to_soil+r11*8], rax; VAR_ASSIGNMENT ARRAY s_seeds_to_soil
	movzx rax, word [s_seeds_to_soil_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_seeds_to_soil_count], ax; VAR_ASSIGNMENT else variable s_seeds_to_soil_count
	jmp .end_if12
.else_if12:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 2; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if13
	jmp .else_if13
.if13:
	movzx rax, word [s_soil_to_fertilizer_count]; printExpression global variable s_soil_to_fertilizer_count
	cmp rax, 63; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_soil_to_fertilizer+r11*8], rax; VAR_ASSIGNMENT ARRAY s_soil_to_fertilizer
	movzx rax, word [s_soil_to_fertilizer_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_soil_to_fertilizer_count], ax; VAR_ASSIGNMENT else variable s_soil_to_fertilizer_count
	jmp .end_if13
.else_if13:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 3; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if14
	jmp .else_if14
.if14:
	movzx rax, word [s_fertilizer_to_water_count]; printExpression global variable s_fertilizer_to_water_count
	cmp rax, 48; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_fertilizer_to_water+r11*8], rax; VAR_ASSIGNMENT ARRAY s_fertilizer_to_water
	movzx rax, word [s_fertilizer_to_water_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_fertilizer_to_water_count], ax; VAR_ASSIGNMENT else variable s_fertilizer_to_water_count
	jmp .end_if14
.else_if14:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 4; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if15
	jmp .else_if15
.if15:
	movzx rax, word [s_water_to_light_count]; printExpression global variable s_water_to_light_count
	cmp rax, 135; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_water_to_light+r11*8], rax; VAR_ASSIGNMENT ARRAY s_water_to_light
	movzx rax, word [s_water_to_light_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_water_to_light_count], ax; VAR_ASSIGNMENT else variable s_water_to_light_count
	jmp .end_if15
.else_if15:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 5; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if16
	jmp .else_if16
.if16:
	movzx rax, word [s_light_to_temperature_count]; printExpression global variable s_light_to_temperature_count
	cmp rax, 141; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_light_to_temperature+r11*8], rax; VAR_ASSIGNMENT ARRAY s_light_to_temperature
	movzx rax, word [s_light_to_temperature_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_light_to_temperature_count], ax; VAR_ASSIGNMENT else variable s_light_to_temperature_count
	jmp .end_if16
.else_if16:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 6; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if17
	jmp .else_if17
.if17:
	movzx rax, word [s_temperature_to_humidity_count]; printExpression global variable s_temperature_to_humidity_count
	cmp rax, 69; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_temperature_to_humidity+r11*8], rax; VAR_ASSIGNMENT ARRAY s_temperature_to_humidity
	movzx rax, word [s_temperature_to_humidity_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_temperature_to_humidity_count], ax; VAR_ASSIGNMENT else variable s_temperature_to_humidity_count
	jmp .end_if17
.else_if17:
	movzx rax, byte [rbp-9]; printExpression, left identifier, rbp variable parsingMapCount
	mov rbx, 7; printExpression, right int
	mov rcx, 0
	mov rdx, 1
	cmp al, bl
	cmove rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if18
	jmp .end_if18
.if18:
	movzx rax, word [s_humidity_to_location_count]; printExpression global variable s_humidity_to_location_count
	cmp rax, 78; check bounds	jge array_out_of_bounds
	push rax
	mov rax, qword [rbp-27]; printExpression variable num
	pop r11
	mov qword [s_humidity_to_location+r11*8], rax; VAR_ASSIGNMENT ARRAY s_humidity_to_location
	movzx rax, word [s_humidity_to_location_count]; printExpression, left identifier, not rbp
	mov rbx, 1; printExpression, right int
	add ax, bx
	mov word [s_humidity_to_location_count], ax; VAR_ASSIGNMENT else variable s_humidity_to_location_count
	jmp .end_if18
.end_if18:
.end_if17:
.end_if16:
.end_if15:
.end_if14:
.end_if13:
.end_if12:
.end_if11:
	add rsp, 16
	jmp .end_if9
.end_if9:
	add rsp, 8
.skip_label8:
	mov rax, qword [rbp-17]; LOOP i
	inc rax
	mov qword [rbp-17], rax; LOOP i
	jmp .label8
.not_label8:
	mov rax, 12345678900000
	mov qword [rbp-25], rax; VAR_DECL_ASSIGN else variable lowestLocation
	mov rax, 0
	mov qword [rbp-33], rax; LOOP i
.label10:
	movzx rax, word [s_seed_count]; printExpression global variable s_seed_count
	cmp qword [rbp-33], rax; LOOP i
	jl .inside_label10
	jmp .not_label10
.inside_label10:
	sub rsp, 72
	mov rax, qword [rbp-33]; printExpression variable i
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_seeds+rax*8]; printExpression array s_seeds
	mov rax, r12
	mov qword [rbp-41], rax; VAR_DECL_ASSIGN else variable seed
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str0
	mov rdx, 6
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-41]; variable seed
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str1
	mov rdx, 12
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-41]; printExpression variable seed
	mov rdi, rax
	call GetSoil
	mov qword [rbp-49], rax; VAR_DECL_ASSIGN else variable soil
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-49]; variable soil
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str2
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-49]; printExpression variable soil
	mov rdi, rax
	call GetFertilizer
	mov qword [rbp-57], rax; VAR_DECL_ASSIGN else variable fert
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-57]; variable fert
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str3
	mov rdx, 8
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-57]; printExpression variable fert
	mov rdi, rax
	call GetWater
	mov qword [rbp-65], rax; VAR_DECL_ASSIGN else variable water
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-65]; variable water
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str4
	mov rdx, 8
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-65]; printExpression variable water
	mov rdi, rax
	call GetLight
	mov qword [rbp-73], rax; VAR_DECL_ASSIGN else variable light
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-73]; variable light
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str5
	mov rdx, 14
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-73]; printExpression variable light
	mov rdi, rax
	call GetTemp
	mov qword [rbp-81], rax; VAR_DECL_ASSIGN else variable temp
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-81]; variable temp
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str6
	mov rdx, 11
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-81]; printExpression variable temp
	mov rdi, rax
	call GetHumidity
	mov qword [rbp-89], rax; VAR_DECL_ASSIGN else variable humidity
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-89]; variable humidity
	call print_ui64
; =============== END FUNC CALL + VARIABLE ===============
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str7
	mov rdx, 11
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, qword [rbp-89]; printExpression variable humidity
	mov rdi, rax
	call GetLocation
	mov qword [rbp-97], rax; VAR_DECL_ASSIGN else variable location
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-97]; variable location
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
	mov rax, qword [rbp-97]; printExpression, left identifier, rbp variable location
	mov rbx, qword [rbp-25]; printExpression, right identifier, rbp variable lowestLocation
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if19
	jmp .end_if19
.if19:
	mov rax, qword [rbp-97]; printExpression variable location
	mov qword [rbp-25], rax; VAR_ASSIGNMENT else variable lowestLocation
	jmp .end_if19
.end_if19:
	add rsp, 72
.skip_label10:
	mov rax, qword [rbp-33]; LOOP i
	inc rax
	mov qword [rbp-33], rax; LOOP i
	jmp .label10
.not_label10:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str8
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-25]; variable lowestLocation
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
	sub rsp, 32
	mov rax, 12345678900000
	mov qword [rbp-8], rax; VAR_DECL_ASSIGN else variable lowestLocation
	mov rax, 0
	mov qword [rbp-16], rax; LOOP j
.label11:
	movzx rax, word [s_seed_count]; printExpression, left identifier, not rbp
	mov rbx, 2; printExpression, right int
	cwd
	xor rdx, rdx; Clearing rdx for division
	div ax, bx
	cmp qword [rbp-16], rax; LOOP j
	jl .inside_label11
	jmp .not_label11
.inside_label11:
	sub rsp, 40
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable j
	mov rbx, 2; printExpression, right int
	mul qword rbx
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_seeds+rax*8]; printExpression array s_seeds
	mov rax, r12
	mov qword [rbp-24], rax; VAR_DECL_ASSIGN else variable start
	mov rax, qword [rbp-16]; printExpression, left identifier, rbp variable j
	mov rbx, 2; printExpression, right int
	mul qword rbx
	push rax; printExpression, leftPrinted, save left
	mov rbx, 1; printExpression, right int
	pop rax; printExpression, leftPrinted, recover left
	add rax, rbx
	cmp rax, 20; check bounds
	jge array_out_of_bounds
	mov r12, qword [s_seeds+rax*8]; printExpression array s_seeds
	mov rax, r12
	mov qword [rbp-32], rax; VAR_DECL_ASSIGN else variable range
	mov rax, qword [rbp-24]; printExpression variable start
	mov qword [rbp-40], rax; LOOP i
.label12:
	mov rax, qword [rbp-24]; printExpression, left identifier, rbp variable start
	mov rbx, qword [rbp-32]; printExpression, right identifier, rbp variable range
	add rax, rbx
	cmp qword [rbp-40], rax; LOOP i
	jl .inside_label12
	jmp .not_label12
.inside_label12:
	sub rsp, 72
	mov rax, qword [rbp-40]; printExpression variable i
	mov qword [rbp-48], rax; VAR_DECL_ASSIGN else variable seed
	mov rax, qword [rbp-48]; printExpression variable seed
	mov rdi, rax
	call GetSoil
	mov qword [rbp-56], rax; VAR_DECL_ASSIGN else variable soil
	mov rax, qword [rbp-56]; printExpression variable soil
	mov rdi, rax
	call GetFertilizer
	mov qword [rbp-64], rax; VAR_DECL_ASSIGN else variable fert
	mov rax, qword [rbp-64]; printExpression variable fert
	mov rdi, rax
	call GetWater
	mov qword [rbp-72], rax; VAR_DECL_ASSIGN else variable water
	mov rax, qword [rbp-72]; printExpression variable water
	mov rdi, rax
	call GetLight
	mov qword [rbp-80], rax; VAR_DECL_ASSIGN else variable light
	mov rax, qword [rbp-80]; printExpression variable light
	mov rdi, rax
	call GetTemp
	mov qword [rbp-88], rax; VAR_DECL_ASSIGN else variable temp
	mov rax, qword [rbp-88]; printExpression variable temp
	mov rdi, rax
	call GetHumidity
	mov qword [rbp-96], rax; VAR_DECL_ASSIGN else variable humidity
	mov rax, qword [rbp-96]; printExpression variable humidity
	mov rdi, rax
	call GetLocation
	mov qword [rbp-104], rax; VAR_DECL_ASSIGN else variable location
	mov rax, qword [rbp-104]; printExpression, left identifier, rbp variable location
	mov rbx, qword [rbp-8]; printExpression, right identifier, rbp variable lowestLocation
	mov rcx, 0
	mov rdx, 1
	cmp rax, rbx
	cmovl rcx, rdx
	mov rax, rcx; printConditionalMove
	test rax, rax
	jnz .if20
	jmp .end_if20
.if20:
	mov rax, qword [rbp-104]; printExpression variable location
	mov qword [rbp-8], rax; VAR_ASSIGNMENT else variable lowestLocation
	jmp .end_if20
.end_if20:
	add rsp, 72
.skip_label12:
	mov rax, qword [rbp-40]; LOOP i
	inc rax
	mov qword [rbp-40], rax; LOOP i
	jmp .label12
.not_label12:
	add rsp, 40
.skip_label11:
	mov rax, qword [rbp-16]; LOOP j
	inc rax
	mov qword [rbp-16], rax; LOOP j
	jmp .label11
.not_label11:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str9
	mov rdx, 24
	syscall
; =============== END FUNC CALL + STRING ===============
; =============== FUNC CALL + VARIABLE ===============
	mov rdi, qword [rbp-8]; variable lowestLocation
	call print_ui64_newline
; =============== END FUNC CALL + VARIABLE ===============
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
	jnz .if21
	jmp .end_if21
.if21:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str10
	mov rdx, 20
	syscall
; =============== END FUNC CALL + STRING ===============
	mov rax, -1
	add rsp, 16
	jmp .exit
	jmp .end_if21
.end_if21:
	movsxd rax, dword [rbp-4]; printExpression variable fd
	mov rdi, rax
	lea rax, [s_buffer]; printExpression variable s_buffer
	mov rsi, rax
	mov rax, 6145
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
	jnz .if22
	jmp .end_if22
.if22:
; =============== FUNC CALL + STRING ===============
	mov rax, 1
	mov rdi, 1
	mov rsi, str11
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
	mov rax, qword [rbp-12]; printExpression variable size
	mov rdi, rax
	call Part2
	mov rax, 0
	mov rdi, rax
	add rsp, 16
.exit:
	mov rax, 60
	syscall
