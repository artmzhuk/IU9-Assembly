printNewline macro
	mov ah, 02h
	mov dl, 13
	int 21h
	mov ah, 02h
	mov dl, 10
	int 21h
endm

printLn macro string
	mov ah, 09h
	mov dx, offset string
	int 21h
	printNewline
endm

scanStringLn macro string
	mov ah, 0Ah
	mov dx, offset string
	int 21h	
	printNewline
endm

scanChar macro buf
	mov ah, 01h
	int 21h
	mov si, offset buf
	mov [si], al
	printNewline
endm

replaceFirstLetter macro string, charToReplace, charReplaceWith
	local traverse_loop, end_of_traverse_loop
	mov si, offset string
	inc si
	mov [si], byte ptr ' '
	dec si

	traverse_loop:
		inc si
		cmp [si], byte ptr '$'
		je end_of_traverse_loop

		cmp [si], byte ptr ' '
		jne traverse_loop

		mov di, offset charToReplace
		mov al, [di]
		mov di, si
		inc di
		cmp [di], al
		jne traverse_loop

		inc si
		mov di, offset charReplaceWith
		mov al, [di]
		mov [si], al
		jmp traverse_loop
	end_of_traverse_loop:
endm

printResult macro string
	mov ah, 09h
	mov dx, offset string
	inc dx
	inc dx
	int 21h
endm
