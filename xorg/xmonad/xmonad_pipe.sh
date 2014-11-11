#!/bin/bash

FIFO="/tmp/xmobar-panel-fifo"

mkfifo $FIFO
while true; do
	cat > $FIFO
done
