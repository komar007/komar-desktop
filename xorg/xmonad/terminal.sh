NAME=$1
shift
#urxvt -name "$NAME" -e "$@"
alacritty --class "$NAME" "$@"
