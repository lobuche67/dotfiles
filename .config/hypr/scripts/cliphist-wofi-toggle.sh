#!/bin/bash

# Define the command to check for, which is wofi running in dmenu mode
WOFI_CMD="wofi --show dmenu"

# Check if an instance of wofi (specific to the dmenu mode) is already running
if pgrep -f "$WOFI_CMD" > /dev/null; then
    # If it is running, kill it (close the window)
    pkill -f "$WOFI_CMD"
    exit 0
else
    # If it is NOT running, execute the full command (open the window)
    cliphist list | wofi --show dmenu | cliphist decode | wl-copy
fi
