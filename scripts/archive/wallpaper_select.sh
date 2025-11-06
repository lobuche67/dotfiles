#!/bin/bash

# Define the root directory where your wallpapers are stored
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Use 'find' to locate all image files
# Use 'basename' to strip the directory path and print only the filename
find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) |
xargs -I {} basename {} | sort
