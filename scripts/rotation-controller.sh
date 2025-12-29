#!/bin/bash

# Function to handle the toggle click
toggle() {
    if pgrep -x "iio-hyprland" > /dev/null; then
        killall iio-hyprland
        notify-send "Screen orientation is locked" -u low -i changes-prevent
    else
        iio-hyprland &
        notify-send "Screen orientation is unlocked" -u low -i view-refresh
    fi
}

# Function to print status for Waybar (JSON format)
status() {
    if pgrep -x "iio-hyprland" > /dev/null; then
        echo '{"text": "󰢆", "tooltip": "Auto-Rotation: ON", "class": "active"}'
    else
        echo '{"text": "", "tooltip": "Auto-Rotation: LOCKED", "class": "locked"}'
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
