# Cadillacs and Dinosaurs Recomp

An unofficial native PC port of *Cadillacs and Dinosaurs* (Capcom, 1993), made by static
recompilation with [cps2recomp](https://github.com/tmcleroy/cps2recomp). The game's 68000 program
and its QSound sound program are translated to C++ ahead of time and compiled into the port; there
is no emulator inside it.

**No game files are included.** You need your own copy of the arcade ROM set **`dino`**
(*Cadillacs and Dinosaurs*, World 930201), from a board you own. The port cannot help you get one.
The set is a CPS-1 board with QSound; its program is not enciphered, so it has **no key file**.

This project is not affiliated with, endorsed by or sponsored by Capcom. *Cadillacs and Dinosaurs*
is a trademark of its owners.

## Status

**Beta.** The translated code is checked against the toolkit's interpreter and the port runs
through the game's stages in made-up play, but it has not been played by hand from end to end, and
its sound has not been listened to. Expect rough edges.

## What it is

- A beat-'em-up for up to **three players at once**, each with a keyboard layout or a gamepad.
- The board's two buttons are called what the game calls them: **Attack** and **Jump** (both
  together: the special attack).
- Free play, a **Start at stage** choice for any of the eight stages, and **Straight to the title**.
- Cheats: infinite health, infinite lives and infinite time.
- The board's operator settings on the **Board** page (difficulty, difficulty 2, extend, lives,
  continue, demo sound), each as the board is set unless chosen.
- Alternative modes: attract mode (all of it, or only the story, the demonstrations or the
  characters), score attack, a stage viewer and a model viewer.
- A custom soundtrack: your own music files in place of the board's music.
- Save states, speed, pause, frame advance, run-ahead, remappable controls, and the display
  options (sharp, whole pixels or smooth; 4:3, square pixels or the whole screen).
- Your ROM set is only ever read. Settings, save states and the board's settings memory go in
  your own user folder.

## What you need

- The ROM set `dino` (*Cadillacs and Dinosaurs*, World 930201): `dino.zip` or a folder with the
  set's files. It has no key file. The launcher checks every file by CRC-32 and tells you which is
  missing or different.
- Windows 10/11 64-bit, Linux x86_64 (SteamOS 3.5 or later included), or macOS 13 or later.

## Playing

1. Start the launcher (`dino-launcher.exe`, `dino-launcher`, or the AppImage).
2. Point it at the folder that holds the set's files, or at `dino.zip`.
3. Set the controls and any features you want, then press **Play**.

In game, Esc or F1 opens the in-game menu (save states, Insert coin, Reset, Quit, and every
feature). P, O and -/= stop, step and slow the game. Everything is remappable in the launcher.

## Building from source

The toolkit copy in `cps2recomp/` is a copy of **cps2recomp v0.4.0-beta.4** with its own `games/`
and `example/` left out. It is checked by `make check-toolkit` and must not be changed here.

### Windows (MSYS2 MinGW64)

The toolkit passes `$(CURDIR)` to CMake unquoted, so build from a path with no spaces. From an
**MSYS2 MinGW64** shell:

```sh
subst G: C:\path\to\Cadillacs-and-Dinosaurs-Recomp
cd /g
export PATH=/mingw64/bin:$PATH
make                 # first build: interpreter only, then translated code
make explore         # once: find the game's code by made-up play
make                 # translate what explore found
make launcher
make check
make check-toolkit
make check-common
```

`make` also copies the MinGW runtime DLLs beside the programs so they start with a double-click.
Put your ROM set in `rom/dino/` (ignored by Git) or pass `ROM=path`.

### Linux

The same commands in a shell, with a C++20 compiler, CMake, Ninja, Python 3, zlib and SDL 3
installed. For a release that runs on SteamOS 3.5 and everything since, build on **Ubuntu 22.04
(glibc 2.35)**, not on a newer distribution.

## Releases

Releases are built **by hand** on a machine that has the ROM set and the translated code in
`work/dino/gen`, never by CI (CI has no ROM set). See [tools/release/README.md](tools/release/README.md).

## License and credits

GPL-3.0-only; see [LICENSE](LICENSE) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

The toolkit, the CPS-1/QSound machine, the launcher and the game-side sources for this port come
from [cps2recomp](https://github.com/tmcleroy/cps2recomp) by Tommy McLeroy (GPL-3.0). The release
scripts and repository layout follow
[Hyper-Street-Fighter-II-Recomp](https://github.com/omegakatana92/Hyper-Street-Fighter-II-Recomp-).
The ROM set's files, program, graphics and sound are the player's own and are not in this
repository or in any archive it publishes.
