TARGET := out.nes

AS := cl65
CC := cl65
LD := cl65

CREATE_DEP = --create-dep $(@:.o=.d)

TGT_LINKER := ld65

SRC_ASFLAGS := -t none --asm-include-dir include

TGT_LDFLAGS := -C linker/mapper69.ld -m out.map
BUILD_DIR := .build


SOURCES := foo.s foo2.s
SOURCES += src/init.s
SOURCES += src/controller.s
SOURCES += src/core.s
SOURCES += src/nes-header.s
SOURCES += src/mapper69.s
SOURCES += src/common.s
SOURCES += src/checkbanks.s

