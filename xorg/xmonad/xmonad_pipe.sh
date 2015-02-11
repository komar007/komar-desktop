#!/bin/bash

FIFO_PREFIX=/tmp/xmobar_panel_fifo
FIFO="${FIFO_PREFIX}_$RANDOM"

rm "${FIFO_PREFIX}"_* -fr

mkfifo "$FIFO"
echo "$FIFO" > ${FIFO_PREFIX}
while true; do
	cat > $FIFO
	sleep 1
done
