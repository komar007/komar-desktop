#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ICON_ROOT="$HOME/.xmonad/dzen2_img/"

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
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_DESKTOP -DPOS=0    -DWIDTH=1280 ~/.xmonad/xmobar-info.in               > /tmp/xmobar-info-desktop
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_DESKTOP -DPOS=2360 -DWIDTH=200  ~/.xmonad/xmobar-clock.in              > /tmp/xmobar-clock
    /usr/bin/xmobar /tmp/xmobar-info-desktop &
    /usr/bin/xmobar /tmp/xmobar-clock &
elif [[ $CONFIG == work ]]; then
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_WORK    -DPOS=0    -DWIDTH=1000 ~/.xmonad/xmobar-info.in               > /tmp/xmobar-info-work
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_WORK    -DPOS=1000 -DWIDTH=200 -DSIDE_LEFT   ~/.xmonad/xmobar-clock.in > /tmp/xmobar-clock1
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_WORK    -DPOS=2560 -DWIDTH=320 -DSIDE_RIGHT  ~/.xmonad/xmobar-clock.in > /tmp/xmobar-clock2
    /usr/bin/xmobar /tmp/xmobar-info-work &
    /usr/bin/xmobar /tmp/xmobar-clock1 &
    /usr/bin/xmobar /tmp/xmobar-clock2 &
elif [[ $CONFIG == laptop ]]; then
    /usr/bin/xmobar ~/.xmonad/xmobar-laptop &
fi
cat
