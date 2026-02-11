#!/bin/bash

# 1. Efficient check for our manual block
# This looks specifically for your Waybar-triggered inhibitor
if systemd-inhibit --list --mode=block | grep -q "manual-idle-inhibitor"; then
    
    # Thermal Safety Check
    # We divide by 1000 to get Celsius from millidegrees
    TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
    TEMP_C=$((TEMP / 1000))

    if [ "$TEMP_C" -lt 70 ]; then
        # Log the event for journalctl -f and exit
        logger -t "LID_EVENT" "Lid closed: Inhibitor active and Temp ($TEMP_C°C) is safe. Staying awake."
        exit 0  
    else
        logger -t "LID_EVENT" "Lid closed: Inhibitor active but Temp ($TEMP_C°C) too high! Suspending."
    fi
fi

# Define the location of the AC adapter status file. 
# This is usually 'AC' or 'AC0'. We check 'AC' first.
AC_STATUS_FILE="/sys/class/power_supply/AC/online"

# Check if the AC file exists (necessary for systems that might name it differently)
if [ ! -f "$AC_STATUS_FILE" ]; then
    # Fallback check if the standard name fails
    AC_STATUS_FILE="/sys/class/power_supply/AC0/online"
fi

# Read the status: '1' means plugged in (online), '0' means unplugged (offline)
STATUS=$(cat "$AC_STATUS_FILE")

# Check if the status is 0 (unplugged/on battery)
if [ "$STATUS" -eq 0 ]; then
    # If unplugged, proceed with suspension.
    logger -t "LID_EVENT" "Lid closed: On battery. Suspending to Deep Sleep."
    systemctl suspend
else
    # If plugged in (STATUS is 1), do nothing.
    logger -t "LID_EVENT" "Power plugged in. Suspension aborted."
fi
