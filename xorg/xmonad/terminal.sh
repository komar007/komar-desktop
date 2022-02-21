#!/bin/sh

T=alacritty

NAME=$1
shift

if [ "$T" = alacritty ]; then
        alacritty --class "$NAME" "$@"
elif [ "$T" = urxvt ]; then
        if [ $# -gt 0 ]; then
                urxvt -name "$NAME" -e "$@"
        else
                urxvt -name "$NAME"
        fi
else
        xterm -name "$NAME" "$@"
fi
