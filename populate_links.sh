#!/usr/bin/env bash

if [ -f ~/.bashrc ]; then
	mv ~/.bashrc ~/.bashrc_orig
fi
for d in xorg bash gdb; do
	for f in $d/*; do
		ln -s `pwd`/$f ~/.`basename $f`
	done
done
ln -s `pwd`/slock ~/.slock
