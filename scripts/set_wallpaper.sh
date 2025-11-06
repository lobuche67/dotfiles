#!/bin/bash

WALLPAPER_PATH="$1"
MONITOR_NAME="eDP-1"

# --- STEP 1: PRELOAD NEW IMAGE ---
# hyprctl hyprpaper preload "$WALLPAPER_PATH"

echo "1. Generating colors with Pywal..."
wal -i "$WALLPAPER_PATH" -o "${HOME}/.config/wal/pywal_reload.sh"

sleep 0.2

echo "2. Applying wallpaper via Hyprpaper..."
# Apply the wallpaper using the now-preloaded image
# hyprctl hyprpaper wallpaper "$MONITOR_NAME, $WALLPAPER_PATH"
hyprctl hyprpaper reload ,"$WALLPAPER_PATH"

WALLPAPER_FILE="$(cat "$HOME/.cache/wal/wal")"
ln -f -s $WALLPAPER_FILE ~/.config/hypr/hyprpaper-wallpaper.png


# --- STEP 3: CLEANUP/UNLOAD OLD IMAGES (Optional but recommended) ---
# This command unloads all currently loaded textures EXCEPT the ones actively visible on a monitor.
# It ensures VRAM is cleared of old, unused wallpapers.
#hyprctl hyprpaper unload all

# The unload all command is typically safe and simple for managing VRAM.

# ... rest of the script (Waybar/Eww reload) ...
killall -SIGUSR2 waybar || waybar &
eww reload

echo "Done."
