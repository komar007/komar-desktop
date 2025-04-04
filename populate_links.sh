#!/usr/bin/env bash

if [ -f ~/.bashrc ]; then
	mv ~/.bashrc ~/.bashrc_orig
fi
for d in xorg vim bash mutt gdb tig; do
	for f in $d/*; do
		ln -s `pwd`/$f ~/.`basename $f`
	done
done
ln -s `pwd`/git/gitconfig ~/.gitconfig
ln -s `pwd`/git/git_template ~/.git_template
ln -s `pwd`/slock ~/.slock
mkdir -f ~/.icons
ln -s `pwd`/icons/Neutral_Plus ~/.icons/
