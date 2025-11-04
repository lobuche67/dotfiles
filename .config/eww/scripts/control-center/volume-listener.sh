#!/bin/bash
# ~/.config/eww/scripts/volume-listener.sh (Final Reliable Version)

# Function to get and print the current volume
get_volume() {
    # Ensure all output goes to stdout (where Eww listens)
    pamixer --get-volume
}

# 1. Output the current value once immediately (for Eww :initial)
get_volume

# 2. Start the persistent event listener
# We listen for any sink-related event, which includes volume changes, mute, etc.
pactl subscribe | grep --line-buffered "sink" | while read -r event; do
    # When ANY sink event is detected, rerun the command and print the result.
    get_volume
done
