#!/bin/bash
# ~/.config/eww/scripts/spotify/spotify-get-position-poll.sh
# Performs the position calculation every 1 second, but only when running.
# Uses the microsecond-based logic that was previously debugged.

PLAYER_NAME="ncspot"

POSITION_US=$(playerctl -p "$PLAYER_NAME" metadata --format '{{ position }}' 2>/dev/null)
LENGTH_US=$(playerctl -p "$PLAYER_NAME" metadata --format '{{ mpris:length }}' 2>/dev/null)

POSITION_US=${POSITION_US:-0}
LENGTH_US=${LENGTH_US:-0}

POSITION_PERCENT=0

if [ "$LENGTH_US" -gt 0 ]; then
    # Calculate percentage: (Position / Length) * 100
    RAW_PERCENT=$(echo "scale=2; ($POSITION_US / $LENGTH_US) * 100" | bc)
    POSITION_PERCENT=$(echo "$RAW_PERCENT" | cut -d'.' -f1) # Truncate to integer
fi

echo "$POSITION_PERCENT" # Output the percentage directly
