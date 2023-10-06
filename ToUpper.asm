format PE GUI 4.0
entry main
 
include 'win32ax.inc'

;***************************************************************************************************************
section '.data' data readable writeable
       String db 'xray project',0

section '.code' code readable executable
proc main
       stdcall ToUpper,String
       invoke  MessageBox,NULL,String,'test',MB_OK
.exit:
       xor eax, eax
       invoke  ExitProcess, eax
endp
;***************************************************************************************************************

;***************************************************************************************************************
; Функция переведет строку в верхний регистр и вернет длину строки
; ----------------------------------------------------------------
proc ToUpper,pStrAddr 
     push ebx ecx edx esi edi
     mov  esi,[pStrAddr]
     dec  esi
     xor  ecx, ecx
     dec  ecx
.to_upper_byte_loop:
     inc  esi
     inc  ecx
     movzx eax,byte [esi]
     cmp  al, 0x0
     je   .to_lower_byte_ret
     cmp  ecx,0x100
     ja   .add_end_string
.compare_eng:
     cmp  al,0x61
     jb   .to_upper_byte_loop
     cmp  al,0x7A
     jbe  .sub_byte
.compare_rus:
     cmp  al,0xE0
     jb   .to_upper_byte_loop
     cmp  al,0xFF
     ja   .to_upper_byte_loop
.sub_byte:
     sub  eax, 0x20
     mov  byte[esi], al
     jmp  .to_upper_byte_loop
.add_end_string:
     mov  byte[esi],0
.to_lower_byte_ret:
     mov  eax,ecx
     pop  edi esi edx ecx ebx
     ret
endp
;***************************************************************************************************************


;***************************************************************************************************************
section '.idata' import data readable writeable

     library kernel32,'KERNEL32.DLL',\
          user32,'user32.dll'

     include 'api/kernel32.inc'
     include 'api/user32.inc'

;***************************************************************************************************************
