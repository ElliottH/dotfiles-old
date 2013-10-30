#!/bin/bash

# Rebind Caps Lock to Ctrl
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"

# Set the wallpaper
feh --bg-scale ~/.xmonad/wallpaper

# Start mpd
mpd
