;  Description: This program analyzes a list of signed double-word integers.
;              It calculates the minimum, estimated median value, maximum, sum, and
;              integer average. The program also calculates statistics for negative numbers and those divisible by twelve,
;              providing a comprehensive overview of the given dataset.

section .data
    NULL            equ 0
    TRUE            equ 1
    FALSE           equ 0
    EXIT_SUCCESS    equ 0
    SYS_exit        equ 60

    ; Signed data declaration
    list dd 2140, -2376, 2540, -2240, 2677, -2635, 2426, 2000
         dd -2614, 2418, -2513, 2420, -2119, 2215, -2556, 2712
         dd 2436, -2622, 2731, -2729, 2615, -2724, 2208, 2220
         dd -2580, 2146, -2324, 2425, -2816, 2256, -2718, 2192
         dd 2004, -2235, 2764, -2615, 2312, -2765, 2954, 2960
         dd -2515, 2556, -2342, 2321, -2556, 2727, -2227, 2844
         dd 2382, -2465, 2955, -2435, 2225, -2419, 2534, 2348
         dd -2467, 2316, -2961, 2335, -2856, 2553, -2032, 2832
         dd 2246, -2330, 2317, -2115, 2726, -2140, 2565, 2868
         dd -2464, 2915, -2810, 2465, -2544, 2264, -2612, 2656
         dd 2192, -2825, 2916, -2312, 2725, -2517, 2498, 3672
         dd -2475, 2034, -2223, 2883, -2172, 2350, -2415, 2335
         dd 2124, -2118, 2713, 2025

    ; Variables
    length       dd     100
    listMin      dd     0
    listEstMed   dd     0
    listMax      dd     0
    listSum      dd     0
    listAve      dd     0
    negCnt       dd     0
    negSum       dd     0
    negAve       dd     0
    twelveCnt    dd     0
    twelveSum    dd     0
    twelveAve    dd     0

section .text
global _start

_start:
; -------------------- MINIMUM VALUE -------------------- ;
; Initialize 
mov ecx, dword [length]    
mov esi, list           
mov eax, dword [esi]        
mov dword [listMin], eax   

; Loop to find the minimum value
; Compare ECX with zero
; Jump to end if ECX is zero
; Move value at address ESI to EAS register
; Compare EAX with listMin
; Jump if greater than or equal to listMin
; Move current value to listMin
; Increment ESI
; loop to next iteration
; End loop
findMinLoop:
    cmp ecx, 0            
    je endFindMinLoop        
    mov eax, dword [esi]    
    cmp eax, dword [listMin] 
    jge nextIterationFindMin 
    mov dword [listMin], eax 
nextIterationFindMin:
    add esi, 4        
    loop findMinLoop        
endFindMinLoop:

; -------------------- MAXIMUM VALUE -------------------- ;
; Initialize variables
mov ecx, dword [length]      
mov esi, list           
mov eax, dword [esi]        
mov dword [listMax], eax     

; Loop to find the maximum value
; Compare loop counter with zero
; Jump to end if loop counter is zero
; Move value at address ESI to EAX register
; Compare EAX with listMax
; Jump if less than or equal to listMax
; Increment ESI to point to next element
; Next Iteration
; End loop
findMaxLoop:
    cmp ecx, 0             
    je endFindMaxLoop             
    mov eax, dword [esi]    
    cmp eax, dword [listMax] 
    jle nextIterationFindMax 
    mov dword [listMax], eax
nextIterationFindMax:
    add esi, 4           
    loop findMaxLoop        
endFindMaxLoop:

; -------------------- ESTIMATED MEDIAN  -------------------- ;
    ; Initialize
    mov eax, [length]     
    mov ecx, 2            

; Load the length of the list
; Divide length by 2 and load it into EAX
; Load the middle element
; Add the previous element
; Add the next element
; Add the element after next
    idiv ecx          
    mov ebx, [list + eax * 4]       
    add ebx, [list + eax * 4 - 4]   
    add ebx, [list + eax * 4 + 4]   
    add ebx, [list + eax * 4 + 8]  
    idiv ecx
    mov [listEstMed], eax

; -------------------- LIST SUM AND AVERAGE  -------------------- ;
; Initialize variables
mov ecx, dword [length]      
mov esi, list
mov eax, dword [esi]         
mov dword [listSum], eax     

