# Cadillacs and Dinosaurs: progress

## This repository

- **The ROM set** is `dino` (World 930201), the parent set. It is a **CPS-1 board with QSound**,
  not a CPS-2: the program is not enciphered and the set has **no key file**. The PAL dumps in the
  set are not read.
- **The toolkit.** The copy this port started from (`cps2recomp-0.3.0`) is CPS-2-only: its ROM
  loader always requires and decodes a CPS-2 key file, its machine has no CPS-1 video register
  layout, and it has no Kabuki deciphering for the CPS-1 QSound program. It cannot load `dino`.
  The port therefore uses **cps2recomp v0.4.0-beta.4** (upstream commit
  `5da369633cfe81357bbf3c9824718ad73563f020`), the first toolkit with the CPS-1 + QSound machine,
  CPS-B register setup and Kabuki. The copy in `cps2recomp/` is that toolkit without its `games/`
  and `example/`; it is checked by `make check-toolkit`.
- **The game-side sources** in `games/dino/src/` are based on the dino port that ships with
  cps2recomp v0.4.0-beta.4 (GPL-3.0), adapted to this repository. No change to `cps2recomp/` was
  needed or made.

## How it is made

- **The board**: a CPS-1 with QSound (`board = cps1` in `game.cfg`). Its CPS-B-21 is set up as
  MAME's table of the chips has it for this game (QS2): layer control at `0A`, priority masks
  `0C 0E 00 02`, palette control `04`, layer enable bits `16` (the game never uses them); its
  graphics PAL (CD63B) maps tiles to the ROMs in order.
- **The sound program** (`cd_q.5k`): its first 32 KB are enciphered (Kabuki). `machine/kabuki.cpp`
  works the key out from the program's first instructions (Capcom's QSound driver, "version 1.00
  1992 / JUNE", which starts with a clear of its memory before the CPS-2's start) and its interrupt
  routine, and checks the candidates by following their code. No key is stored anywhere: it is
  worked out from the player's own ROM when the set is loaded.
- **Translated code**: `make explore` found the code; see the build log below. The sound program is
  translated too.

## What is known of the game (`src/dino.h` has the names)

- A5 is `FF8000`. Coin chutes: three records of 16 bytes from A5+47A, credits at +3.
- **Settings**: the game reads three bytes laid out as the older CPS-1 boards' DIP switches
  (A5+777A-777C), packed by `0AC86E` from the settings the test menu shows (A5+775A on, kept at
  776D-776F) as the board starts, and copied again by `0A86D8` when the test menu is left. B bits
  0-2 difficulty (0-7, 3), B 3-4 difficulty 2 (0-3, 1), B 5-6 extend (0-3, 2), C 0-1 lives (0-3
  for 1-4, 1), C bit 5 demo sound, C bit 6 continue.
- **The game's step** A5+4D0 (4 a game beginning, 0C playing, 08 between stages, 1C a stage's end)
  and the **stage** A5+4D9 (0-7): `00ABE8` steps it on at a stage's end; `00004CEE` clears it with
  the game's other variables as a game begins (called at `00A9EC`; `00A9F2` is hooked for "Start at
  stage").
- **The clock**: minutes A5+4E8, BCD seconds A5+4E9, counted down at `0103C0` each time the frame
  count A5+4EA (from 0x32) runs out.
- **Players**: three records of 0x180 from `FFB274` (`3274(a5)`, `33F4(a5)`, `3574(a5)`): +00 in
  play (1), +6D health (0x64 full), +A3 lives after this one.
- **The show**: A5+35 goes 10, 30, 40, 50 as the board starts, 50 as the title is drawn (about
  frame 312). The show is a task that goes through four lists of parts (by the byte at `FF0FD0`,
  the table at `097C88`), each part a routine it calls: the title (`09A3CE`, and `098330` its
  second screen), the characters' files (`09A7E6`), a demonstration (`099E88`, from `097D6C` and
  `097D78`, which count them: the count picks the stage; the step is 0C in them too), the story
  (`0988C0`), the best scores (`0983D8`), the opening (`09BF50`). A game over is the step 10, 14,
  18, held until the show's next demonstration.
- **Score**: a player's record +100 (long, BCD; a copy at +110).
- **Sound**: the sound program's table of songs is at `8006` after a word of their number (0x106);
  `src/music.cpp` names the pieces found by playing. The game asks for music as the CPS-2 games do
  (the shared memory's first sixteen bytes).
- **The camera** (`src/viewer.cpp`): a record at `FF873C`, its place across at +08 and up and down
  at +0C. Each episode is a list of segments (16 bytes, from the table at `021B2A` by episode):
  where each begins (+0, or +2 up and down when +F is set), the camera's way of moving in it (+B;
  04 holds it until the wave is beaten and +6D is set, 06 the episode's end, 01 on to the next
  part), and its part (+A, kept at +4A = `FF8786`). A part a game can be continued from has a place
  to start at (`021580`: ten bytes a part by episode; a part with none goes on from the one
  before). The camera's set-up (`0206EA`) starts at segment 0 unless its way is 0E or 0F, loads it
  (`02099A`) and takes the part's start; its routine works out its place (the ways' routines, from
  the table at `02092E`) and from `02126E` draws the new columns and rows.
