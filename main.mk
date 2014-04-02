TARGET := out.nes

AS := cl65
CC := cl65

CREATE_DEP = --create-dep $(@:.o=.d)

SRC_ASFLAGS := -t none --asm-include-dir include -g --debug-info

TGT_LDFLAGS := -t nes -C linker/mapper69.ld -m $(TARGET:.nes=.map) -Wl --dbgfile,$(TARGET:.nes=.dbg)

TGT_POSTCLEAN := rm *.map *.dbg

BUILD_DIR := .build


SOURCES := foo.s foo2.s
SOURCES += src/init.s
SOURCES += src/controller.s
SOURCES += src/core.s
SOURCES += src/nes-header.s
SOURCES += src/mapper69.s
SOURCES += src/common.s
SOURCES += src/checkbanks.s

