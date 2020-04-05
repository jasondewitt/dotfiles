#nitrogen --restore 
nvidia-settings --load-config-only &
xrdb -merge -I$HOME ~/.Xresources
wal -R
exec i3
