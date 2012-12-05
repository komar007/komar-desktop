#!/bin/bash

# usage: ./run_pdf.sh instance_name

f=`ls --color=none -tr ~/Pobrania/*.pdf | tail -n 1`
~/repos/qpdfview/qpdfview --unique --instance $1 "$f"
