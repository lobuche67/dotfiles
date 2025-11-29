#!/bin/bash

# ====================================================================
# Configuration
# ====================================================================

# Replace with your Jellyfin server URL and port
JF_URL="https://jellyfin.lobuche.stream"

# Replace with the API key you generated in the Jellyfin Dashboard
JF_API_KEY="d96849845ead4a92833dac7093b9499c"

# ====================================================================
# Logic
# ====================================================================

# Use curl to fetch sessions, filter for active (NowPlayingItem exists), and count them.
SESSION_COUNT=$(curl -s -H "X-MediaBrowser-Token: $JF_API_KEY" "$JF_URL/Sessions" | \
jq -r '[.[] | select(.NowPlayingItem != null)] | length')

# Output a simple string based on the count for Eww to display
if [ "$SESSION_COUNT" -gt 0 ]; then
    # Output the count and an icon (Play icon  or your preferred Nerd Font icon)
    echo " $SESSION_COUNT ACTIVE"
else
    # Output a simple 'Quiet' status with an icon (Muted Speaker 󰮪)
    echo " Quiet"
fi
