;osaka II beeper engine for SHARP PC
;version 1.0 by utz 07'2014
;2 channels pulse-interleaving square wave sound + pwm drums

;modified for the AS61860 assembler by Robert van Engelen:
;https://shop-pdp.net/ashtml/asmlnk.htm
;$ as61860 -los main.asm
;$ as61860 -los music.asm
;$ aslink -imwu -b play=BASE play main.rel music.rel

;option 1: create BASIC bootloader
;$ ihx2bas play.ihx
;then RUN after CLOAD and CALL A

;option 2: create binary to load with CLOAD M
;$ ihx2bin play.ihx
;$ bin2wav --type=bin --addr=33000 --pc=1403 play.bin
;CLOAD M
;CALL 33000

noloop = 1			; 1 = do not loop playback, 0 = loop playback

I	.equ 0x00 
J	.equ 0x01 
A	.equ 0x02 
B	.equ 0x03 
XL	.equ 0x04 
XH	.equ 0x05 
YL	.equ 0x06 
YH	.equ 0x07
K 	.equ 0x08
L 	.equ 0x09
M 	.equ 0x0a
N 	.equ 0x0b
WRK	.equ 0x0c
OUTP	.equ 0x5f		;beeper outc port

BZHI	.equ 0x10		;beeper hi mask to set BZ1 with orim
BZLO	.equ 0x00		;beeper lo mask to clear BZ1-BZ3 with anim

.include "target.h"

.area	play (REL)

;	.org 0x80e8		; PC-1403 0x80e8

begin:	lip OUTP		;preserve outbyte
	ldm
	push
	
init:	
	lp XL			;setup index register, X = XL+(XH*256)
mpntr0:
	lia <(sdata-1)		; PC-1403 0xb4		;point to song data-1
	exam
	lp XH
mpntr1:
	lia >(sdata-1)		; PC-1403 0x88
	exam
	
	lp WRK			;store ptn sequence pointer in 0x0c..0x0d
	liq XL
	mvb
	
setptn:				;read pattern sequence
	lp XL			;restore ptn seq pointer
	liq WRK
	mvb

	ixl			;hibyte of ptn address to A
	cpia 0x00		;if it is 0, end of seq reached -> reset pointer

.if	noloop
	jrzp end		;exit if 0xff found - uncomment this and comment out next if you don't want to loop NOTE: jpz->jrzp
.else
	jrzm init
.endif

	exab			;hibyte of ptn addr to B
	ixl			;lobyte of ptn addr to A
	
	lp WRK			;store ptn sequence pointer in 0x0c..0x0d
	liq XL
	mvb

	lp XL			;store ptn address in X
	liq A
	mvb
	
rdata:
	test 8			;check BRK/ON key
	jrnzp end		;and exit if pressed NOTE: jpnz->jrnzp

	ixl			;inc index, ->dp, value to A (drum byte)
	cpia 0xff		;check for end marker 0xff
	jrzm setptn		;loop if 0xff found
	
	lp M			;store speed value
	exam
	ldm			;load back
	anim 0xfc		;delete drum value

	ania 0x03		;delete speed value
	;cpia 0			;check if drum is active NOTE: ania 0x03 sets z flag
	jrzp nodrum
	call drum		;play drum

nodrum:
	ixl			;point to ch1 counter and backup in A
	ix			;point to ch2 counter
	lp L
	mvmd			;put it in L
	
	call playrow
chkbp:
	jrm rdata		;NOTE: jp->jrm

;***************************************************************

end:
	pop
	lip OUTP		;restore outbyte
	exam
	outc
	rtn

;**************************************************************

playrow:
	push

;**************************************************************
a0b0:				;ch1 off, ch2 off
				;when a counts down, go to a1b0
				;when b counts down, to to a0b1
	
	deca		;4	;decrement counter ch1
	jrnzp skip1a	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3	;6	;and continue in a1b0

skip1a:
	lip OUTP	;4	;set output mask
	anim BZLO	;4
skip1:
	outc		;2	;write to beeper port

	decl		;4	;decrement counter ch2
	jrnzp skip2a	;7/4
	lp L		;2	;restore counter
	mvmd		;3
	jp skip6	;6	;and continue in a0b1
	
skip2a:
	lip OUTP	;4
	anim BZLO	;4
skip2:	outc		;2

			;44*16+10 = 714
;*******
	;lp K		;2	
	
	deca		;4
	jrnzp skip1aB	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3B	;6	;and continue in a1b0

