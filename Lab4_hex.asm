assume CS:code,DS:data
 
data segment
maxRadix db 15
inputBuf1 db 97, 99 dup ('$'); max - actual - 97*data - $
inputBuf2 db 97, 99 dup ('$')
illegalCharStr db "Illegal character was encountered, exiting...", 13, 10, '$'
incorrectOrderStr db "Change the order to + -, exiting...", 13, 10, '$'
minusStr db "-$"
result db 0, 99 dup ('$') 
newline db 13, 10, '$'
data ends

SSEG segment stack
db 400h dup (?)
SSEG ends
 
code segment
printNewLine proc
  mov dx, offset newline
  mov ah, 09h
  int 21h
  ret
printNewLine endp

arrCharToInt proc ; char* arr
  push bp ; preserving caller base pointer
  mov bp, sp; specifying new base pointer
  
  xor si, si
  mov si, [bp+4] ;first parameter
  xor cx, cx
  mov cl, [si+1] ;moving actual string size to cl
  add si, 2 ; si points to first input character
  arrLoop:
    cmp byte ptr [si], '0'; checks whether character is 
	jae aboveCheck
	  cmp byte ptr [si], '-'
	  jne illegalChar
	    inc si
	    jmp endOfarrCharToIntLoop
	aboveCheck:
	cmp byte ptr [si], '9'
	ja aboveCheck1 
      sub byte ptr [si], '0'
	  inc si
	  jmp endOfarrCharToIntLoop
	aboveCheck1:
	cmp byte ptr [si], 'A'
	jb illegalChar
	cmp byte ptr [si], 'F'
	ja illegalChar
	  sub byte ptr [si], 'A'
	  add byte ptr [si], 10
	  inc si
	endOfarrCharToIntLoop:
	loop arrLoop
	
  mov sp, bp ; freeing space for locals
  pop bp ; restoring old base pointer
  ret 2; returns and frees params
  illegalChar: ;prints string and exiting
  mov dx, offset illegalCharStr
  mov ah, 09h
  int 21h
  mov ah, 4Ch
  int 21h
arrCharToInt endp

unsignedAdd proc
  push bp ; preserving caller base pointer
  mov bp, sp; specifying new base pointer
  sub sp, 2
  xor si, si
  xor di, di
  mov si, [bp+4] ; first string adress
  mov di, [bp+6] ; second string adress
  
  mov al, [si+1]
  mov [bp-1], al ;[bp-1] = actual length of str1
  mov ah, [di+1]
  mov [bp-2], ah ;[bp-2] = actual length of str2
  
  xor cx, cx
  mov cl, al ; cl = length str1
  mov di, offset result
  cmp al, ah
  jae firstLenBigger
    mov cl, ah ; cl = length str2
    mov si, [bp+6] ; si = *str2
  firstLenBigger:
    xor dx, dx
	mov dl, cl
    add si, 1 ; si points to first digit of string
	add si, cx
	add di, cx
    copyLoop:
	  mov bl, [si]
	  mov [di], bl
	  dec si
	  dec di
    loop copyLoop
  
  mov si, [bp+4] ; first string adress
  mov di, [bp+6] ; second string adress
  
  mov al, [si+1]
  mov [bp-1], al ;[bp-1] = actual length of str1
  mov ah, [di+1]
  mov [bp-2], ah ;[bp-2] = actual length of str2
  
  xor dx, dx
  mov si, [bp+6] 
  mov dl, al ;dl stores len of biggest
  cmp al, ah
  jae firstLenBigger1
    mov si, [bp+4]
	mov dl, ah
	mov ah, al
  firstLenBigger1:
    mov di, offset result
	xor cx, cx
	mov cl, ah ;cl stores len of shortest
	add si, 1
	add si, cx
	add di, dx
	mov bx, 16
	xor dx, dx
	addLoop:
	  xor ax, ax
	  mov al, [si]
	  add al, dh
	  add al, [di]
	  div bl
	  mov dh, al ;carry stored in dh
	  mov [di], ah
	  dec di
	  dec si
	loop addLoop
    add [di], dh

  mov sp, bp ; freeing space for locals
  pop bp ; restoring old base pointer
  ret 4; returns and frees params
unsignedAdd endp

arrIntToChar proc ; char* arr
  push bp ; preserving caller base pointer
  mov bp, sp; specifying new base pointer
  
  xor si, si
  mov si, [bp+4] ;first parameter
  
  arrIntToCharLoop:
  cmp [si], byte ptr '$'
  je arrIntToCharEnd
  cmp byte ptr [si], 10
  jae letter
    add [si], byte ptr '0'
	inc si
	jmp arrIntToCharLoop
  letter:
    add [si], byte ptr 55
    inc si
  jmp arrIntToCharLoop

  arrIntToCharEnd:
  mov sp, bp ; freeing space for locals
  pop bp ; restoring old base pointer
  ret 2; returns and frees params
arrIntToChar endp

compute proc
 mov ah, 0Ah
 mov dx, offset inputBuf1
 int 21h
 call printNewLine
 push offset inputBuf1
 call arrCharToInt

 mov ah, 0Ah
 mov dx, offset inputBuf2
 int 21h
 call printNewLine
 push offset inputBuf2
 call arrCharToInt

 push offset inputBuf2
 push offset inputBuf1
 call unsignedAdd  
 push offset result
 call arrIntToChar
 mov ah, 09h
 mov dx, offset result
 int 21h
 ret
compute endp

start:
mov AX, data
mov DS, AX

call compute

mov ah, 4Ch
int 21h
code ends
end start
