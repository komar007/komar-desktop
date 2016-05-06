#!/bin/bash

NOBLOCK=0
if [ "$1" == "--noblock" ]; then
	NOBLOCK=1
	shift
fi
[ -n "$*" ] && echo -ne "\e]0;$*\a"
echo -ne "$*...\a"
[ "$NOBLOCK" -eq 0 ] && read