skip1aB:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1B:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aB	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6B	;6	;and continue in a0b1
	
skip2aB:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2B:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aC	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3C	;6	;and continue in a1b0

skip1aC:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1C:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aC	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6C	;6	;and continue in a0b1
	
skip2aC:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2C:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aD	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3D	;6	;and continue in a1b0

skip1aD:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1D:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aD	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6D	;6	;and continue in a0b1
	
skip2aD:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2D:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aE	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3E	;6	;and continue in a1b0

skip1aE:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1E:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aE	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6E	;6	;and continue in a0b1
	
skip2aE:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2E:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aF	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3F	;6	;and continue in a1b0

skip1aF:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1F:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aF	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6F	;6	;and continue in a0b1
	
skip2aF:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2F:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aG	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3G	;6	;and continue in a1b0

skip1aG:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1G:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aG	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6G	;6	;and continue in a0b1
	
skip2aG:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2G:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aH	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3H	;6	;and continue in a1b0

skip1aH:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1H:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aH	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6H	;6	;and continue in a0b1
	
skip2aH:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2H:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aI	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3I	;6	;and continue in a1b0

skip1aI:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1I:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aI	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6I	;6	;and continue in a0b1
	
skip2aI:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2I:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aJ	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3J	;6	;and continue in a1b0

skip1aJ:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
skip1J:	anim BZLO	;4
	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aJ	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6J	;6	;and continue in a0b1
	
skip2aJ:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2J:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aK	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3K	;6	;and continue in a1b0

skip1aK:
	;wait 2		;8	;eliminate overhead
	
skip1K:	lip OUTP	;4
	anim BZLO	;4
	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aK	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6K	;6	;and continue in a0b1
	
skip2aK:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2K:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aL	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3L	;6	;and continue in a1b0

skip1aL:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1L:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aL	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6L	;6	;and continue in a0b1
	
skip2aL:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2L:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aM	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3M	;6	;and continue in a1b0

skip1aM:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1M:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aM	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6M	;6	;and continue in a0b1
	
skip2aM:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2M:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aN	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3N	;6	;and continue in a1b0

skip1aN:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1N:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aN	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6N	;6	;and continue in a0b1
	
skip2aN:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2N:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aO	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3O	;6	;and continue in a1b0

skip1aO:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1O:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aO	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6O	;6	;and continue in a0b1
	
skip2aO:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2O:	outc		;2
;*******	

	;lp K		;2	
	
	deca		;4
	jrnzp skip1aP	;7/4	;when counter ch1 has reached 0
	pop		;3	;restore counter ch1
	push		;2	;and reload backup
	jp skip3P	;6	;and continue in a1b0

skip1aP:
	;wait 2		;8	;eliminate overhead
	
	lip OUTP	;4
	anim BZLO	;4
skip1P:	outc		;2
	
	;lp L		;2
	decl		;4
	jrnzp skip2aP	;7/4
	lp L		;3	;restore counter
	mvmd
	jp skip6P	;6	;and continue in a0b1
	
skip2aP:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP	;4
	anim BZLO	;4
skip2P:	outc		;2
	

	decm			;decrement primary speed counter
	jpnz a0b0		;and loop if not 0

	pop
	rtn

;**************************************************************					
a1b0:				;ch1 on, ch2 off
				;when a counts down, go to a0b0
				;when b counts down, go to a1b1
	;lp K
	deca
	jrnzp skip3a
	pop		;3
	push
	jp skip1		;and continue in a0b0
skip3a:
	;wait 2

	lip OUTP
	orim BZHI
skip3:	outc
	;lp L
	decl
	jrnzp skip4a
	lp L			;restore counter
	mvmd
	jp skip8		;and continue in a1b1
skip4a:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4:	outc
;*******

	;lp K
	deca
	jrnzp skip3aB
	pop		;3
	push
	jp skip1B		;and continue in a0b0
skip3aB:
	;wait 2

	lip OUTP
	orim BZHI
skip3B:	outc
	;lp L
	decl
	jrnzp skip4aB
	lp L			;restore counter
	mvmd
	jp skip8B		;and continue in a1b1
skip4aB:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4B:	outc
;*******

	;lp K
	deca
	jrnzp skip3aC
	pop		;3
	push
	jp skip1C		;and continue in a0b0
skip3aC:
	;wait 2

	lip OUTP
	orim BZHI
