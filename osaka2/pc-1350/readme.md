Osaka-II Music Routine for Sharp PC-1350 and PC-1403(H)
=======================================================
by utz 07/2014 updated by Robert van Engelen 5/2021 for PC-1350


USAGE FOR THE PC-1350
---------------------

To load the program on your PC-1350, convert `play.bin` to `play.wav` with
`bin2wav --type=bin --addr=24808 --pc=1350 play.bin` using the `bin2wav`
utility of the [Pocket Tools](https://www.peil-partner.de/ifhe.de/sharp/), then
`CLOAD M 24808` on your PC-1350 and play the `play.wav` file to load the
program on the PC-1350 e.g. via the CE-126P printer and cassette interface.
`CALL 24808` after loading was successful.

Alternatively, on a 16K expanded PC-1350 with CE-202M RAM card, you can load
the `play.bas` bootloader via SIO and `RUN` it to save the code.  `CALL 24808`
after `RUN`.

For best sound quality, use the cassette interface output to attach a speaker,
e.g. a pair of inexpensive desktop PC speakers will do.


PORTING TO OTHER SHARP PC
-------------------------

If you want to rebuild the binary or the BASIC bootloader for another SHARP
Pocket Computer, then you will need to install and run the AS61860 assembler
and ASLINK linker.  Download the assembler and linker from
https://shop-pdp.net/ashtml/asmlnk.htm.

Edit `target.h` and change the `BASE` address to `0xHHe8`, where `HH` is a
suitable hibyte RAM address for your SHARP that is available, i.e. sits between
the BASIC program memory and the variables.  This requires 2772 bytes of RAM
space.  For the PC-1403(H) `BASE=0x80e8` (33000) and for the PC-1350
`BASE=0x608e` (24808).

Run `make` to rebuild `play.bin` and `play.bas`.  The `play.bas` program is a
bootloader BASIC program that requires >10K of BASIC RAM memory.  The target
`BASE` address in `target.h` should be above the bootloarder BASIC to prevent
the bootloader from destroying itself.  So this only works on pocket computers
with sufficient memory.


CONVERTING XM TO ASM
--------------------

Invoking the xm2osk utility will convert your `music.xm` to an `.asm` file
containing the music data. By adding the `-v` command line parameter, you can
get xm2osk to print some debug info.


COMPOSING MUSIC
---------------

Use the `music.xm` template to compose music in any standard XM editor, eg.
Milkytracker.  The sound of the template is only a very rough approximation of
how things will sound on the Sharp PC.


The following restrictions apply:

1) TONES
Tones must be in track 1 and 2. Valid note range is from A-1 to G#5. Detuning
may occur in higher octaves (from D#4 onwards), the sound of the xm template
does not reflect this.

2) DRUMS
Drums can be placed in track 3 or 4 (but never more than 1 drum per row). Pitch
is ignored.

3) EFFECTS

You can use the Fxx command anywhere to set the tempo. Valid values are
$06..$1F.  Global tempo setting is also used, but BPM is ignored (so best don't
change it).

You can use special command E5x to detune notes (E58 = no detune).

All other effects and settings are ignored.

