#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ -a ~/.desktop_type ]]; then
	CONFIG=`cat ~/.desktop_type`
elif [[ -a /proc/acpi/battery/BAT0/ ]]; then
	CONFIG=laptop
else
	CONFIG=desktop
fi

killall -9 xmobar dzen2 2> /dev/null

PIDS=/tmp/panels.pids.$RANDOM

FIFO=/tmp/xmobar_panel_fifo

while [ ! -p "$FIFO" ]; do
    sleep 1
done

FN=$(cpp -P -I"$DIR" - <<< '#include "xmobar.rc"'$'\n''DEFAULT_FONT' | cut -d: -f2- | cut -d\" -f1)

# in case cat dies because of broken pipe
while true; do
	cat "$FIFO"
done | /usr/bin/dzen2 -bg black -x 1920 -ta l -fn "$FN" &
echo $! > $PIDS
sleep 0.1
if [[ $CONFIG == desktop ]]; then
    ICON_ROOT="$HOME/.xmonad/dzen2_img_large/"
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_DESKTOP -DPOS=0    -DWIDTH=1920 ~/.xmonad/xmobar-info.in               > /tmp/xmobar-info-desktop
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_DESKTOP -DPOS=3440 -DWIDTH=400  ~/.xmonad/xmobar-clock.in              > /tmp/xmobar-clock
    /usr/bin/xmobar /tmp/xmobar-info-desktop &
    echo $! >> $PIDS
    /usr/bin/xmobar /tmp/xmobar-clock &
    echo $! >> $PIDS
elif [[ $CONFIG == work ]]; then
    ICON_ROOT="$HOME/.xmonad/dzen2_img_small/"
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_WORK    -DPOS=0    -DWIDTH=1000 ~/.xmonad/xmobar-info.in               > /tmp/xmobar-info-work
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_WORK    -DPOS=1000 -DWIDTH=200 -DSIDE_LEFT   ~/.xmonad/xmobar-clock.in > /tmp/xmobar-clock1
    cpp -P -I"$DIR" -DICON_ROOT=\"$ICON_ROOT\" -DCONFIG_WORK    -DPOS=2560 -DWIDTH=320 -DSIDE_RIGHT  ~/.xmonad/xmobar-clock.in > /tmp/xmobar-clock2
    /usr/bin/xmobar /tmp/xmobar-info-work &
    echo $! >> $PIDS
    /usr/bin/xmobar /tmp/xmobar-clock1 &
    echo $! >> $PIDS
    /usr/bin/xmobar /tmp/xmobar-clock2 &
    echo $! >> $PIDS
elif [[ $CONFIG == laptop ]]; then
    ICON_ROOT="$HOME/.xmonad/dzen2_img_small/"
    /usr/bin/xmobar ~/.xmonad/xmobar-laptop &
    echo $! >> $PIDS
fi
cat

