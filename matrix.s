section .data
    matrix:
        .long 0x01020304, 0x05060708, 0x090A0B0C, 0x0D0E0F10, 0x11121314, 0x15161718
        .long 0x19202122, 0x23242526, 0x2728292A, 0x2B2C2D2E, 0x30313233, 0x34353637
        .long 0x38393A3B, 0x3C3D3E3F, 0x40414243, 0x44454647, 0x48494A4B, 0x4C4D4E4F
        .long 0x50515253, 0x54555657, 0x58595A5B, 0x5C5D5E5F, 0x60616263, 0x64656667
        .long 0x68696A6B, 0x6C6D6E6F, 0x70717273, 0x74757677, 0x78797A7B, 0x7C7D7E7F
        .long 0x80818283, 0x84858687, 0x88898A8B, 0x8C8D8E8F, 0x90919293, 0x94959697

section .bss
    b: resd 6

section .text
    global _start

_start:
    ; read k and l from standard input
    mov eax, 3      ; sys_read
    mov ebx, 0      ; stdin
    mov ecx, buf    ; buffer for input
    mov edx, 2      ; read 2 bytes
    int 0x80        ; call kernel

    ; parse k and l from input
    mov al, [buf]
    sub al, '0'     ; convert ASCII digit to binary
    mov bl, [buf+1]
    sub bl, '0'
    movzx eax, ax   ; combine into a single 16-bit value
    movzx ebx, bx

    ; compute vector b
    mov edi, b      ; pointer to b
    mov esi, matrix ; pointer to matrix
    mov ecx, 6      ; loop counter
  loop_start:
    mov edx, eax    ; compute A(k,i)
    imul edx, 6     ; multiply row index by 6
    add edx, ecx    ; add column index
    mov eax, [esi+edx*4]

    mov edx, ecx    ; compute A(i,l)
    imul edx, 6
    add edx, ebx
    mov ebx, [esi+edx*4]

    add eax, ebx    ; add A(k,i) and A(i,l)
    mov [edi], eax  ; store result in b

    add edi, 4      ; advance to next element in b
    loop loop_start ; repeat for all elements of b

    ; exit program
    mov eax, 1      ; sys_exit
    xor ebx, ebx    ; exit code
