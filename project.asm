[org 0x0100]

position : dw 0
position1 : dw 0
position2: dw 0
position3 : dw 0
position4 : dw 0
position5 : dw 0
rand: dw 0
randnum: dw 0
char1: dw 0
char2: dw 0
char3 : dw 0
char4 : dw 0
char5 : dw 0
loopnumber: dw 10
score : dw 0
jmp start

clrscr:
push es
mov  ax, 0xb800
mov  es, ax            
xor  di, di            
mov  ax, 0x0720        
mov  cx, 2000          
cld                    
rep  stosw              
pop  es
ret

randG:
   push bp
   mov bp, sp
   pusha
   cmp word [rand], 0
   jne next

  MOV     AH, 00h   ; interrupt to get system timer in CX:DX
  INT     1AH
  inc word [rand]
  mov     [randnum], dx
  jmp next1

  next:
  mov     ax, 25173          ; LCG Multiplier
  mul     word  [randnum]     ; DX:AX = LCG multiplier * seed
  add     ax, 13849          ; Add LCG increment value
  ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
  mov     [randnum], ax          ; Update seed = return value

 next1:xor dx, dx
 mov ax, [randnum]
 mov cx, [bp+4]
 inc cx
 div cx
 
 mov [bp+6], dx
 popa
 pop bp
 ret 2

sleep: push cx
mov cx, 0xFFFF
delay: loop delay
pop cx
ret

placebox:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    
    mov ax, 0xb800
    mov es, ax
    mov di, [position]
    mov ax, 0x0EDC       
    mov [es:di], ax      

    in al, 0x60
    cmp al, 0x4B         
    je left
    cmp al, 0x4D
    je right         
    jmp exit

left:
    cmp word [position], 0
    jle exit   
   
    mov ax, 0x0720       
    mov [es:di], ax     
    sub word [position], 2
    jmp printbox

right:
    cmp word [position], 3996
    jge exit    
    
    mov ax, 0x0720     
    mov [es:di], ax     
    add word [position], 2
    jmp printbox

printbox:
    mov di, [position]
    mov ax, 0x0EDC       
    mov [es:di], ax     

exit:
    mov al, 0x20
    out 0x20, al
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    iret


printchar:
push bp
mov bp,sp
push es
pusha

mov ax,0xb800
mov es,ax
first:
mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,2
mov di,ax
mov word [position1],di

mov ax,0
sub sp,2
push 12
call randG
pop dx
mov ax,dx
mov ah,0x0A
add al,0x41
mov word [char1],ax
stosw

second:
mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,2
mov di,ax
mov word [position2],di

mov ax,0
sub sp,2
push 12
call randG
pop dx
mov ax,dx
mov ah,0x08
add al,0x41
mov word [char2],ax
stosw

third:mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,2
mov di,ax
mov word [position3],di

mov ax,0
sub sp,2
push 12
call randG
pop dx
mov ax,dx
mov ah,0x09
add al,0x41
mov word [char3],ax
stosw

fourth:mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,2
mov di,ax
mov word [position4],di

mov ax,0
sub sp,2
push 12
call randG
pop dx
mov ax,dx
mov ah,0x0B
add al,0x41
mov word [char4],ax
stosw

fifth:mov ax,0
sub sp,2
push 80
call randG
pop ax
shl ax,1
add ax,2
mov di,ax
mov word [position5],di

mov ax,0
sub sp,2
push 12
call randG
pop dx
mov ax,dx
mov ah,0x0C
add al,0x41
mov word [char5],ax
stosw
mov cx,24

falling1:
mov di,[position1]
mov ax,0x0720
mov [es:di],ax
;call sleep
add di,160
mov ah,0x0A
mov al,[char1]
mov[es:di],ax
mov [position1],di
call sleep
call sleep
call sleep
call sleep
call sleep
cmp [position],di
je displayscore
jmp falling2

displayscore:
mov di, [position]
mov ax, 0x0EDC       
mov [es:di], ax 
mov ax,0xb800
mov es,ax
inc word [score]
mov bx,[score]
add bx,0x30
mov al,bl
mov ah,0x07
mov di,158
mov word[es:di],ax

falling2:
mov di,[position2]
mov ax,0x0720
mov [es:di],ax
;call sleep
add di,160
mov ah,0x08
mov al,[char2]
mov[es:di],ax
mov [position2],di
call sleep
call sleep
cmp [position],di
je displayscore
jmp falling3


falling3:
mov di,[position3]
mov ax,0x0720
mov [es:di],ax
call sleep
add di,160
mov ah,0x09
mov al,[char3]
mov[es:di],ax
mov [position3],di
call sleep
call sleep
call sleep
call sleep
call sleep
call sleep
cmp [position],di
je displayscore
jmp falling4


falling4:
mov di,[position4]
mov ax,0x0720
mov [es:di],ax
call sleep
call sleep
add di,160
mov ah,0x0B
mov al,[char4]
mov[es:di],ax
mov [position4],di
call sleep
call sleep
call sleep
call sleep
cmp [position],di
je displayscore
jmp falling5


falling5:
mov di,[position5]
mov ax,0x0720
mov [es:di],ax
call sleep
call sleep
call sleep
add di,160
mov ah,0x0C
mov al,[char5]
mov[es:di],ax
mov [position5],di
call sleep
call sleep
dec cx
cmp cx,0
jne falling1

mov ax,0x720
mov di,[position1]
mov [es:di],ax
mov di,[position2]
mov [es:di],ax
mov di,[position3]
mov [es:di],ax
mov di,[position4]
mov [es:di],ax
mov di,[position5]
mov [es:di],ax

end:
popa
pop es
pop bp
ret

start:
call clrscr

    mov ax, 24 ;
    mov bx, 80 ;
    mul bx ;
    add ax, 39 ;
    shl ax, 1 ;
    mov [position], ax ;
    cli
    mov ax, 0
    mov es, ax
    mov word [es:9*4], placebox
    mov word [es:9*4+2], cs ;
    sti
call printchar
mov ax,0x4c00
int 0x21