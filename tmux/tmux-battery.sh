#!/usr/bin/env bash
# Prints the battery percentage as digits only, padded to a fixed 3-char field
# (e.g. " 99", "100"). The literal '%' is appended in tmux.conf as '%%' so it
# never passes through tmux's strftime on the status string (which silently
# eats un-doubled % signs). Fixed width keeps the status bar from shifting.
#
# Match the "NN%" token first (e.g. "100%") THEN strip the % — matching bare
# digits would grab the "0" in "-InternalBattery-0" instead of the charge.
pct=$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -n "$pct" ] && printf '%3s' "$pct"
