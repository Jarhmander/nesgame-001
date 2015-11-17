include main.mk

LD := ${CC}

OBJS := $(addprefix ${BUILD_DIR}/,${SOURCES:.s=.o})
DEPS := $(addprefix ${BUILD_DIR}/,${SOURCES:.s=.d})

MAKEFLAGS += -j$(shell nproc)

.PHONY: all
all: ${TARGET}

.PHONY: clean
clean:
	rm -rf ${BUILD_DIR}
	${TGT_POSTCLEAN}

.PHONY: test
test : ${TARGET}
	mednafen ${TARGET}

${TARGET} : ${OBJS}
	${LD} ${TGT_LDFLAGS} ${OBJS} -o ${TARGET}

${BUILD_DIR}/%.o : %.s
	@mkdir -p $(dir $@)
	${AS} ${SRC_ASFLAGS} -o $@ ${CREATE_DEP} -c $<

${OBJS} : Makefile main.mk


-include ${DEPS}
