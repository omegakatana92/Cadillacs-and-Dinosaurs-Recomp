# Building

The port is a game repository for **cps2recomp v0.4.0-beta.4**. The toolkit copy is in
`cps2recomp/`; it is checked by `make check-toolkit` and must not be edited here.

## What you need

- A C++20 compiler (GCC, Clang or MinGW-w64), CMake 3.28 or later, Ninja, Python 3, zlib and
  SDL 3.
- The `dino` ROM set (World 930201), in `rom/dino/` or given as `ROM=/path/to/dino.zip`. It has no
  key file: the CPS-1 program is not enciphered.

## Windows (MSYS2 MinGW64)

The toolkit passes `$(CURDIR)` to CMake **unquoted**, so a repository path with a space in it
breaks the build. Put the repository on a path without spaces and map a drive to it:

```sh
subst G: C:\path\to\Cadillacs-and-Dinosaurs-Recomp
```

From an **MSYS2 MinGW64** shell (`C:\msys64\mingw64.exe`):

```sh
cd /g
export PATH=/mingw64/bin:$PATH
make
make explore
make
make launcher
make check
make check-toolkit
make check-common
```

`make` also copies the MinGW runtime DLLs beside the programs. The first `make` is
interpreter-only (the port has no translated code yet and writes its program out when run); the
second translates it. `make explore` is needed once per fresh tree.

## Linux

Install the usual development packages (a Debian/Ubuntu list is in
`tools/release/README.md`), then run the same make commands. For a release that runs on SteamOS
3.5 and everything since, build on **Ubuntu 22.04** (glibc 2.35); a newer glibc makes binaries that
older systems refuse.

The port and the launcher use SDL 3. The release scripts build SDL 3 as a static library, so the
published programs need only the system's usual X11/Wayland, sound and zlib libraries.

## Checks

- `make check` runs the translated code beside the interpreter, frame by frame, by state hash, and
  runs the same input movie twice to prove the runs are alike.
- `make check-toolkit` proves `cps2recomp/` is byte-for-byte what `cps2recomp/COMMIT` recorded.
- `make check-common` proves `recomp-common/` is what its own `COMMIT` recorded.

CI runs the last two and checks that no game data is tracked. It never builds or publishes a
release: CI has no ROM set.
