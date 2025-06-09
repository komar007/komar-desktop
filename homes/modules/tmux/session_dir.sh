#!/bin/sh

if [ -z "$1" ]; then
	exit
fi
PROJ="$HOME/repos/$1"
if [ -d "$PROJ" ]; then
	echo "${PROJ}"
fi
