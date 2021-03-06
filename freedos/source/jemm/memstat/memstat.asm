
;*** get extended memory status using int 15h
;*** AH=88h
;*** AX=E801h
;*** AX=E820h

	.286
	.model small
	.386

printf proto c :ptr byte, :VARARG

CStr macro text:VARARG
local sym
	.const
sym db text,0
	.code
	exitm <offset sym>
	endm

I15C7S struct
wSize	dw ?
dwLBelow16 dd ?
dwLAbove16 dd ?
dwSBelow16 dd ?
dwSAbove16 dd ?
dwCBelow16 dd ?
dwCAbove16 dd ?
dwXBelow16 dd ?
dwXAbove16 dd ?
wUMB	dw ?
wFree	dw ?
		dd ?
I15C7S ends


	.data?

buffer	db 20h dup (?)
i15c7	I15C7S <?>

	.code

	include printf.inc

;*** main()

main proc c

	stc
	mov ah,0C0h
	int 15h
	jnc @F
	invoke printf, CStr(<"Int 15h, ah=C0h failed",10>)
	jmp no15c0
@@:
	cmp word ptr es:[bx],7
	jb no15c0
	mov al,es:[bx+6]
	test al,10h
	jz no15c7
	mov ah,0C7h
	mov si,offset i15c7
	int 15h
	jc no15c7
	invoke printf, CStr(<"Int 15h, ah=C7h:",10>)
	invoke printf, CStr(<"Local memory (1 MB-16 MB/16 MB-4 GB): %08lX/%08lX kB",10>),\
		i15c7.dwLBelow16, i15c7.dwLAbove16
	invoke printf, CStr(<"System memory (1 MB-16 MB/16 MB-4 GB): %08lX/%08lX kB",10>),\
		i15c7.dwSBelow16, i15c7.dwSAbove16
	invoke printf, CStr(<"Cacheable memory (1 MB-16 MB/16 MB-4 GB): %08lX/%08lX kB",10>),\
		i15c7.dwCBelow16, i15c7.dwCAbove16
no15c7:
no15c0:
	clc
	mov ax,8800h
	int 15h
	jnc @F
	invoke printf, CStr(<"Int 15h, ah=88h failed",10>)
	jmp done_88
@@:
	invoke printf, CStr(<"Int 15h, ah=88h, extended memory: %u kB",10>), ax
done_88:
	xor cx,cx
	xor dx,dx
	xor bx,bx
	mov ax,0E801h
	clc			;the carry flag is not reliably set/reset!
	int 15h
	jc error
	and bx, bx
	jnz @F
	and cx, cx
	jnz @F
error:
	invoke printf, CStr(<"Int 15h, ax=E801h failed",10>)
	jmp done_e801
@@:
	.if (!ax)			;some bioses return values in CX:DX
		mov ax, cx
		mov bx, dx
	.endif

	push bx
	push ax
	invoke printf, CStr(<"Int 15h, ax=E801h:",10>)
	pop ax
	.if (ax > 3C00h)
	   invoke printf, CStr(<"ext. memory below 16 MB: %u (0x%X) KB ???",10>), ax, ax
	.else
	   invoke printf, CStr(<"ext. memory below 16 MB: %u (0x%X) KB",10>), ax, ax
	.endif
	pop bx
	mov edx, 1000000h
	mov ax, bx
	movzx ecx, bx
	shl ecx, 16
	add ecx, edx
	dec ecx

	shr ax, 4
	invoke printf, CStr(<"ext. memory above 16 MB: %u 64 KB blocks = %u MB [%lX-%lX]",10>), bx, ax, edx, ecx
done_e801:
	push ds
	pop es
	mov si,0
	mov ebx,0
	mov di, offset buffer
	.while (1)
		mov ecx, 20
		mov edx,"SMAP"
		mov eax,00E820h
		clc
		int 15h
;;		  .break .if (CARRY?)
		.break .if (eax != "SMAP")
		.break .if (ebx == 0)
		push ebx
		.if (!si)
			invoke printf, CStr(<"Int 15h, eax=E820h:",10>)
			inc si
		.endif
		mov eax, [di+16]
		.if (eax == 1)
			mov cx, CStr("available")
		.elseif (eax == 2)
			mov cx, CStr("reserved")
		.else
			mov cx, CStr("ACPI")
		.endif
		invoke printf, CStr(<"addr %lX%08lX, size %lX%08lX, type %lX (%s)",13,10>),
			dword ptr [di+4], dword ptr [di+0],
			dword ptr [di+12], dword ptr [di+8],
			dword ptr [di+16], cx
		pop ebx
	.endw
	.if (!si)
		invoke printf, CStr(<"Int 15h, eax=E820h failed",10>)
	.endif
done_e820:
	ret
main endp

start:
	mov ax,@data
	mov ds,ax
	mov bx,ss
	mov cx,ds
	sub bx,cx
	shl bx,4
	add bx,sp
	mov ss,ax
	mov sp,bx
	call main
	mov ah,4Ch
	int 21h

	.stack 400h

	END start
                                                                                                                                                                                                                                                                                                                                                                                         			equ 1h
