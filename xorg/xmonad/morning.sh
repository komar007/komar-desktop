#!/bin/bash

WORK_TIME=$[8*3600]
SHOULD_START="08:30:00"
MAXDIFF=$[5*60]
LEAVE_EXTRA=$[10*60]

function color_xmobar()
{
	text=$1
	color=$2
	if [ -n "$color" ]; then
		echo "<fc=$color>$text</fc>"
	else
		echo "$text"
	fi
}

function low_mid_high()
{
	value=$1
	low=$2
	high=$3
	low_out=$4
	mid_out=$5
	high_out=$6
	if [ $value -lt $low ]; then
		echo $low_out
	elif [ $value -lt $high ]; then
		echo $mid_out
	else
		echo $high_out
	fi
}

if [ -x "$HOME/.slock/antime.sh" ]; then
	should_start=$(date -d "$SHOULD_START" +%s)
	time_start=$("$HOME/.slock/antime.sh" | head -n 1 | cut -d' ' -f 2)
	if [ -z "$time_start" ]; then
		exit
	fi
	start_diff=$[$time_start - $should_start]
	time_now=$(date +%s)
	day=$[$time_now - $time_start]

	color_time=$(low_mid_high $start_diff -$MAXDIFF $MAXDIFF "#719a4b" "" "#fb4934")
	color_day=$(low_mid_high $day $WORK_TIME $[$WORK_TIME+$LEAVE_EXTRA] "" "#719a4b" "#fb4934")

	time_start_h=$(date +%R -d @$time_start)
	day_h=$(TZ= date +%R -d @$day)
	time_part=$(color_xmobar "$time_start_h" $color_time)
	day_part=$(color_xmobar "$day_h" $color_day)
	echo "<fc=#aaaaaa><icon=enter.xbm/></fc>$time_part ($day_part)"
fi
