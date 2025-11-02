#!/bin/bash

# Configuration
NOTIFY_ID=8888 
DEVICE_NAME=$(brightnessctl | head -n 1 | awk '{print $2}')# --- Configuration ---

# Set a safe minimum percentage (e.g., 5% or 10%)
SAFE_MIN_PERCENT=5

# Get the current brightness value (0-255) and max value
CURRENT_BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)

# Calculate the safe minimum decimal value
SAFE_MIN_VALUE=$((MAX_BRIGHTNESS * SAFE_MIN_PERCENT / 100))
# Ensure the minimum is at least 1, just in case
if [ "$SAFE_MIN_VALUE" -lt 1 ]; then
    SAFE_MIN_VALUE=1
fi

send_notification() {
    # Get the current brightness percentage
    BRIGHTNESS=$(brightnessctl get)
    MAX=$(brightnessctl max)
    PERCENT=$(( ($BRIGHTNESS * 100) / $MAX ))

    # Determine icon
    if [ "$PERCENT" -gt 50 ]; then
        ICON="" # Full brightness icon
    elif [ "$PERCENT" -gt 0 ]; then
        ICON="" # Medium brightness icon
    else
        ICON="" # Off brightness icon
    fi

    # Send the notification
    #dunstify -i "$ICON" -r $NOTIFY_ID -u low -h int:value:"$PERCENT" "Brightness: ${PERCENT}%"
    dunstify -i NONE -r $NOTIFY_ID -u low -h int:value:"$PERCENT" "$ICON Brightness: ${PERCENT}%"
}

# Execute the requested action (up or down)
if [[ "$1" == "up" ]]; then
    brightnessctl set 5%+
elif [[ "$1" == "down" ]]; then
    # Calculate target brightness by reducing the current by 5% of max
    # Note: brightnessctl set 5%- is simpler, but less precise for limiting
    
    # Calculate 5% of the MAX value to use for the step size
    STEP=$((MAX_BRIGHTNESS * 5 / 100))
    TARGET_BRIGHTNESS=$((CURRENT_BRIGHTNESS - STEP))
    
    if [ "$TARGET_BRIGHTNESS" -le "$SAFE_MIN_VALUE" ]; then
        # If the target is too low, set it to the safe minimum
        brightnessctl set "$SAFE_MIN_VALUE"
    else
        # Otherwise, decrease by 5% (the initial request)
        brightnessctl set 5%-
    fi
fi


# Send the notification after the command runs
send_notification
