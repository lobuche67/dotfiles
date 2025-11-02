#!/bin/bash

# Configuration (Unique ID for notification stacking)
NOTIFY_ID=9999
DEFAULT_SINK="@DEFAULT_AUDIO_SINK@"

# Function to send a notification (remains the same as previous step's fix)
send_notification() {
    # 1. Check for MUTE status first and exit if true
    if wpctl get-volume $DEFAULT_SINK | grep -q 'MUTED'; then
        ICON="" # Mute icon (Nerd Font)
        TEXT="Muted"
        dunstify -i NONE -r $NOTIFY_ID -u low -h int:value:0 "$ICON $TEXT"
        # dunstify -i "$ICON" -r $NOTIFY_ID -u low -h int:value:0 "$TEXT"
        return # EXIT here to prevent false volume noti
    fi

    # 2. Get the integer percentage (Only runs if NOT muted)
    RAW_VOLUME=$(wpctl get-volume $DEFAULT_SINK | awk '{print $2}' | tr -d '[]%')
    VOLUME=$(echo "$RAW_VOLUME * 100" | bc | awk '{print int($1+0.5)}')

    # 3. Determine volume icon
    if [ "$VOLUME" -gt 75 ]; then
        ICON="" 
    elif [ "$VOLUME" -gt 0 ]; then
        ICON="" 
    else
        ICON="" 
    fi

    # Send the final volume notification
    #dunstify -i "$ICON" -r $NOTIFY_ID -u low -h int:value:"$VOLUME" "Volume: ${VOLUME}%"
    dunstify -i NONE -r $NOTIFY_ID -u low -h int:value:"$VOLUME" "$ICON Volume: ${VOLUME}%"
}

# Execute the requested action (up, down, or mute)
if [[ "$1" == "up" ]]; then
    # --- CRITICAL UNMUTE CHECK ---
    # Check if muted, and if so, unmute it (toggle mute)
    if wpctl get-volume $DEFAULT_SINK | grep -q 'MUTED'; then
        wpctl set-mute $DEFAULT_SINK 0 # Set mute state to OFF
    fi
    # Then apply the volume increase
    wpctl set-volume -l 1 $DEFAULT_SINK 5%+

elif [[ "$1" == "down" ]]; then
    # --- CRITICAL UNMUTE CHECK ---
    # Check if muted, and if so, unmute it (toggle mute)
    if wpctl get-volume $DEFAULT_SINK | grep -q 'MUTED'; then
        wpctl set-mute $DEFAULT_SINK 0 # Set mute state to OFF
    fi
    # Then apply the volume decrease
    wpctl set-volume $DEFAULT_SINK 5%-

elif [[ "$1" == "mute" ]]; then
    wpctl set-mute $DEFAULT_SINK toggle
fi

# Send the notification after the command runs
send_notification
