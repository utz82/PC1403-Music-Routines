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

pc1403:
	@echo '** target: PC-1403(H) **'
	@echo '.globl BASE' > $(TRG)
	@echo 'BASE = 0x80e8 ; for PC-1403(H)' >> $(TRG)
	@make

pc1350:
	@echo '** target: PC-1350 **'
	@echo '.globl BASE' > $(TRG)
	@echo 'BASE = 0x60e8 ; for PC-1350' >> $(TRG)
	@make

pc2500:
	@echo '** target: PC-2500 **'
	@echo '.globl BASE' > $(TRG)
	@echo 'BASE = 0x60e8 ; for PC-2500' >> $(TRG)
	@make

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
	$(RM) *.rel *.sym *.hlr *.map *.lst *.rst *.img *.wav $(HEX) $(IHX2BAS) $(IHX2BIN) $(LDR)

.PHONY:	all clean distclean pc1350 pc1403
