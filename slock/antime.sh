#!/bin/bash

last_lock1=""
last_lock2=""
prev_unlock=""
prev_lock=""
tac ~/.slock/slock_wrapper.log | while read timestamp action; do
	case "$action" in
		lock)
			lock=$timestamp
			if [ -n "$prev_lock" ]; then
				d=$(date -d @$lock +%D)
				fst_d=$(date -d @$prev_lock +%D)
				if [ "$d" != "$fst_d" ]; then
					last_lock1=$last_lock2
					last_lock2=$lock
				fi
			fi
			prev_lock=$lock
			;;
		unlock)
			unlock=$timestamp
			if [ -n "$prev_unlock" ]; then
				d=$(date -d @$unlock +%D)
				fst_d=$(date -d @$prev_unlock +%D)
				if [ "$d" != "$fst_d" ]; then
					if [ -n "$last_lock1" ]; then
						time=$[$last_lock1 - $prev_unlock]
						echo $prev_unlock $time
					else
						echo $prev_unlock
					fi
				fi
			fi
			prev_unlock=$unlock
			;;
	esac
done
