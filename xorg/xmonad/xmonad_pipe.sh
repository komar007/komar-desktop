#!/bin/bash

FIFO="/tmp/xmobar-panel-fifo"

mkfifo $FIFO
cat > $FIFO
