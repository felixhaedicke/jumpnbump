#!/bin/bash
echo unsigned char default_jumpbump_dat[] = { > jumpbump_dat.c
hexdump -v -e '16/1 "0x%x," "\n"' jumpbump.dat | sed s/0x,//g >> jumpbump_dat.c
echo 0x0 \}\; >> jumpbump_dat.c

