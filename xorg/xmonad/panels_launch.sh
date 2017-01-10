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
if [[ $CONFIG == desktop ]]; then
    /usr/bin/xmobar ~/.xmonad/xmobar-info-desktop &
    cpp -DPOS=2360 -DWIDTH=200 ~/.xmonad/xmobar-clock.in | sed '/^#/d' > /tmp/xmobar-clock
    /usr/bin/xmobar /tmp/xmobar-clock &
elif [[ $CONFIG == work ]]; then
    /usr/bin/xmobar ~/.xmonad/xmobar-info-work &
    cpp -DPOS=1000 -DWIDTH=200 -DSIDE_LEFT  ~/.xmonad/xmobar-clock.in | sed '/^#/d' > /tmp/xmobar-clock1
    cpp -DPOS=2630 -DWIDTH=250 -DSIDE_RIGHT ~/.xmonad/xmobar-clock.in | sed '/^#/d' > /tmp/xmobar-clock2
    /usr/bin/xmobar /tmp/xmobar-clock1 &
    /usr/bin/xmobar /tmp/xmobar-clock2 &
elif [[ $CONFIG == laptop ]]; then
    /usr/bin/xmobar ~/.xmonad/xmobar-laptop &
fi
cat
