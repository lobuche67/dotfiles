#!/bin/bash
# ~/.config/eww/scripts/spotify/spotify-get-position-poll.sh
# Performs the position calculation every 1 second, but only when running.
# Uses the microsecond-based logic that was previously debugged.

PLAYER_NAME="spotify_player"

POSITION_US=$(playerctl -p "$PLAYER_NAME" metadata --format '{{ position }}' 2>/dev/null)
LENGTH_US=$(playerctl -p "$PLAYER_NAME" metadata --format '{{ mpris:length }}' 2>/dev/null)

POSITION_US=${POSITION_US:-0}
LENGTH_US=${LENGTH_US:-0}

POSITION_PERCENT=0

    if [ "$LENGTH_US" -gt 0 ]; then
        # Use shell integer arithmetic for efficiency
        POSITION_PERCENT=$(( (POSITION_US * 100) / LENGTH_US ))
    fi
echo "$POSITION_PERCENT" # Output the percentage directly
