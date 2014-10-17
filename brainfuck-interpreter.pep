; This program read a string of brainfuck and interpret it according to the specification at http://en.wikipedia.org/wiki/Brainfuck.
; To do so, we store the program in a table of 265 bytes.
; We use a table of 256 bytes for the memory of the brainfuck program.
;
; LIMITS
; This program is limited to read brainfuck programs of 256 characters.
; It is also limited at 256 memory cells usable by the brainfuck program.
; There is no overflow protection and the memory cells dont loop.

         LDA 0,i
         LDX 0,i             ; Clean the registers

loadloop:CHARI program,x
         LDBYTEA program,x
         CPA 0,i 
         BREQ inimainl
         ADDX 1,i
         BR loadloop         ; Load the brainfuck program into the 'program' table

; Read and execute the actions in 'program' at the current 'ip' which is 0 at the start.
inimainl:LDX 0,i             ; Init the main loop with 'ip' = 0
mainloop:LDBYTEA program,x
         CPA 0,i
         BREQ end            ; Go to end if we have no more input
         CPA '+',i
         BREQ inc
         CPA '-',i
         BREQ dec
         CPA '[',i
         BREQ lBracket
         CPA ']',i
         BREQ rBracket
         CPA '>',i
         BREQ incdp
         CPA '<',i
         BREQ decdp
         CPA '.',i
         BREQ print
         CPA ',',i
         BREQ read
emainl:  LDX ip,d
         ADDX 1,i
         STX ip,d            ; Increase and store the 'ip'
         BR mainloop         ; Go back to main loop

; Increase the current cell
inc:     LDX dataPtr,d
         LDBYTEA tab,x
         ADDA 1,i
         STBYTEA tab,x
         BR emainl

; Decrease the current cell
dec:     LDX dataPtr,d
         LDBYTEA tab,x
         SUBA 1,i
         STBYTEA tab,x
         BR emainl

; Store 'ip' in the stack to be able to go back to this point
; at the end of the loop
lBracket:LDA ip,d
         ADDSP 2,i
         STA 0,s
         BR emainl

; Go to start of the loop if the current cell is not 0
; We do so by poping 'ip' from the stack
rBracket:LDX dataPtr,d
         LDBYTEA tab,x       ; Compare the current cell with 0 by loading it to affect the Z flag
         BREQ cont           ; If it zero, we dont loop, so let's continue
         LDA 0,s
         STA ip,d            ; We put the value of the stack in 'ip' to go back to the start of the loop
         BR emainl
cont:    SUBSP 2,i           ; Move the stack to the previous cell
         BR emainl

; Increase the 'dataPtr' to point to the next memory cell
incdp:   LDA dataPtr,d
         ADDA 1,i
         STA dataPtr,d
         BR emainl

; Decrease the 'dataPtr' to point to the previous memory cell
decdp:   LDA dataPtr,d
         SUBA 1,i
         STA dataPtr,d
         BR emainl

; Print the character value at the current memory cell
print:   LDX dataPtr,d
         LDBYTEA tab,x
         CHARO tab,x
         BR emainl

; Read a character and store its value to the current memory cell
read:    LDX dataPtr,d
         CHARI tab,x
         BR emainl

end:     STOP

ip:      .BLOCK 2            ; Instruction pointer of the brainfuck program
dataPtr: .BLOCK 2            ; Data pointer of the brainfuck memory table
tab:     .BLOCK 256          ; Memory table of the brainfuck program

program: .BLOCK 256          ; Placeholder where the brainfuck program will be stored

.end