skip3C:	outc
	;lp L
	decl
	jrnzp skip4aC
	lp L			;restore counter
	mvmd
	jp skip8C		;and continue in a1b1
skip4aC:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4C:	outc
;*******

	;lp K
	deca
	jrnzp skip3aD
	pop		;3
	push
	jp skip1D		;and continue in a0b0
skip3aD:
	;wait 2

	lip OUTP
	orim BZHI
skip3D:	outc
	;lp L
	decl
	jrnzp skip4aD
	lp L			;restore counter
	mvmd
	jp skip8D		;and continue in a1b1
skip4aD:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4D:	outc
;*******

	;lp K
	deca
	jrnzp skip3aE
	pop		;3
	push
	jp skip1E		;and continue in a0b0
skip3aE:
	;wait 2

	lip OUTP
	orim BZHI
skip3E:	outc
	;lp L
	decl
	jrnzp skip4aE
	lp L			;restore counter
	mvmd
	jp skip8E		;and continue in a1b1
skip4aE:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4E:	outc
;*******

	;lp K
	deca
	jrnzp skip3aF
	pop		;3
	push
	jp skip1F		;and continue in a0b0
skip3aF:
	;wait 2

	lip OUTP
	orim BZHI
skip3F:	outc
	;lp L
	decl
	jrnzp skip4aF
	lp L			;restore counter
	mvmd
	jp skip8F		;and continue in a1b1
skip4aF:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4F:	outc
;*******

	;lp K
	deca
	jrnzp skip3aG
	pop		;3
	push
	jp skip1G		;and continue in a0b0
skip3aG:
	;wait 2

	lip OUTP
	orim BZHI
skip3G:	outc
	;lp L
	decl
	jrnzp skip4aG
	lp L			;restore counter
	mvmd
	jp skip8G		;and continue in a1b1
skip4aG:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4G:	outc
;*******

	;lp K
	deca
	jrnzp skip3aH
	pop		;3
	push
	jp skip1H		;and continue in a0b0
skip3aH:
	;wait 2

	lip OUTP
	orim BZHI
skip3H:	outc
	;lp L
	decl
	jrnzp skip4aH
	lp L			;restore counter
	mvmd
	jp skip8H		;and continue in a1b1
skip4aH:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4H:	outc
;*******

	;lp K
	deca
	jrnzp skip3aI
	pop		;3
	push
	jp skip1I		;and continue in a0b0
skip3aI:
	;wait 2

	lip OUTP
	orim BZHI
skip3I:	outc
	;lp L
	decl
	jrnzp skip4aI
	lp L			;restore counter
	mvmd
	jp skip8I		;and continue in a1b1
skip4aI:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4I:	outc
;*******

	;lp K
	deca
	jrnzp skip3aJ
	pop		;3
	push
	jp skip1J		;and continue in a0b0
skip3aJ:
	;wait 2

	lip OUTP
	orim BZHI
skip3J:	outc
	;lp L
	decl
	jrnzp skip4aJ
	lp L			;restore counter
	mvmd
	jp skip8J		;and continue in a1b1
skip4aJ:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4J:	outc
;*******

	;lp K
	deca
	jrnzp skip3aK
	pop		;3
	push
	jp skip1K		;and continue in a0b0
skip3aK:
	;wait 2

	lip OUTP
	orim BZHI
skip3K:	outc
	;lp L
	decl
	jrnzp skip4aK
	lp L			;restore counter
	mvmd
	jp skip8K		;and continue in a1b1
skip4aK:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4K:	outc
;*******

	;lp K
	deca
	jrnzp skip3aL
	pop		;3
	push
	jp skip1L		;and continue in a0b0
skip3aL:
	;wait 2

	lip OUTP
	orim BZHI
skip3L:	outc
	;lp L
	decl
	jrnzp skip4aL
	lp L			;restore counter
	mvmd
	jp skip8L		;and continue in a1b1
skip4aL:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4L:	outc
;*******

	;lp K
	deca
	jrnzp skip3aM
	pop		;3
	push
	jp skip1M		;and continue in a0b0
skip3aM:
	;wait 2

	lip OUTP
	orim BZHI
skip3M:	outc
	;lp L
	decl
	jrnzp skip4aM
	lp L			;restore counter
	mvmd
	jp skip8M		;and continue in a1b1
skip4aM:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4M:	outc
;*******

	;lp K
	deca
	jrnzp skip3aN
	pop		;3
	push
	jp skip1N		;and continue in a0b0
