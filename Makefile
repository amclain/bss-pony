DIR = ./bss
TEST_DIR = ./bss/test

.PHONY: test

build:
	@ ponyc ${DIR} -o ${DIR}

run:
	@ ${DIR}/bss

test:
	@ ponyc ${TEST_DIR} -o ${TEST_DIR}
	@ ${TEST_DIR}/test
