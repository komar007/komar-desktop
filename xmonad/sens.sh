#!/bin/bash
sensors | awk -F: "/$1/{print \$2}" | awk -F\( '//{print $1}' | egrep '[0-9]+' -o