skip3aN:
	;wait 2

	lip OUTP
	orim BZHI
skip3N:	outc
	;lp L
	decl
	jrnzp skip4aN
	lp L			;restore counter
	mvmd
	jp skip8N		;and continue in a1b1
skip4aN:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4N:	outc
;*******

	;lp K
	deca
	jrnzp skip3aO
	pop		;3
	push
	jp skip1O		;and continue in a0b0
skip3aO:
	;wait 2

	lip OUTP
	orim BZHI
skip3O:	outc
	;lp L
	decl
	jrnzp skip4aO
	lp L			;restore counter
	mvmd
	jp skip8O		;and continue in a1b1
skip4aO:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4O:	outc
;*******

	;lp K
	deca
	jrnzp skip3aP
	pop		;3
	push
	jp skip1P		;and continue in a0b0
skip3aP:
	;wait 2

	lip OUTP
	orim BZHI
skip3P:	outc
	;lp L
	decl
	jrnzp skip4aP
	lp L			;restore counter
	mvmd
	jp skip8P		;and continue in a1b1
skip4aP:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	anim BZLO
skip4P:	outc


	decm
	jpnz a1b0
	
	pop
	rtn

;**************************************************************				
a0b1:				;ch1 off, ch2 on
				;when a counts down, go to a1b1
				;when b counts down, go to a0b0
	;lp K	
	deca
	jrnzp skip5a
	pop
	push		;3
	jp skip7		;and continue in a1b1
skip5a:
	;wait 2

	lip OUTP
	anim BZLO
skip5:	outc
	;lp L
	decl
	jrnzp skip6a
	lp L			;restore counter
	mvmd
	jp skip2		;and continue in a0b0
skip6a:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aB
	pop
	push		;3
	jp skip7B		;and continue in a1b1
skip5aB:
	;wait 2

	lip OUTP
	anim BZLO
skip5B:	outc
	;lp L
	decl
	jrnzp skip6aB
	lp L			;restore counter
	mvmd
	jp skip2B		;and continue in a0b0
skip6aB:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6B:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aC
	pop
	push		;3
	jp skip7C		;and continue in a1b1
skip5aC:
	;wait 2

	lip OUTP
	anim BZLO
skip5C:	outc
	;lp L
	decl
	jrnzp skip6aC
	lp L			;restore counter
	mvmd
	jp skip2C		;and continue in a0b0
skip6aC:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6C:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aD
	pop
	push		;3
	jp skip7D		;and continue in a1b1
skip5aD:
	;wait 2

	lip OUTP
	anim BZLO
skip5D:	outc
	;lp L
	decl
	jrnzp skip6aD
	lp L			;restore counter
	mvmd
	jp skip2D		;and continue in a0b0
skip6aD:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6D:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aE
	pop
	push		;3
	jp skip7E		;and continue in a1b1
skip5aE:
	;wait 2

	lip OUTP
	anim BZLO
skip5E:	outc
	;lp L
	decl
	jrnzp skip6aE
	lp L			;restore counter
	mvmd
	jp skip2E		;and continue in a0b0
skip6aE:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6E:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aF
	pop
	push		;3
	jp skip7F		;and continue in a1b1
skip5aF:
	;wait 2

	lip OUTP
	anim BZLO
skip5F:	outc
	;lp L
	decl
	jrnzp skip6aF
	lp L			;restore counter
	mvmd
	jp skip2F		;and continue in a0b0
skip6aF:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6F:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aG
	pop
	push		;3
	jp skip7G		;and continue in a1b1
skip5aG:
	;wait 2

	lip OUTP
	anim BZLO
skip5G:	outc
	;lp L
	decl
	jrnzp skip6aG
	lp L			;restore counter
	mvmd
	jp skip2G		;and continue in a0b0
skip6aG:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6G:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aH
	pop
	push		;3
	jp skip7H		;and continue in a1b1
skip5aH:
	;wait 2

	lip OUTP
	anim BZLO
skip5H:	outc
	;lp L
	decl
	jrnzp skip6aH
	lp L			;restore counter
	mvmd
	jp skip2H		;and continue in a0b0
skip6aH:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6H:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aI
	pop
	push		;3
	jp skip7I		;and continue in a1b1
skip5aI:
	;wait 2

	lip OUTP
	anim BZLO
