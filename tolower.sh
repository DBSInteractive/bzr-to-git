#!/bin/sh
# convert stdin to lowercase.

cat /dev/stdin | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'
#eof tolower.sh

