assume CS:code,DS:data
 
data segment
maxRadix db 15
inputBuf1 db 97, 99 dup ('$'); max - actual - 97*data - $
inputBuf2 db 97, 99 dup ('$')
illegalCharStr db "Illegal character was encountered, exiting...", 13, 10, '$'
incorrectOrderStr db "Change the order to + -, exiting...", 13, 10, '$'
minusStr db "-$"
result db 100 dup (0) 
newline db 13, 10, '$'
a db 50 dup(0)
b db 50 dup(0)
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

printMinus proc
  mov dx, offset minusStr
  mov ah, 09h
  int 21h
  ret
printMinus endp

arrCharToInt proc ; char* arr
  push bp ; preserving caller base pointer
  mov bp, sp; specifying new base pointer
  
  xor si, si
  mov si, [bp+4] ;first parameter
  mov di, [bp+6]
  xor cx, cx
  mov cl, [si+1] ;moving actual string size to cl
  mov [di], cl
  cmp byte ptr [si+2], '-'
  jne minusSignSkip
	dec cl
	mov [di], cl
	inc si
  minusSignSkip:
  add di, cx
  add si, 2 ; si points to first input character
  arrLoop:
    cmp byte ptr [si], '0'; checks whether character is 
	jae aboveCheck
	  cmp byte ptr [si], '-'
	  jne illegalChar
	    inc si
		dec di
	    loop arrLoop
	aboveCheck:
	cmp byte ptr [si], '9'
	ja illegalChar 
      sub byte ptr [si], '0'
	  mov bl, byte ptr [si]
	  mov [di], bl
	  dec di
	  inc si
	loop arrLoop
	
  mov sp, bp ; freeing space for locals
  pop bp ; restoring o`ld base pointer
  ret 4; returns and frees params
  illegalChar: ;prints string and exiting
  mov dx, offset illegalCharStr
  mov ah, 09h
  int 21h
  mov ah, 4Ch
  int 21h
arrCharToInt endp

arrIntToChar proc ; char* arr
  push bp ; preserving caller base pointer
  mov bp, sp; specifying new base pointer
  
  xor si, si
  xor cx, cx
  mov si, [bp+4] ;first parameter
  arrIntToCharLoop:
  cmp [si], byte ptr '$'
  je arrIntToCharEnd
  add [si], byte ptr '0'
  inc si
  inc cx
  jmp arrIntToCharLoop
  arrIntToCharEnd:
  dec si
  mov ah, 02h
  printLoop:
  mov dl, byte ptr [si]
  int 21h
  dec si
  loop printLoop
  
  mov sp, bp ; freeing space for locals
  pop bp ; restoring old base pointer
  ret 2; returns and frees params
arrIntToChar endp

mult proc
  push bp ; preserving caller base pointer
  mov bp, sp; specifying new base pointer
  sub sp, 20
  ; bp+4 = a
  ; bp+6 = b
  ; bp+8 = res
  ; bp-8 = len(b)
  ; bp-7 = b_i
  ; bp-6 = len(a)
  ; bp-5 = a_i
  ; bp-16 = carry
  mov si, [bp+6]
  mov bl, [si]; moving len(b) to bl
  mov [bp-8], bl
  mov [bp-7], byte ptr 1
  
  mov si, [bp+4]
  mov bl, [si]
  mov [bp-6], bl
  
  startOfB_ILoop:
  mov cl, [bp-7] ;  for b_i = 1 to q // for all digits in b
  mov bl, [bp-8]
  cmp cl, bl
  ja endOfMultLoop
    mov [bp-16], byte ptr 0
	
	mov [bp-5], byte ptr 1
	
	startOfA_ILoop:
	mov cl, [bp-5] ; cl = a_i
	mov bl, [bp-6] ; len(a)
	cmp cl, bl
	ja endOfA_ILoop
	  xor ax, ax
	  mov di, [bp+8]
	  mov al, [bp-5]
	  add di, ax ; a_i
	  mov al, [bp-7]
	  add di, ax ; b_i
	  dec di
	  dec di ; product[a_i + b_i - 1]
	  mov bl, [bp-16]
	  add [di], bl ;+= carry
	  mov al, [bp-5] ;a_i
      mov si, [bp+4]
      add si, ax
      ;dec si ; si = a[a_i]
      mov dl, [si]
      mov al, [bp-7]
      mov si, [bp+6]
      add si, ax
      ;dec si
      xor ax, ax
      mov al, [si]
      mul dl ; a[a_i] * b[b_i]
      add [di], al
	  mov al, [di]
	  mov bl, 10
	  div bl
	  mov [bp-16], al ;carry = product[a_i + b_i - 1] / base
	  xor ax, ax
	  mov al, [di]
	  div bl
	  mov [di], ah
	  mov ah, [bp-5]
	  inc ah
	  mov [bp-5], ah
	  ;inc byte ptr [bp-5]; inc a_i
	  jmp startOfA_ILoop
    endOfA_ILoop:
    inc di
	mov al, [bp-16]
	add [di], al
	mov ah, [bp-7]
	inc ah
	mov [bp-7], ah
	;inc byte ptr [bp-7]
	jmp startOfB_ILoop
  endOfMultLoop:
  inc di
  mov [di], byte ptr '$'
  mov sp, bp
  pop bp
  ret 6
mult endp

start:
mov AX, data
mov DS, AX
mov ah, 0Ah
 mov dx, offset inputBuf1
 int 21h
 call printNewLine
 push offset a
 push offset inputBuf1
 call arrCharToInt

 mov ah, 0Ah
 mov dx, offset inputBuf2
 int 21h
 call printNewLine
 push offset b
 push offset inputBuf2
 call arrCharToInt

 mov si, offset inputBuf1
 mov di, offset inputBuf2
 add si, 2
 add di, 2
 cmp [si], byte ptr '-'
 je firstMinus
   cmp [di], byte ptr '-'
	je firstPlusSecondMinus
	  ;both are +
	  push offset result
      push offset b
      push offset a
      call mult
	  jmp endOfSelection
	firstPlusSecondMinus:
	  ;+-
	  ;mov [di], byte ptr 0
	  call printMinus
	  push offset result
      push offset b
      push offset a
	  call mult
	  jmp endOfSelection
  firstMinus:
    cmp [di], byte ptr '-'
	je firstMinusSecondMinus
	  ;-+
	  call printMinus
      push offset result
      push offset b
      push offset a
	  call mult
	  jmp endOfSelection
	firstMinusSecondMinus:
	;--
      push offset result
      push offset b
      push offset a
	  call mult
	  jmp endOfSelection
  endOfSelection:
  push offset result
  call arrIntToChar
  ;mov ah, 09h
  ;mov dx, offset result
  ;int 21h


mov ah, 4Ch
int 21h
code ends
end start
