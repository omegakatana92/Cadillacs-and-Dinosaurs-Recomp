# Changelog

## 0.1.0-beta.1

The first beta of the native *Cadillacs and Dinosaurs* port.

- The game's 68000 program and QSound sound program translated to C++ with cps2recomp
  v0.4.0-beta.4, on the toolkit's CPS-1 + QSound machine; no emulator inside.
- Three players, a keyboard or gamepad each, with the game's own **Attack** and **Jump** buttons.
- Free play, **Start at stage**, **Straight to the title**, and the board's operator settings on
  the **Board** page.
- Cheats: infinite health, infinite lives, infinite time.
- Save states, speed, pause and frame advance, run-ahead, remappable controls and display options.
- Alternative modes: attract mode, score attack, stage viewer and model viewer.
- A custom soundtrack: the player's own music files in place of the board's music.
- Windows x64, Linux x86_64 and Steam Deck builds. The Linux builds are made on Ubuntu 22.04
  (glibc 2.35) so they run on SteamOS 3.5 and everything since.

No game files, keys, BIOS files, artwork or screenshots are included. The player brings their own
`dino` ROM set.
