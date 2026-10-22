#!/usr/bin/env sh

# This version of the aerospace script fixes 2 major problems
# I had with a version provided by aerospace goodies page from the docs
#
# PROBLEM: The og script's workspace highlight lags behind quite a bit when switching workspace.
# Also glitches if you switch workspaces fast, the highlight sometimes will just dissapear.
#
# I already had a hunch that something was off, surely a tiling manager
# even as held back as it is on MACOS, can't be this laggy and glitchy.
#
# I'm quite shit at bash and don't understand aerospace too well, so my analysis could be wrong or inaccurate,
# but I'm confident in the shape of this damn problem.
#
# WHY:
# In aerospace.toml, there is a callback that executes on workspace change,
# `exec-on-workspace-change`.
#
# The aerospace callback will call `bash -c` followed by sketchybar commands that uses `--trigger` to spawn a new event,
# also exports a variable `FOCUSED_WORKSPACE`.
#
# Like my current version, the og ver also did a for loop with all `sid`,
# but the author had a `--subscribe` in each loop.
#
# `script="$CONFIG_DIR/plugins/aerospace.sh $sid"` was also included in the loop, which is likely the root cause of slowdown.
#
# Say you have 9 workspaces, each workspaces listens for the workspace change event.
#
# Each workspace then spawns it's own shell process to draw backgrounds, or change text colors whateves.
#
# Each shell then proceeds to call `sketchybar --set ...`, so that again is 9 separate calls.
#
# You can probably see how this is somewhat slow, and even has race conditions if user changed spaces too fast, causes it to glitch out.
#
# FIXING:
# The idea is to just listen for workspace change event ONCE, calls script ONCE, and do `sketchybar --set ...` ONCE.
#
# A small trick here is to just add a invisible item that listens for the event, then calls our aerospace.sh script inside "plugins/".
#
# Inside that script, we concatenate ALL `--set ...` arguments for each workspace into one huge invocation.
#
# This way, we only call the script once, and invoke sketchbyar only once.
#

sketchybar --add event aerospace_workspace_change
workspaces=""

for sid in $(aerospace list-workspaces --all); do
  workspaces="$workspaces $sid"

  sketchybar --add item space."$sid" left \
    --set space."$sid" \
    background.color="$PAYAYA_WHIP" \
    background.corner_radius=0 \
    background.height=20 \
    background.x_offset=7 \
    background.y_offset=-1 \
    background.drawing=off \
    label.width=12 \
    label="$sid"
  # click_script="aerospace workspace $sid"
  # If clicking on workspace needed, uncomment above line
  # useless for me atm
done

sketchybar --add item aerospace left \
  --set aerospace \
  drawing=off \
  updates=on \
  script="$PLUGIN_DIR/aerospace.sh$workspaces" \
  --subscribe aerospace aerospace_workspace_change
