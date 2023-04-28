section .data
  weightPrompt db 'Enter your weight in kilograms: ', 0
  heightPrompt db 'Enter your height in meters: ', 0
  bmiFormat db 'Your BMI is %.2f', 0
  overweightMsg db 'You are fat as fuck bro', 0
section .bss
  weight resd 1
  height resd 1
  bmi resd 1
section .text
  global _start
_start:
  ; Prompt user for weight
  mov eax, 4
  mov ebx, 1
  mov ecx, weightPrompt
  mov edx, 28
  int 0x80
  
  ; Read weight from standard input
  mov eax, 3
  mov ebx, 0
  mov ecx, weight
  mov edx, 4
  int 0x80
  
  ; Prompt user for height
  mov eax, 4
  mov ebx, 1
  mov ecx, heightPrompt
  mov edx, 27
  int 0x80
  
  ; Read height from standard input
  mov eax, 3
  mov ebx, 0
  mov ecx, height
  mov edx, 4
  int 0x80
  
  ; Calculate BMI
  fld dword [weight]
  fld dword [height]
  fmul
  fld dword [height]
  fmul
  fdiv
  fstp dword [bmi]
  
  ; Display BMI
  sub esp, 12 ; allocate space on stack for printf arguments
  mov eax, 0
  mov edx, dword [bmi]
  mov dword [esp], edx
  mov dword [esp+4], 0
  mov dword [esp+8], bmiFormat
  call printf
  
  ; Check if user is overweight and display message if necessary
  fld dword [bmi]
  fld dword 25.0
  fcmp
  fstsw ax
  sahf
  ja overweight
  jmp end
  
overweight:
  mov eax, 4
  mov ebx, 1
  mov ecx, overweightMsg
  mov edx, 23
  int 0x80
  
end:
  mov eax, 1
  xor ebx, ebx
  int 0x80