skip5I:	outc
	;lp L
	decl
	jrnzp skip6aI
	lp L			;restore counter
	mvmd
	jp skip2I		;and continue in a0b0
skip6aI:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6I:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aJ
	pop
	push		;3
	jp skip7J		;and continue in a1b1
skip5aJ:
	;wait 2

	lip OUTP
	anim BZLO
skip5J:	outc
	;lp L
	decl
	jrnzp skip6aJ
	lp L			;restore counter
	mvmd
	jp skip2J		;and continue in a0b0
skip6aJ:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6J:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aK
	pop
	push		;3
	jp skip7K		;and continue in a1b1
skip5aK:
	;wait 2

	lip OUTP
	anim BZLO
skip5K:	outc
	;lp L
	decl
	jrnzp skip6aK
	lp L			;restore counter
	mvmd
	jp skip2K		;and continue in a0b0
skip6aK:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6K:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aL
	pop
	push		;3
	jp skip7L		;and continue in a1b1
skip5aL:
	;wait 2

	lip OUTP
	anim BZLO
skip5L:	outc
	;lp L
	decl
	jrnzp skip6aL
	lp L			;restore counter
	mvmd
	jp skip2L		;and continue in a0b0
skip6aL:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6L:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aM
	pop
	push		;3
	jp skip7M		;and continue in a1b1
skip5aM:
	;wait 2

	lip OUTP
	anim BZLO
skip5M:	outc
	;lp L
	decl
	jrnzp skip6aM
	lp L			;restore counter
	mvmd
	jp skip2M		;and continue in a0b0
skip6aM:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6M:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aN
	pop
	push		;3
	jp skip7N		;and continue in a1b1
skip5aN:
	;wait 2

	lip OUTP
	anim BZLO
skip5N:	outc
	;lp L
	decl
	jrnzp skip6aN
	lp L			;restore counter
	mvmd
	jp skip2N		;and continue in a0b0
skip6aN:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6N:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aO
	pop
	push		;3
	jp skip7O		;and continue in a1b1
skip5aO:
	;wait 2

	lip OUTP
	anim BZLO
skip5O:	outc
	;lp L
	decl
	jrnzp skip6aO
	lp L			;restore counter
	mvmd
	jp skip2O		;and continue in a0b0
skip6aO:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6O:	outc
;*******

	;lp K	
	deca
	jrnzp skip5aP
	pop
	push		;3
	jp skip7P		;and continue in a1b1
skip5aP:
	;wait 2

	lip OUTP
	anim BZLO
skip5P:	outc
	;lp L
	decl
	jrnzp skip6aP
	lp L			;restore counter
	mvmd
	jp skip2P		;and continue in a0b0
skip6aP:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip6P:	outc

	;deci
	;jpnz a0b1



	decm
	jpnz a0b1

	pop
	rtn


;**************************************************************
a1b1:				;ch1 on, ch2 on
				;when a counts down, go to a0b1
				;when b counts down, go to a1b0
	;lp K
	deca
	jrnzp skip7a
	pop		;3
	push
	jp skip5		;and continue in a0b1
skip7a:
	;wait 2

	lip OUTP
	orim BZHI
skip7:	outc
	;lp L
	decl
	jrnzp skip8a
	lp L			;restore counter
	mvmd
	jp skip4		;and continue in a1b0
skip8a:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8:	outc
;*******

	;lp K
	deca
	jrnzp skip7aB
	pop		;3
	push
	jp skip5B		;and continue in a0b1
skip7aB:
	;wait 2

	lip OUTP
	orim BZHI
skip7B:	outc
	;lp L
	decl
	jrnzp skip8aB
	lp L			;restore counter
	mvmd
	jp skip4B		;and continue in a1b0
skip8aB:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8B:	outc
;*******

	;lp K
	deca
	jrnzp skip7aC
	pop		;3
	push
	jp skip5C		;and continue in a0b1
skip7aC:
	;wait 2

	lip OUTP
	orim BZHI
skip7C:	outc
	;lp L
	decl
	jrnzp skip8aC
	lp L			;restore counter
	mvmd
	jp skip4C		;and continue in a1b0
skip8aC:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8C:	outc
;*******

	;lp K
	deca
	jrnzp skip7aD
	pop		;3
	push
	jp skip5D		;and continue in a0b1
skip7aD:
	;wait 2

	lip OUTP
	orim BZHI
skip7D:	outc
	;lp L
	decl
	jrnzp skip8aD
	lp L			;restore counter
	mvmd
	jp skip4D		;and continue in a1b0
