#!/usr/bin/env zsh

## AEROSPACE ##
sketchybar --add event aerospace_workspace_change
for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.color="0xFFFFF4DB" \
    background.corner_radius=0 \
    background.height=20 \
    background.x_offset=7 \
    background.y_offset=-1 \
    background.drawing=off \
    label.width=12 \
    label="$sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid"
done
