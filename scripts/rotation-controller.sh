#!/bin/bash

# A unique ID so notifications replace each other
NOTIFY_ID=5678 
# The signal you use for Waybar (ensure this matches your config)
WAYBAR_SIGNAL="SIGRTMIN+11"

# Function to handle the toggle click
toggle() {
    if pgrep -x "iio-hyprland" > /dev/null; then
        killall iio-hyprland
        # notify-send "Screen orientation is locked" -u low -i changes-prevent
        dunstify -u low -r "$NOTIFY_ID" -a "System" -i "rotation-locked-symbolic" \
        "Rotation Locked" "Display is now fixed in place"
    else
        iio-hyprland &
        # notify-send "Screen orientation is unlocked" -u low -i view-refresh
        dunstify -u low -r "$NOTIFY_ID" -a "System" -i "rotation-allowed-symbolic" \
        "Auto-Rotate Enabled" "Display will follow device tilt"
    fi
    pkill -$WAYBAR_SIGNAL waybar
}

# Function to print status for Waybar (JSON format)
status() {
    if pgrep -x "iio-hyprland" > /dev/null; then
        echo '{"text": "󰢆", "tooltip": "Auto-Rotate: Active", "class": "active"}'
    else
        echo '{"text": "", "tooltip": "Rotation: Locked", "class": "locked"}'
    fi
}

# logic to decide what to do
case "$1" in
    --toggle)
        toggle
        ;;
    *)
        status
        ;;
esac
