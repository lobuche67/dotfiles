#!/bin/bash
# ~/.config/eww/scripts/spotify/spotify-get-position-poll.sh
# Performs the position calculation every 1 second, but only when running.
# Uses the microsecond-based logic that was previously debugged.

#PLAYER_NAME="naviterm"

#POSITION_US=$(playerctl -p "$PLAYER_NAME" metadata --format '{{ position }}' 2>/dev/null)
#LENGTH_US=$(playerctl -p "$PLAYER_NAME" metadata --format '{{ mpris:length }}' 2>/dev/null)

#POSITION_US=${POSITION_US:-0}
#LENGTH_US=${LENGTH_US:-0}

#POSITION_PERCENT=0

#    if [ "$LENGTH_US" -gt 0 ]; then
#        # Use shell integer arithmetic for efficiency
#        POSITION_PERCENT=$(( (POSITION_US * 100) / LENGTH_US ))
#    fi

# Get current position and total length from the mpv socket
CUR=$(echo '{ "command": ["get_property", "time-pos"] }' | socat - /tmp/naviterm_mpv | jq '.data')
LEN=$(echo '{ "command": ["get_property", "duration"] }' | socat - /tmp/naviterm_mpv | jq '.data')

# Calculate percentage using bc (since we have decimals)
POSITION_PERCENT=$(echo "scale=0; ($CUR * 100 / $LEN) / 1" | bc)

echo "$POSITION_PERCENT" # Output the percentage directly
