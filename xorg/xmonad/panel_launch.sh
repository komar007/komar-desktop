#!/bin/bash

if [[ -a ~/.desktop_type ]]; then
	CONFIG=`cat ~/.desktop_type`
elif [[ -a /proc/acpi/battery/BAT0/ ]]; then
	CONFIG=laptop
else
	CONFIG=desktop
fi

killall xmobar dzen2

FIFO="/tmp/xmobar-panel-fifo"
mkfifo $FIFO
/usr/bin/dzen2 -bg black -xs 2 -ta l -fn '-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*' < $FIFO &
/usr/bin/xmobar "/home/komar/.xmonad/xmobar-$CONFIG" &
if [[ $CONFIG == desktop ]]; then
    /usr/bin/xmobar "/home/komar/.xmonad/xmobar-info"
fi &
cat > $FIFO
