#!/usr/bin/env zsh

source "$CONFIG_DIR/colors.sh"

# FOCUSED_WORKSPACE is only exported when the event fires. You can confirm this directly in aerospace.toml, when sketchybar is called with the variable exported.
#
# But on first startup, there is no workspace change event being fired, so the fallback just asks aerospace which space is focused rightnow.
#
# This one goes to claude btw, because my dumbo ass is not familiar with bash/zsh.
#
# I think the rest is fairly self explanatory
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

args=()
for sid in "$@"; do
  if [[ "$sid" == "$focused" ]]; then
    args+=(--set "space.$sid" background.drawing=on label.color="$BLACK")
  else
    args+=(--set "space.$sid" background.drawing=off label.color="$PAYAYA_WHIP")
  fi
done

sketchybar "${args[@]}"
