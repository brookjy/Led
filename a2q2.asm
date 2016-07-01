;
; a2q2.asm
;
;
; Turn the code you wrote in a2q1.asm into a subroutine
; and then use that subroutine with the delay subroutine
; to have the LEDs count up in binary.
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B


; Your code here
; Be sure that your code is an infite loop
; register used: r25,r20,r16
     ldi r25,0
	 mov r0, r25
	 ldi r16,0x00
	 ldi r20,0x40
start:
	 call display
	 inc r0
	 mov r16,r0
	 call delay
	 cpi r16,0
	 brne start





done:		jmp done	; if you get here, you're doing it wrong

;
; display
; 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;
display:
        mov r17,r16
		ldi r18,0x00
		ldi r19,0x00
first:  andi r17,1
		cpi r17,1
		brne second
		ori r18,0x80

second: mov r17,r16
        andi r17,2
		cpi r17,2
		brne third
		ori r18,0x20

third:  mov r17,r16
        andi r17,4
		cpi r17,4
		brne fourth
		ori r18,0x08
	
fourth: mov r17,r16
        andi r17,8
		cpi r17,8
		brne fifth
		ori r18,0x02

fifth:  mov r17,r16
        andi r17,16
		cpi r17,0x10
		brne sixth
		ori r19,0x02

sixth:  mov r17,r16
        andi r17,32
		cpi r17,0x20
		brne end
		ori r19,0x08

end:    sts PORTL,r18
		sts PORTB,r19


		ret
;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; registers used:
;	r20
;	r21
;	r22
;
delay:	
del1:	nop
		ldi r21,0xFF
del2:	nop
		ldi r22, 0xFF
del3:	nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	
		ret
