#!/bin/bash
# ~/.config/eww/scripts/brightness-listener.sh

# Define the brightness file path
BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"

# 1. Initial value (required by deflisten)
brightnessctl -m | awk -F, '{print $4}' | tr -d '%'

# 2. Block and wait for modification events on the brightness file
inotifywait -m -e modify "$BRIGHTNESS_FILE" | while read -r event; do
    # This command executes ONLY when the brightness file is modified
    brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
done