; Move first element of list to EAX
; Initialize listSum with the first element of list
; Start of the loop
; Move to the next element
; Check if it's the last iteration
; Jump to end if it's the last iteration
; Move value at address ESI to EAX register
; Add the current value to the sum
; Next iteration and end loop
calcSumLoop:
add esi, 4
cmp ecx, 1
je endCalcSumLoop
mov eax, dword [esi]         
add dword [listSum], eax    
loop calcSumLoop
endCalcSumLoop:

; -------------------- CALCULATE AVERAGE -------------------- ;
; Calculate Average
; Load the Sum
; Sign extend EAX into EDX:EAX
; Divide the sum by the length of the list
; Store the average in listAve
mov eax, dword [listSum]   
cdq         
idiv dword [length]          
mov dword [listAve], eax   

;--------------------COUNT NEGATIVE NUMBERS -------------------- ;
;--------------------- SUM NEGATIVE NUMBERS -------------------- ;
;------------------- AVERAGE NEGATIVE NUMBERS ------------------ ;
; Initialize 
mov ecx, dword 0         
mov eax, dword 0          
mov ebx, dword 0         

; Initialize loop counter to zero for iterating through the list
; Initialize counter for counting negative numbers to zero
; Initialize sum of negative numbers to zero
; Start of loop
; Load the current element into EDX
; Compare EDX with zero
; Jump if not negative (greater than or equal to zero)
; Then increment the count of negative numbers
; Add the negative number to the sum
; Jump to process next element if loop counter is less than the length
; Jump if count is zero to avoid division by zero
; Sign extend EAX into EDX:EAX
; Divide the sum by the count

process_list:
    mov edx, dword [list + ecx * 4] 
    cmp edx, 0
    jge not_negative
is_negative:
    inc eax
    add ebx, edx
not_negative:
    inc ecx
    cmp ecx, dword [length]  
    jl process_list
mov dword [negCnt], eax   
mov dword [negSum], ebx   
; Initialize for Average
mov eax, dword [negSum]    
mov ebx, dword [negCnt]     
cmp ebx, 0
je average_is_zero 
cdq 
idiv ebx
average_is_zero:
mov dword [negAve], eax

; --------------------------- Divisible by 12 Count --------------------------- ;
; Initialize 
mov ecx, 0       
mov eax, 0       
mov ebx, 0       

; Loop to count numbers divisible by 12
; Load the current element into EDX
; Copy the current element to EAX for division
; Sign extend EAX into EDX:EAX
; Load divisor 12 into EBX
; Divide EDX:EAX by EBX, result in EAX, remainder in EDX
; Check if remainder is zero (divisible by 12)
; Jump if not divisible by 12
; Increment the count of numbers divisible by 12
divisible_loop_start:
    mov edx, [list + ecx * 4]
    mov eax, edx
    cdq             
    mov ebx, 12
    idiv ebx        
    cmp edx, 0      
    jne not_divisible_by_12
    mov eax, [twelveCnt]
    inc eax
mov [twelveCnt], eax
not_divisible_by_12:
    inc ecx
    cmp ecx, [length]
    jl divisible_loop_start

; --------------------------- Divisible by 12 Sum --------------------------- ;
; Initialize 
mov ecx, 0       
mov eax, 0       
mov ebx, 0       

; Load the current element from the list
; Load the current element into EDX
; Load the current element to EDI for division
; Load the current element to EAX for division
; Sign extend EAX into EDX:EAX
; Load divisor 12 into EBX
; Divide EDX:EAX by EBX, result in EAX, remainder in EDX
; Check if remainder is zero (divisible by 12)
; Jump if not divisible by 12
; Load the current element to the sum of numbers divisible by 12
is_divisible_loop_start:
    mov edx, [list + ecx * 4]
    mov edi, edx   
    mov eax, edi
    cdq             
    mov ebx, 12
    idiv ebx        
    cmp edx, 0      
    jne is_not_divisible_by_12
    add [twelveSum], edi
    inc ebx
is_not_divisible_by_12:
    inc ecx
    cmp ecx, [length]
    jl is_divisible_loop_start

; --------------------------- Divisible by 12 Average --------------------------- ;
; Initialize
mov eax, [twelveSum]
mov ebx, [twelveCnt]

; Jump if count is zero to avoid division by zero
; Sign extend EAX into EDX:EAX
; Divide the sum by the count
; Load the average of numbers divisible by 12
cmp ebx, 0
je is_average_zero
cdq 
idiv ebx
is_average_zero:
mov [twelveAve], eax

; Exit Program
last:
    mov rax, SYS_exit           ; system call for exit (SYS_exit)
    mov rdi, EXIT_SUCCESS       ; return C/C++ style code (0)
    syscall