- **Objects**: two pools of 24 records of 0xC0 (`FF8874`, run by `0233E2`; `FFB6F4`, after the
  players', by `023620`). A record's frame is at +28: 12 bytes, two words of its picture, a long
  whose last byte is its time (its top bit: the next word says how far on the frame after it is),
  two words more (`00143E` for the players: +2C the long, +48 and +60 the words, +4C the picture
  from the table at `11D220`). The object list (CPS-1: in video RAM, at the CPS-A's first
  register's place) is written by `0143xx`-`0145xx` with `movem`; an object's colours may be its
  record's +23.
- **Characters**: a player's +03 (0 Jack, 1 Mustapha, 2 Hannah, 3 Mess), which can be put in as a
  game begins; their objects are in colours 0, 2, 1 and 3. Six lists of animations each, from the
  tables at `00163E`, `00164E` ... `00168E`; a list ends at a 0 offset (as many as its first offset
  is twice, that 0 among them). A frame whose time byte's top bit is set is followed by a word,
  always negative, that says how far back the next is; Jack's A29 says forward and is not an
  animation (forced on him, the game crashes).

## Build log

Built on Windows 10/11 x64 with MSYS2 MinGW64 (GCC), from a path without spaces (`G:`), with a
ROM set extracted to `rom/dino/` (all 16 files match `game.cfg` by CRC-32).

**First `make`** (a fresh tree, so interpreter only, then translated code):

```
recomp: 17 entries -> 86439 instructions (341458 bytes) in 20195 blocks, 4329 routines, 56 files; 164 left to the interpreter (25 of them not instructions: data a guess took for code)
        of those, 71659 instructions from 1534 guessed entries
recompz80: 2 entries -> 1292 instructions (2647 bytes) in 162 blocks, 16 routines; 0 left to the interpreter
```

**`make explore`** (four rounds; `explore_features = free_play`; no ladder feature is set for this
game, so the ladder rounds are skipped). Each round plays with made-up input, then the game is
rebuilt from what the round found:

| Round | Seeds | Frames | Mode | `entries.txt` | `entries.txt.z80` |
|-------|-------|--------|------|---------------|-------------------|
| 1 | 1-6   | 12,000 | both players  | 0 -> 338   | 0 -> 384   |
| 2 | 10-21 | 40,000 | both players  | 338 -> 485 | 384 -> 387 |
| 3 | 30-41 | 60,000 | one player    | 485 -> 499 | 387 -> 387 |
| 4 | 50-55 | 30,000 | test switch   | 499 -> 499 | 387 -> 398 |

The rounds translated 93,181, 94,307, 94,393 and 94,393 instructions as they went (the last two
rounds found no new 68000 code). **The final translation**, after `make explore` and `make`:

```
recomp: 516 entries -> 94393 instructions (372432 bytes) in 22193 blocks, 4765 routines, 60 files; 190 left to the interpreter (30 of them not instructions: data a guess took for code)
        of those, 62695 instructions from 1492 guessed entries
recompz80: 400 entries -> 2210 instructions (4663 bytes) in 596 blocks, 77 routines; 0 left to the interpreter
```

The 190 places left to the interpreter are data or code no run reached; a 12,000-frame run with
made-up play (seed 1, from frame 400) reports:

```
12000 frames in 19.42 s: 618 a second (cpu: native)
sound driver: 0 instructions had no translation
0 instructions had no translation and ran in the interpreter (about 0.000% of the run)
```

`make` (final), `make launcher`, `make check`, `make check-toolkit` and `make check-common`:

- `make`: translated code rebuilt, `deps: 5 DLLs beside build/dino/`.
- `make launcher`: `build/dino/dino-launcher.exe` built.
- `make check`:
  ```
  ok: translated code does what the interpreter does (3000 frames)
  ok: two runs alike (3000 frames)
  ```
- `make check-toolkit`: `cps2recomp/: commit 5da369633cfe81357bbf3c9824718ad73563f020`.
- `make check-common`: `recomp-common/: commit 91b4e510642ed0820f2a56a7dd71f3d2d7104266`.

## Not done yet

- Five pieces of music not placed (fanfares played once), and the ending not reached.
- Weapon cheats (the guns' ammunition): not found yet.
- Nobody has played it by hand; the sound has not been listened to (it plays: the chip is written
  and the output is loud in play, quiet in the attract with demo sound off).
