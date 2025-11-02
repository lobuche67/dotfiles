#!/bin/bash
# $1 is the percentage value (0 to 100) passed from the Eww scale widget

NEW_BRIGHTNESS="$1%"

# Use brightnessctl to set the absolute brightness level
brightnessctl -n2 set "$NEW_BRIGHTNESS"