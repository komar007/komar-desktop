#!/bin/sh

T=alacritty

NAME=$1
shift

if [ "$T" = alacritty ]; then
        if [ $# -gt 0 ]; then
                alacritty --class "$NAME" -e "$@"
        else
                alacritty --class "$NAME"
        fi
elif [ "$T" = urxvt ]; then
        if [ $# -gt 0 ]; then
                urxvt -name "$NAME" -e "$@"
        else
                urxvt -name "$NAME"
        fi
else
        xterm -name "$NAME" "$@"
fi
