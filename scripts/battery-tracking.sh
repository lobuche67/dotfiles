#!/bin/bash
# 🛡️ Lock check: Prevent multiple instances
# If more than one process with this name exists, exit the newest one.
if pgrep -x "$(basename "$0")" | grep -v $$ > /dev/null; then
    exit 0
fi

LOG_FILE="$HOME/.battery_log.csv"
touch "$LOG_FILE"

# The logic loop
while true; do
    # Get current capacity (Percentage) directly from kernel
    if [ -f /sys/class/power_supply/BAT0/capacity ]; then
        PERCENT=$(cat /sys/class/power_supply/BAT0/capacity)
        TS=$(date +%s)
        
        echo "$TS $PERCENT" >> "$LOG_FILE"
        
        # Keep file lean: Trim to last 2880 lines (48 hours)
        # We only trim once an hour (every 60 mins) to save SSD wear
        ((count++))
        if [ $((count % 60)) -eq 0 ]; then
            tail -n 2880 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
        fi
    fi
    
    sleep 60
done
