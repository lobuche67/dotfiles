#!/bin/bash

# Get all window addresses, dump to JSON, and filter only for addresses
ALL_WINDOWS=$(hyprctl -j clients | jq -r '.[] | .address')

# Get the address of the currently focused window
FOCUSED_ADDRESS=$(hyprctl activewindow -j | jq -r '.address')

# Find the index of the current window in the list
CURRENT_INDEX=$(echo "$ALL_WINDOWS" | grep -Fxn "$FOCUSED_ADDRESS" | cut -d: -f1)

# Calculate the next index (handling wrap-around)
TOTAL_WINDOWS=$(echo "$ALL_WINDOWS" | wc -l)
NEXT_INDEX=$(( (CURRENT_INDEX % TOTAL_WINDOWS) + 1 ))

# Get the address of the next window
NEXT_ADDRESS=$(echo "$ALL_WINDOWS" | sed -n "${NEXT_INDEX}p")

# Send the focus command to that window address
hyprctl dispatch focuswindow address:${NEXT_ADDRESS}
