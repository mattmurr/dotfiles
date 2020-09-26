#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export GST_VAAPI_ALL_DRIVERS=1
export MOZ_X11_EGL=1

setxkbmap gb
feh --bg-fill --randomize ~/Pictures/Wallpapers/*

xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

exec startxfce4
