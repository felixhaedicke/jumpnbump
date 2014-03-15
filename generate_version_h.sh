#!/bin/bash

CURRENT_SCRIPT="`readlink -f $0`"
SRC_DIR="`dirname ${CURRENT_SCRIPT}`"

echo \#define JNB_VERSION \"`cat "${SRC_DIR}/VERSION"`\" > version.h

