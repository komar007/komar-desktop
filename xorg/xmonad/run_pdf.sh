#!/bin/bash

# usage: ./run_pdf.sh instance_name

f=`ls --color=none -tr ~/Pobrania/*.pdf ~/Pobrania/*.PDF | tail -n 1`
qpdfview --unique --instance $1 "$f"
