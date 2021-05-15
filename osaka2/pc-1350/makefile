# tools

# AS61860 assembler
ASM=../../as61860
ASMFLAGS=-los

# ASLINK linker
LNK=../../aslink
LNKFLAGS=-imwu -b play=BASE

# C compiler
CC=cc

# ihx conversion tools (included)
IHX2BAS=./ihx2bas
IHX2BIN=./ihx2bin

RM=rm -f

# files

LDR=play.bas play.bin
HEX=play.ihx
OBJ=main.rel music.rel
TRG=target.h

# rules

all:	$(LDR)

%.rel:	%.asm $(TRG)
	$(ASM) $(ASMFLAGS) $<

$(HEX): $(OBJ)
	$(LNK) $(LNKFLAGS) $(basename $@) $(OBJ)

%.bas:	%.ihx $(IHX2BAS)
	$(IHX2BAS) $<

%.bin:	%.ihx $(IHX2BIN)
	$(IHX2BIN) $<

$(IHX2BAS):	ihx2bas.c
		$(CC) -o $@ $<

$(IHX2BIN):	ihx2bin.c
		$(CC) -o $@ $<

clean:
	$(RM) *.rel *.sym *.hlr *.map *.lst *.rst

distclean:
	$(RM) *.rel *.sym *.hlr *.map *.lst *.rst *.ihx *.img *.wav $(IHX2BAS) $(IHX2BIN)

.PHONY:	all clean distclean
