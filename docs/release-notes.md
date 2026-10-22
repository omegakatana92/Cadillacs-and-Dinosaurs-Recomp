# Cadillacs and Dinosaurs Recomp 0.1.0-beta.1

The first beta of the native *Cadillacs and Dinosaurs* port (Capcom, 1993), made with
[cps2recomp](https://github.com/tmcleroy/cps2recomp) v0.4.0-beta.4 by static recompilation.

**No game files are included.** You need your own `dino` ROM set (World 930201) from a board you
own. The set is a CPS-1 board with QSound; it has no key file. This release cannot help you get a
ROM set and does not contain one.

## Download

| System | File |
| --- | --- |
| Windows 10/11, 64-bit | `Cadillacs-and-Dinosaurs-windows-x64.zip` |
| Linux x86_64 / Steam Deck / SteamOS 3.5+ | `Cadillacs-and-Dinosaurs-linux-x86_64.tar.gz` |
| Linux x86_64 (single-file) | `Cadillacs-and-Dinosaurs-linux-x86_64.AppImage` |

`SHA256SUMS.txt` has the SHA-256 of each archive.

## What is in the port

- The 68000 program and the QSound sound program translated to C++ ahead of time; no emulator is
  inside.
- Three players at once, each with a keyboard layout or a gamepad. The game's buttons are
  **Attack** and **Jump** (both together: the special attack).
- Free play, **Start at stage** (any of the eight stages), **Straight to the title**.
- The board's operator settings on the **Board** page (difficulty, difficulty 2, extend, lives,
  continue, demo sound).
- Cheats: infinite health, infinite lives, infinite time.
- Alternative modes: attract mode (all, story only, demonstrations only, characters only), score
  attack, stage viewer and model viewer.
- A custom soundtrack: your own music files in place of the board's music.
- Save states, speed, pause and frame advance, run-ahead, remappable controls, and display
  options (sharp, whole pixels or smooth; 4:3, square pixels or the whole screen).

## Install and play

### Windows
1. Extract the whole zip to a folder of your own (not Program Files).
2. Run `dino-launcher.exe`.
3. Point the launcher at the folder that holds your `dino` set, or at `dino.zip`. It checks every
   file by CRC-32.
4. Press **Play**.

### Linux and Steam Deck
1. Unpack the tarball where it can stay, or run the AppImage.
2. Run `dino-launcher` (the AppImage starts it for you).
3. Point the launcher at your `dino` set and press **Play**.

The Linux builds are made on Ubuntu 22.04 (glibc 2.35), so they run on SteamOS 3.5 and every
SteamOS since. SDL 3 is linked in; the programs need only the system's usual X11/Wayland, sound and
zlib libraries.

## Known issues

- This is a beta: the port has been checked against the interpreter and driven through the game in
  made-up play, but it has not been played by hand from start to finish, and the sound has not been
  compared with a board.
- Five short pieces of music are not placed yet.
- The ending has not been reached by the made-up play.
- Weapon cheats have not been found.

## Building

The source is in the repository, including the translated code's generator and the toolkit copy.
The player's own ROM set is needed to build; see `docs/BUILDING.md`. Releases are built by hand on
a machine with the ROM set, never by CI.
