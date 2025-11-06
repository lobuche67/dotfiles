#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SETTER_SCRIPT="$HOME/scripts/set_wallpaper.sh"

# Source the list of only the filenames
WALLPAPER_LIST=$(~/scripts/wallpaper_select.sh)

# Use Wofi to present the list of FILENAMES and capture the selected filename.
SELECTED_FILENAME=$(echo "$WALLPAPER_LIST" | wofi -i -I --dmenu -n -p "Select Wallpaper")

# Check if the user made a selection
if [ -n "$SELECTED_FILENAME" ]; then

    # CRITICAL: Reconstruct the full path
    FULL_PATH="${WALLPAPER_DIR}/${SELECTED_FILENAME}"

    # Execute your main script, passing the full path
    $SETTER_SCRIPT "$FULL_PATH" &
fi
