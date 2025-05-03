#!/usr/bin/env bash

if [ -f ~/.bashrc ]; then
	mv ~/.bashrc ~/.bashrc_orig
fi

# The directories below contain legacy (non-home-manager) configuration files
# They must be linked manually or with this script
for d in xorg bash gdb; do
	for f in "$d"/*; do
		ln -s "$(pwd)/$f" "$HOME/.$(basename "$f")"
	done
done
ln -s "$(pwd)/slock" ~/.slock
