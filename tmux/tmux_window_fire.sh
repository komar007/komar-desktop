#!/bin/sh

CONDITION=">50"

WID=$1
PANE_PIDS=$(tmux list-panes -t ${WID} -F '#{pane_pid}')
ALL_PIDS=$(ps --forest -o pid= -g $(echo $PANE_PIDS | xargs | tr ' ' ,))
echo $(\
	ps -o %cpu= -p $(echo $ALL_PIDS | tr ' ' ,) \
		| xargs \
		| tr ' ' + \
) "$CONDITION" \
	| bc \
	| sed -n 's/1/ /p'
