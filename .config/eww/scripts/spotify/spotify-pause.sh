#!/bin/bash

PLAYER_NAME="spotify_player" # <-- Updated to match your specific player

status=$(playerctl -p "$PLAYER_NAME" status)

status="${status#*\"}"
status="${status%\"*}"

if [ "$status" == "Playing" ]; then
    playerctl -p "$PLAYER_NAME" pause > /dev/null 2>&1
    echo "󰐊"
else
    playerctl -p "$PLAYER_NAME" play > /dev/null 2>&1
    echo "󰏤"
fi
