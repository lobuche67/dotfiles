#!/bin/bash

# Check if Spotify is running and playing/paused
PLAYER_STATUS=$(playerctl status 2>/dev/null)

if [[ "$PLAYER_STATUS" != "Playing" && "$PLAYER_STATUS" != "Paused" ]]; then
    # Output nothing if the player is inactive
    echo "0"
    exit 0
fi

# Get raw position (seconds or microseconds, depending on player version/config)
# We assume microseconds, which is standard for MPRIS length
POSITION_US=$(playerctl metadata --format '{{ position }}')
LENGTH_US=$(playerctl metadata --format '{{ mpris:length }}')

# Simple safety check and exit if length is zero
if [ -z "$LENGTH_US" ] || [ "$LENGTH_US" -eq 0 ]; then
    echo "0"
    exit 0
fi

# Calculate the percentage (scale 1 to 100)
# We use 'bc' for floating-point math: (Position / Length) * 100
PERCENTAGE=$(echo "scale=0; ($POSITION_US * 100) / $LENGTH_US" | bc)

# Ensure the percentage is between 0 and 100
if [ "$PERCENTAGE" -gt 100 ]; then
    PERCENTAGE=100
fi

# Output the result with a label
echo "${PERCENTAGE}"