#!/bin/bash
# This script monitors D-Bus for media player status changes and triggers the hyprlock update.

# The command to monitor D-Bus for media player events (Metadata change = new song)
dbus-monitor --profile "interface='org.mpris.MediaPlayer2.Player',member='PropertiesChanged'" |
while read -r line; do
    # Only proceed if the line contains the 'Metadata' property change
    if echo "$line" | grep -q "Metadata"; then
        # Send the signal to hyprlock. The 'music_update' signal will execute 
        # the command defined in your hyprlock.conf file.
        hyprctl dispatch exec [notify_signal music_update] &
    fi
done
