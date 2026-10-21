#!/usr/bin/env zsh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME label.color=0xff000000
  sketchybar --set $NAME background.drawing=on
else
  sketchybar --set $NAME label.color=0xffffffff
  sketchybar --set $NAME background.drawing=off
fi
