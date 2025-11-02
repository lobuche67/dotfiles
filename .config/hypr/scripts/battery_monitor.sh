#!/bin/bash

# Configuration
BATTERY_PATH="/sys/class/power_supply/BAT0" # <-- CHANGE BAT0 TO YOUR CORRECT NAME (e.g., BAT1)
NOTIFY_ID=6000 # Unique ID for battery notifications

# Thresholds
CRITICAL_LEVEL=20
WARNING_LEVEL=30

# State storage: tracks the last notification sent OR the charging state.
LAST_STATUS="" 

send_notification() {
    local ICON="$1"
    local LEVEL="$2"
    local STATUS="$3"
    local URGENCY="$4"

    dunstify -r $NOTIFY_ID -u $URGENCY \
             -h string:x-dunst-stack-tag:battery \
             -h int:value:$LEVEL \
             "$ICON Battery $STATUS" "Level: ${LEVEL}%"
}

while true; do
    # Check if the battery path exists
    if [ ! -d "$BATTERY_PATH" ]; then
        sleep 600
        continue
    fi

    CAPACITY=$(cat "$BATTERY_PATH/capacity")
    STATUS=$(cat "$BATTERY_PATH/status")
    
    # --- AC STATUS CHANGE CHECKS (Priority 1) ---
    
    # --- FULLY CHARGED CHECK (Priority 3) ---
    if [ "$CAPACITY" -ge 99 ] || [ "$STATUS" == "Full" ]; then
        if [ "$LAST_STATUS" != "FULL" ]; then
            #send_notification "🔋" "$CAPACITY" "Charged" "normal"
            dunstify -i NONE -r $NOTIFY_ID -u normal -h int:value:"$CAPACITY" \
                "󰂅 Fully Charged: ${CAPACITY}%" "Charging complete. Remove charger to preserve battery health."
            LAST_STATUS="FULL"
        fi
    # 1. Plugged In
    elif [ "$STATUS" == "Charging" ] || [ "$STATUS" == "Full" ]; then
        if [ "$LAST_STATUS" != "PLUGGED" ]; then
            #send_notification " plugged in" "$CAPACITY" "Charging" "low"
            dunstify -i NONE -r $NOTIFY_ID -u low -h int:value:"$CAPACITY" \
                "󰢞 Power Plugged In: ${CAPACITY}%" "Connected to power. Recharging now."
            LAST_STATUS="PLUGGED"
        fi
    
    # 2. Unplugged
    elif [ "$STATUS" == "Discharging" ]; then
        if [ "$LAST_STATUS" == "PLUGGED" ]; then
            #send_notification " disconnected" "$CAPACITY" "On Battery" "low"
            dunstify -i NONE -r $NOTIFY_ID -u low -h int:value:"$CAPACITY" \
                "󰁾 On Battery: ${CAPACITY}%" "Power adapter disconnected. Charging paused."
            LAST_STATUS="DISCHARGING"
        fi
    fi

    # --- LEVEL CHECKS (Priority 2: Only check if NOT at a special state) ---
    
    # The LAST_STATUS check here prevents the script from spamming the
    # 'PLUGGED' notification every 2 minutes while charging.
    
    if [ "$STATUS" == "Discharging" ]; then
        
        # A. CRITICAL LEVEL CHECK
        if [ "$CAPACITY" -le "$CRITICAL_LEVEL" ]; then
            if [ "$LAST_STATUS" != "CRITICAL" ]; then
                #send_notification "⚠️" "$CAPACITY" "CRITICAL" "critical"
                dunstify -r $NOTIFY_ID -u critical -h int:value:"$CAPACITY" \
                    "󱃍 Low Battery! ${CAPACITY}%" "Your battery is very low. The system will hibernate soon if not charged."
                LAST_STATUS="CRITICAL"
            fi

        # B. WARNING LEVEL CHECK
        elif [ "$CAPACITY" -le "$WARNING_LEVEL" ]; then
            if [ "$LAST_STATUS" != "WARNING" ]; then
                #send_notification "🔋" "$CAPACITY" "Low" "critical"
                dunstify -r $NOTIFY_ID -u critical -h int:value:"$CAPACITY" \
                    "󰁺 Low Battery! ${CAPACITY}%" "Low battery warning: Recharge your device to prevent data loss."                
                LAST_STATUS="WARNING"
            fi
        fi
    fi

    
    sleep 5 # Check every 5 seconds
done
