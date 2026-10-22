# Releasing

Releases are built **by hand**, on a machine that has the ROM set and the translated code in
`work/dino/gen`. CI has no ROM set and never builds or publishes a release archive.

## Before you build

```sh
make                 # translate the game's code (needs rom/dino)
make explore         # once per fresh tree
make                 # translate what explore found
make launcher
make check
make check-toolkit
make check-common
```

## Build the archives

```sh
# Windows: in an MSYS2 MinGW64 shell, from the repository root (G:\ if you used subst)
tools/release/windows.sh

# Linux: on Ubuntu 22.04 (glibc 2.35), from the repository root
tools/release/linux.sh
```

The scripts write to `build/release/`:

| File | What |
| --- | --- |
| `Cadillacs-and-Dinosaurs-windows-x64.zip` | `dino.exe`, `dino-launcher.exe`, the five DLLs, `README.txt`, licences |
| `Cadillacs-and-Dinosaurs-linux-x86_64.tar.gz` | the two programs, `README.md`, licence and notices |
| `Cadillacs-and-Dinosaurs-linux-x86_64.AppImage` | the same, as an AppImage |
| `SHA256SUMS.txt` | the SHA-256 of each archive |

The archives contain **no** ROM set, key, BIOS, artwork or screenshot. The player brings their own
`dino` set.

## Publish

```sh
gh release create v0.1.0-beta.1 \
  build/release/*.zip build/release/*.tar.gz build/release/*.AppImage \
  build/release/SHA256SUMS.txt \
  --title "Cadillacs and Dinosaurs Recomp 0.1.0-beta.1" \
  --notes-file build/release/notes.md \
  --prerelease
```

The tag is `v<VERSION>` (from `VERSION`). A beta is marked **pre-release**.

## The old Linux base

The Linux programs take glibc from the machine that runs them. Ubuntu 22.04 has glibc 2.35, which
is what SteamOS 3.5 (and every SteamOS since) provides. Building on Ubuntu 24.04 or newer produces
binaries that SteamOS 3.5 refuses with a `GLIBC_2.39 not found` error. Check a release with:

```sh
objdump -T Cadillacs-and-Dinosaurs-linux-x86_64/dino | grep -o 'GLIBC_[0-9.]*' | sort -Vu | tail -1
```

It must not be newer than `GLIBC_2.35`.