skip8aD:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8D:	outc
;*******

	;lp K
	deca
	jrnzp skip7aE
	pop		;3
	push
	jp skip5E		;and continue in a0b1
skip7aE:
	;wait 2

	lip OUTP
	orim BZHI
skip7E:	outc
	;lp L
	decl
	jrnzp skip8aE
	lp L			;restore counter
	mvmd
	jp skip4E		;and continue in a1b0
skip8aE:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8E:	outc
;*******

	;lp K
	deca
	jrnzp skip7aF
	pop		;3
	push
	jp skip5F		;and continue in a0b1
skip7aF:
	;wait 2

	lip OUTP
	orim BZHI
skip7F:	outc
	;lp L
	decl
	jrnzp skip8aF
	lp L			;restore counter
	mvmd
	jp skip4F		;and continue in a1b0
skip8aF:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8F:	outc
;*******

	;lp K
	deca
	jrnzp skip7aG
	pop		;3
	push
	jp skip5G		;and continue in a0b1
skip7aG:
	;wait 2

	lip OUTP
	orim BZHI
skip7G:	outc
	;lp L
	decl
	jrnzp skip8aG
	lp L			;restore counter
	mvmd
	jp skip4G		;and continue in a1b0
skip8aG:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8G:	outc
;*******

	;lp K
	deca
	jrnzp skip7aH
	pop		;3
	push
	jp skip5H		;and continue in a0b1
skip7aH:
	;wait 2

	lip OUTP
	orim BZHI
skip7H:	outc
	;lp L
	decl
	jrnzp skip8aH
	lp L			;restore counter
	mvmd
	jp skip4H		;and continue in a1b0
skip8aH:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8H:	outc
;*******

	;lp K
	deca
	jrnzp skip7aI
	pop		;3
	push
	jp skip5I		;and continue in a0b1
skip7aI:
	;wait 2

	lip OUTP
	orim BZHI
skip7I:	outc
	;lp L
	decl
	jrnzp skip8aI
	lp L			;restore counter
	mvmd
	jp skip4I		;and continue in a1b0
skip8aI:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8I:	outc
;*******

	;lp K
	deca
	jrnzp skip7aJ
	pop		;3
	push
	jp skip5J		;and continue in a0b1
skip7aJ:
	;wait 2

	lip OUTP
	orim BZHI
skip7J:	outc
	;lp L
	decl
	jrnzp skip8aJ
	lp L			;restore counter
	mvmd
	jp skip4J		;and continue in a1b0
skip8aJ:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8J:	outc
;*******

	;lp K
	deca
	jrnzp skip7aK
	pop		;3
	push
	jp skip5K		;and continue in a0b1
skip7aK:
	;wait 2

	lip OUTP
	orim BZHI
skip7K:	outc
	;lp L
	decl
	jrnzp skip8aK
	lp L			;restore counter
	mvmd
	jp skip4K		;and continue in a1b0
skip8aK:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8K:	outc
;*******

	;lp K
	deca
	jrnzp skip7aL
	pop		;3
	push
	jp skip5L		;and continue in a0b1
skip7aL:
	;wait 2

	lip OUTP
	orim BZHI
skip7L:	outc
	;lp L
	decl
	jrnzp skip8aL
	lp L			;restore counter
	mvmd
	jp skip4L		;and continue in a1b0
skip8aL:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8L:	outc
;*******

	;lp K
	deca
	jrnzp skip7aM
	pop		;3
	push
	jp skip5M		;and continue in a0b1
skip7aM:
	;wait 2

	lip OUTP
	orim BZHI
skip7M:	outc
	;lp L
	decl
	jrnzp skip8aM
	lp L			;restore counter
	mvmd
	jp skip4M		;and continue in a1b0
skip8aM:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8M:	outc
;*******

	;lp K
	deca
	jrnzp skip7aN
	pop		;3
	push
	jp skip5N		;and continue in a0b1
skip7aN:
	;wait 2

	lip OUTP
	orim BZHI
skip7N:	outc
	;lp L
	decl
	jrnzp skip8aN
	lp L			;restore counter
	mvmd
	jp skip4N		;and continue in a1b0
skip8aN:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8N:	outc
;*******

	;lp K
	deca
	jrnzp skip7aO
	pop		;3
	push
	jp skip5O		;and continue in a0b1
