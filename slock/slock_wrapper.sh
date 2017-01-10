#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LOGFILE="$DIR/slock_wrapper.log"

echo "$(date +%s) lock"   >> "$LOGFILE"
xtrlock
echo "$(date +%s) unlock" >> "$LOGFILE"
