#!/bin/bash
# $1 is the percentage value (0 to 100) passed from the Eww scale widget

NEW_VOLUME="$1%"

# Use wpctl to set the absolute volume level
wpctl set-volume @DEFAULT_AUDIO_SINK@ "$NEW_VOLUME"