#!/bin/bash

CURRENT_SCRIPT="`readlink -f $0`"
SRC_DIR="`dirname ${CURRENT_SCRIPT}`"

tcc -run ${SRC_DIR}/modify/gobpack.c ${SRC_DIR}/data/numbers || exit $?
tcc -run ${SRC_DIR}/modify/gobpack.c ${SRC_DIR}/data/objects || exit $?
tcc -run ${SRC_DIR}/modify/gobpack.c ${SRC_DIR}/data/rabbit || exit $?
tcc -run ${SRC_DIR}/modify/gobpack.c ${SRC_DIR}/data/font || exit $?
tcc -run ${SRC_DIR}/modify/jnbpack.c \
	-o jumpbump.dat \
	${SRC_DIR}/data/bump.mod \
	${SRC_DIR}/data/calib.dat \
	${SRC_DIR}/data/death.smp \
	${SRC_DIR}/data/fly.smp \
	${SRC_DIR}/data/jump.mod \
	${SRC_DIR}/data/jump.smp \
	${SRC_DIR}/data/levelmap.txt \
	${SRC_DIR}/data/level.pcx \
	${SRC_DIR}/data/mask.pcx \
	${SRC_DIR}/data/menu.pcx \
	${SRC_DIR}/data/menumask.pcx \
	${SRC_DIR}/data/scores.mod \
	${SRC_DIR}/data/splash.smp \
	${SRC_DIR}/data/spring.smp \
	numbers.gob \
	objects.gob \
	rabbit.gob \
	font.gob || exit $?

