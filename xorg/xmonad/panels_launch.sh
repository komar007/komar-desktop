#!/bin/bash

if [[ -a ~/.desktop_type ]]; then
	CONFIG=`cat ~/.desktop_type`
elif [[ -a /proc/acpi/battery/BAT0/ ]]; then
	CONFIG=laptop
else
	CONFIG=desktop
fi

killall -9 xmobar dzen2 2> /dev/null

FIFO_PREFIX=/tmp/xmobar_panel_fifo
FIFO=$(cat ${FIFO_PREFIX})

until [ -p "$FIFO" ]; do
	sleep 1
done

# in case cat dies because of broken pipe
while true; do
	cat "$FIFO"
done | /usr/bin/dzen2 -bg black -xs 2 -ta l -fn '-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*' &
sleep 0.1
/usr/bin/xmobar "/home/komar/.xmonad/xmobar-$CONFIG" &
if [[ $CONFIG == desktop ]]; then
    /usr/bin/xmobar "/home/komar/.xmonad/xmobar-info"
fi &
cat
