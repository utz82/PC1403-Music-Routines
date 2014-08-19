#!/bin/sh

./xm2osk.pl
./yasm.pl -r test.bin -w test.wav main.asm
./yasm.pl -r music.bin -w music.wav music.asm
