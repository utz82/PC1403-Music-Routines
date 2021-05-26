Osaka-II Music Routine for Sharp PC-1350 and PC-1403(H)
=======================================================
by utz 07/2014 updated by Robert van Engelen 5/2021

For this project you will need a C compiler and the AS61860 assembler and
ASLINK linker.  Download the AS61860 assembler with ASLINK linker from
https://shop-pdp.net/ashtml/asmlnk.htm.

For best sound quality, use the cassette interface of the SHARP Pocket Computer
to attach a speaker to the MIC port of the cassette interface connected to the
11 pin port of the Pocket Computer.  A pair of inexpensive desktop PC speakers
should work.  Because the audio jack should be mono, in rare cases some stereo
jacks and speakers may not pick up the sound signal.


FOR THE PC-1403
---------------

Run `make pc1403` to create `play.bin`.  Convert `play.bin` to `play.wav` with
`bin2wav --type=bin --addr=33000 --pc=1403 play.bin` using the `bin2wav`
utility of the [Pocket Tools](https://www.peil-partner.de/ifhe.de/sharp/), then
`CLOAD M 33000` on your PC-1403 and play the `play.wav` file to load the
program on the PC-1403 e.g. via the CE-126P printer and cassette interface.
`CALL 33000` after loading was successful.


FOR THE PC-1350
---------------

Run `make pc1350` to create `play.bin`.  Convert `play.bin` to `play.wav` with
`bin2wav --type=bin --addr=24808 --pc=1350 play.bin` using the `bin2wav`
utility of the [Pocket Tools](https://www.peil-partner.de/ifhe.de/sharp/), then
`CLOAD M 24808` on your PC-1350 and play the `play.wav` file to load the
program on the PC-1350 e.g. via the CE-126P printer and cassette interface.
`CALL 24808` after loading was successful.

Alternatively, on a 16K expanded PC-1350 with a CE-202M RAM card, you can load
the `play.bas` bootloader via SIO and `RUN` it to save the code.  `CALL 24808`
after `RUN`.


PORTING TO OTHER SHARP PC
-------------------------

If you want to rebuild the `play.bin` binary or the `play.bas` bootloader for
another SHARP Pocket Computer, then edit the makefile and add a recipe for the
Pocket Computer:

~~~
pcXXYY:
	@echo '** target: PC-XXYY **'
	@echo '.globl BASE' > $(TRG)
	@echo 'BASE = 0xHHe8 ; for PC-XXYY' >> $(TRG)
	@make
~~~

where `HH` in `BASE = 0xHHe8` is the highbyte base address of a RAM area with
2772 bytes available to store the program, i.e. sits between the BASIC program
memory and the variables.  For the PC-1403(H) `BASE=0x80e8` (33000) and for the
PC-1350 `BASE=0x608e` (24808).

Run `make pcXXYY` to rebuild `play.bin` and `play.bas`.  The `play.bas` program
is a bootloader BASIC program that requires >10K of BASIC RAM memory.  The
target `BASE` address should be above the bootloarder BASIC to prevent the
bootloader from destroying itself.  So this only works on Pocket
Computers with sufficient RAM.


CONVERTING XM TO ASM
--------------------

Invoking the xm2osk utility will convert your `music.xm` to an `.asm` file
containing the music data.  By adding the `-v` command line parameter, you can
get xm2osk to print some debug info.


COMPOSING MUSIC
---------------

Use the `music.xm` template to compose music in any standard XM editor, eg.
Milkytracker.  The sound of the template is only a very rough approximation of
how things will sound on the Sharp PC.


The following restrictions apply:

1) TONES
Tones must be in track 1 and 2.  Valid note range is from A-1 to G#5.  Detuning
may occur in higher octaves (from D#4 onwards), the sound of the xm template
does not reflect this.

2) DRUMS
Drums can be placed in track 3 or 4 (but never more than 1 drum per row).
Pitch is ignored.

3) EFFECTS

You can use the Fxx command anywhere to set the tempo.  Valid values are
$06..$1F.  Global tempo setting is also used, but BPM is ignored (so best don't
change it).

You can use special command E5x to detune notes (E58 = no detune).

All other effects and settings are ignored.

