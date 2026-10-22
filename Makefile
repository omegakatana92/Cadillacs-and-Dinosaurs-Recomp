# SPDX-License-Identifier: GPL-3.0-only
#
# Cadillacs and Dinosaurs recomp, built with the cps2recomp toolkit.
# The toolkit lives in cps2recomp/ (a copy of cps2recomp v0.4.0-beta.4, made without its games/ and
# example/); see cps2recomp/build.mk for the targets (make, make run, make explore, make check,
# make launcher, ...).
#
# The player's ROM set is read, never changed: ROM points at a folder of the set's files or at the
# set's zip (rom/dino by default). dino is a CPS-1 board with QSound, and its program is not
# enciphered, so the set has no key file.
GAME ?= dino
CR ?= cps2recomp
ROM ?= rom/dino

# The translators import the toolkit's own Python modules; bytecode must not be written into the
# toolkit copy (cps2recomp/), or `make check-toolkit` would think the copy was changed by hand.
export PYTHONDONTWRITEBYTECODE := 1

include $(CR)/build.mk

# On Windows the game and the launcher need the MinGW runtime beside them (and SDL3 and zlib)
# before Windows will start them without an MSYS2 shell (a double-click). The toolkit's `make`
# leaves the two programs in build/$(GAME)/ and nothing more, so this adds them.
#
# Never mix in a DLL from another project's build folder: an older libstdc++-6.dll gives
# "The procedure entry point ... could not be located in the dynamic link library" on start.
DLLS ?= SDL3 zlib1 libstdc++-6 libgcc_s_seh-1 libwinpthread-1

all: deps

deps: port
	@mkdir -p build/$(GAME)
	@n=0; for d in $(DLLS); do \
		src="$$(dirname "$$(command -v g++)")/$$d.dll"; \
		if [ -f "$$src" ]; then cp -f "$$src" "build/$(GAME)/$$d.dll" && n=$$((n + 1)); fi; \
	done; \
	if [ $$n -gt 0 ]; then \
		echo "deps: $$n DLLs beside build/$(GAME)/ -- the programs can be double-clicked"; \
	else \
		echo "deps: nothing to copy here (not a MinGW build)"; \
	fi

# The launcher compiles the toolkit's machine/kabuki.cpp on its own, and kabuki.h uses size_t
# without including <cstddef>: MinGW's headers happen to supply it, GCC on Linux does not. The
# toolkit copy is not changed; every launcher source is given the include instead. (This replaces
# the toolkit's own launcher recipe, which does the same build without the flag.)
launcher: port
	@cmake -S $(CR)/launcher -B $(B)/launcher -G Ninja -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=$(CURDIR)/$(B) \
	  -DCMAKE_CXX_FLAGS="-include cstddef" \
	  -DGAME_NAME="$(shell $(CFG) name $(GAME))" -DGAME_EXE=$(GAME) \
	  -DAPP_ID=$(shell $(CFG) app_id $(GAME)) -DHOME_ENV=$(shell echo $(GAME) | tr a-z A-Z)_HOME \
	  -DDISCLAIMER="$(shell $(CFG) disclaimer $(GAME))" \
	  -DROM_SET="$(shell $(CFG) rom_set $(GAME))" -DROM_PARENT="$(shell $(CFG) rom_parent $(GAME))" \
	  -DROM_NAME="$(shell $(CFG) rom_name $(GAME))" -DROM_PROGRAM="$(shell $(CFG) program $(GAME))" \
	  -DROM_GRAPHICS="$(shell $(CFG) graphics $(GAME))" -DROM_SOUND_PROGRAM="$(shell $(CFG) sound_program $(GAME))" \
	  -DROM_SAMPLES="$(shell $(CFG) samples $(GAME))" -DROM_KEY="$(shell $(CFG) key $(GAME))" \
	  -DDISPLAY_SWITCHES="$(shell $(CFG) display $(GAME))" \
	  -DPLAYERS="$(shell $(CFG) players $(GAME))" -DBUTTONS="$(shell $(CFG) buttons $(GAME))" \
	  -DBOARD="$(shell $(CFG) board $(GAME))" -DCPS_B="$(shell $(CFG) cps_b $(GAME))" > /dev/null
	@cmake --build $(B)/launcher
	@echo "built $(B)/$(GAME)-launcher"

# The toolkit copy is what cps2recomp/COMMIT recorded (tools/sync-toolkit.sh).
check-toolkit:
	@tools/sync-toolkit.sh --check

# `make check` also checks the toolkit copy; the user asks for the three checks separately.
check: check-toolkit