skip7aO:
	;wait 2

	lip OUTP
	orim BZHI
skip7O:	outc
	;lp L
	decl
	jrnzp skip8aO
	lp L			;restore counter
	mvmd
	jp skip4O		;and continue in a1b0
skip8aO:
	;nopt		;3	;eliminate overhead
	;nopt		;3

	lip OUTP
	orim BZHI
skip8O:	outc
;*******

	;lp K
	deca
	jrnzp skip7aP
	pop		;3
	push
	jp skip5P		;and continue in a0b1
skip7aP:
	;wait 2

	lip OUTP
	orim BZHI
skip7P:	outc
	;lp L
	decl
	jrnzp skip8aP
	lp L			;restore counter
	;nopw
	mvmd
	jp skip4P		;and continue in a1b0
skip8aP:

	lip OUTP
	orim BZHI
skip8P:	outc

	decm
	jpnz a1b1

	pop
	rtn

;***************************************************************

drum:					; A is 1, 2 or 3
dinit:
	lp YL		;2	;1	;preserve song data pointer in Y
	liq XL		;4	;2
	mvb		;7	;1

dselect:
	rc		;2	;1	;clear carry NOTE: rc is unused?
	deca		;4	;1	;decrease offset byte
	lp XL		;2	;1	;set lobyte of drum table pointer-1
	exam		;3	;1
	lp XH		;2	;1	;set hibyte of drum sound/table pointer-1
	lia >(sdata-1)		;4	; PC-1403 0x88	2
	exam		;3	;1
	ixl				;load offset from table
	lp XL
	exam
	lip OUTP	;4	;2	;set pointer to value for Port C
			;39
playDrum:
	ixl		;7	;1	;load next counter value
	cpma		;3	;1	;(P)=0, so we can do this and save 1 byte
	jrzp dexit	;7/4	;2	;exit if counter val=0
	
	orim BZHI	;4	;1	;beeper on
	outc		;2	;1
dwait1:
	deca		;(4)	;1
	jrnzm dwait1	;(7)/4	;2	sum=11*sum_of_odd_bytes

	anim 0xef	;4	;2	;mask for beeper off NOTE: anim 0xef but why?
	ixl		;7	;1	;load next counter value	
	cpma		;3	;1	;if it is 0
	jrzp dexit	;7/4	;2	;exit

	outc		;2	;1
dwait2:
	deca		;(4)	;1
	jrnzm dwait2	;(7)/4	;2	sum=11*sum_of_even_bytes
	
	jrm playDrum	;7	;2
			;51*number_of_bytes

dexit:
	lp XL		;2	;1	;restore song data pointer
	liq YL		;4	;2
	mvb		;7	;1
	lp M		;2	;1	;adjust primary speed counter
	lia 21		;4	;2
	sbm		;3	;1
	rtn		;4	;1
			;26	;45
			;39+26+7+[51*number_of_bytes]+[11*sum_of_bytes]
		
;***************************************************************

	.rept 9				;padding
	.db 0
	.endm

drumTable::				;must be located at page-aligned address+1 0xHH01

	;lobyte of address into drum1/2/3 tables, e.g. 0xHH03,0xHH1d,0xHH66
	.db 0x03,0x1d,0x66

drum1:					;located at 0xHH03
	.db 1,4,3,8,6,4,9,8,8,8
	.db 16,16,16,32,32,32,32
	.db 64,64,64,64,65
	.db 128,128,128,0
	
drum2:					;located at 0xHH1d
	.db 4,3,8,6,4,9,8,8,8
	.db 16,16,16,32,32,32,32,64,64,64
	.db 16,4,15,22,11,13,22,15,7
	.db 19,12,2,11,15,3,5,7,15,18
	.db 20,19,17,9,20,11,18,15,2,3
	.db 11,9,11,15,9,12,7,15,8,16
	.db 8,14,7,4,11,15,21,15,22,7
	.db 17,17,25,20,0

drum3:					;located at 0xHH66
	.db 5,2,4,1,5,8,2,3,8,7
	.db 5,3,5,8,4,8,6,6,1,7
	.db 7,4,2,7,5,8,6,8,8,5
	.db 3,3,7,2,3,3,4,6,5,8
	.db 5,8,5,5,1,5,3,4,3,7
	.db 6,3,1,8,6,1,6,2,2,1
	.db 6,6,3,6,8,7,3,1,8,7
	.db 4,2,1,4,1,255,255,0
	
sdata:
