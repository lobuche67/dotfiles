#!/bin/bash
# Path: ~/.config/wal/pywal_reload.sh
# Make sure this script is executable: chmod +x ~/.config/wal/pywal_reload.sh

WALLPAPER_PATH="$wallpaper"

# --- 1. NCSPOT MERGE ---
# Concatenate the non-color base config with the Pywal-generated colors,
# OVERWRITING the final config file.
NCSPOT_BASE="${HOME}/.config/ncspot/config_base.toml"
NCSPOT_FINAL="${HOME}/.config/ncspot/config.toml"
cat "$NCSPOT_BASE" > "$NCSPOT_FINAL"
cat "${HOME}/.cache/wal/ncspot_colors.toml" >> "$NCSPOT_FINAL"
# pkill ncspot # Restart ncspot

# --- 2. DUNST MERGE ---
DUNST_BASE="${HOME}/.config/dunst/dunstrc_base"
DUNST_FINAL="${HOME}/.config/dunst/dunstrc"
cat "$DUNST_BASE" > "$DUNST_FINAL"
cat "${HOME}/.cache/wal/dunst_colors.conf" >> "$DUNST_FINAL"
pkill -HUP dunst || dunst & # Reload Dunst

# --- 3. CAVA MERGE ---
CAVA_BASE="${HOME}/.config/cava/config_base"
CAVA_FINAL="${HOME}/.config/cava/config"
cat "$CAVA_BASE" > "$CAVA_FINAL"
cat "${HOME}/.cache/wal/cava_colors.conf" >> "$CAVA_FINAL"
#pkill -USR2 cava # Reload Cava

# --- 4. YAZI MERGE ---
YAZI_BASE="${HOME}/.config/yazi/theme_base.toml"
YAZI_FINAL="${HOME}/.config/yazi/theme.toml"
cat "$YAZI_BASE" > "$YAZI_FINAL"
cat "${HOME}/.cache/wal/yazi_colors.toml" >> "$YAZI_FINAL"

# -- 5. EWW
eww reload
