# c64-10-Print-maze-in-6502-assembly-
The famous "10 PRINT CHR$(205.5+RND(1));:GOTO 10" in 6502 assembly for the Commodore 64.


By: Ben M, aka BTM86  (2023)

This is just somthing I made for a bit of fun. There are much simpler ways to make the random maze program in assembly with the use of the $FFD2 kernal call. but this on the other hand uses it's own scrolling routines.

The entire thing is more or less written in 6502 assembly, with the exception of the part at the beginning that prompts the user about the speed. That part is written in basic, but all the maze generation and scrolling routines are written in Assembly. 


NOTE: If you use RUN/STOP + RESTORE to reset the machine after running it in full speed mode, you will need to POKE 254 with 0 if you want to run it in slow mode. This is a bug that I may fix in the future. 

ALSO NOTE: This program uses the SID chip to aid in the random number generation, so a working SID or compatible substitute is required.

I hope you find it intersing and maybe learn something. 
