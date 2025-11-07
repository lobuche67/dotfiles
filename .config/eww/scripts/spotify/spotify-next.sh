#!/bin/bash

PLAYER_NAME="ncspot" # <-- Updated to match your specific player

# Send the "Next" command to Spotify
playerctl -p "$PLAYER_NAME" next

echo "Played the next song on Spotify."
