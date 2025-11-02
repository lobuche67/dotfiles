#!/bin/bash

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
    systemctl suspend
else
    # If plugged in (STATUS is 1), do nothing.
    echo "Power plugged in. Suspension aborted."
fi
