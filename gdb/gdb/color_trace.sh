#!/bin/bash

sed -r "s_([^<])(\b([a-zA-Z0-9_]+::)?[a-zA-Z0-9_\.@]+)( ?)\(_\1$(tput setaf 1)$(tput bold)\2$(tput sgr0)\4(_g" | \
sed -r "s_([a-zA-Z0-9_#]*)=_$(tput setaf 2)$(tput bold)\1$(tput sgr0)=_g" | \
sed -r "s_^(#[0-9]*)_$(tput setaf 1)$(tput bold)\1$(tput sgr0)_" | \
sed -r "s_^([ \*]) ([0-9]+)_$(tput bold)$(tput setaf 6)\1 $(tput setaf 1)\2$(tput sgr0)_" | \
sed -r "s_(\.*[/A-Za-z0-9\+_\.\-]*):([0-9]+)\$_$(tput bold)$(tput setaf 4)\1$(tput sgr0):$(tput setaf 3)\2$(tput sgr0)_"
