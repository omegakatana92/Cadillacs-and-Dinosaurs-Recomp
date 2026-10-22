Cadillacs and Dinosaurs - recomp port (Windows x64)
===================================================

A native PC port of Cadillacs and Dinosaurs (Capcom, 1993, CPS-1 arcade board with QSound),
made with tmcleroy's cps2recomp (https://github.com/tmcleroy/cps2recomp) by static recompilation.
NOT affiliated with, endorsed by or sponsored by Capcom. Cadillacs and Dinosaurs is a trademark
of Capcom Co., Ltd.

NO GAME FILES ARE INCLUDED. You need your own copy of the game: the arcade ROM set "dino"
(World, 930201), from a board you own. This archive cannot help you get one. Other regions and
revisions do not work and are refused on purpose. The set has no key file: the CPS-1 program is
not enciphered.


How to play
-----------
1. Double-click dino-launcher.exe.
2. Choose your ROM set: point the launcher at the folder that holds the set's files, or at
   the set's .zip. It checks every file by CRC-32 before it will run.
3. Set the controls and any features you want, then Play.

The game takes up to three players. Its two buttons are Attack and Jump (both together: the
special attack); on a gamepad they start on X and Y.

In game: Esc or F1 opens the menu (save states, Insert coin, Player 2 and 3 join, Reset, Quit).
P, O and -/= stop, step and slow the game. Everything is remappable in the launcher.


What is in here
---------------
dino.exe                the game
dino-launcher.exe       the launcher (keep it beside the game)
SDL3.dll               \
zlib1.dll               >  the runtime libraries the two programs need
libgcc_s_seh-1.dll     /   (keep them all in this folder, beside the .exe files)
libstdc++-6.dll       /
libwinpthread-1.dll  /
licenses/              the licences of the port and of everything shipped with it

Keep the .exe and .dll files together in one folder. Save states, settings and the board's
settings memory are kept beside them (or wherever you run the game from).

The port is GPL-3.0; its source, and how it was made, are at
https://github.com/omegakatana92/Cadillacs-and-Dinosaurs-Recomp
You can also build it yourself from that source. To play, you still need your own ROM set.
