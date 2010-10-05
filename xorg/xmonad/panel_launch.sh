FIFO=/tmp/panel-fifo.$RANDOM
mkfifo $FIFO
/usr/bin/dzen2 -bg black -xs 2 -ta l -fn '-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*' < $FIFO &
/usr/bin/xmobar '/home/komar/.xmonad/xmobar-desktop' &
/usr/bin/xmobar '/home/komar/.xmonad/xmobar-info' &
cat > $FIFO
