Osaka-II Music Routine for Sharp PC-1403(H)
by utz 07/2014


USAGE
=====

First of all, you need Yagshi's SC61860 Assembler (YASM) present in your working
directory.
YASM can be found at http://www.oit.ac.jp/bme/~yagshi/misc/pocketcom/yasm-e.html.

To compile the music player + song data, run compile.sh resp. compile.bat.
This will output two files, test.wav and music.wav.
test.wav is the player, load it on your Sharp with CLOAD M 33000.
music.wav is the music data, load this with CLOAD M 34997. You can load another
data block without reinstalling the player.

Invoking the xm2osk utility will simply convert your music.xm to an .asm file
containing the music data. By adding the "-v" command line parameter, you can get 
xm2osk to print some debug info.


COMPOSING MUSIC
===============

Use the music.xm template to compose music in any standard XM editor, eg. Milkytracker.
The sound of the template is only a very rough approximation of how things will sound
on the Sharp PC.


The following restrictions apply:

1) TONES
Tones must be in track 1 and 2. Valid note range is from A-1 to G#5. Detuning may occur
in higher octaves (from D#4 onwards), the sound of the xm template does not reflect this.

2) DRUMS
Drums can be placed in track 3 or 4 (but never more than 1 drum per row). Pitch is ignored.

3) EFFECTS

You can use the Fxx command anywhere to set the tempo. Valid values are $06..$1F.
Global tempo setting is also used, but BPM is ignored (so best don't change it).

You can use special command E5x to detune notes (E58 = no detune).

All other effects and settings are ignored.

