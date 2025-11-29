

#!/bin/bash

# Configuration (Replace these with your actual details)
JF_URL="https://jellyfin.lobuche.stream"
JF_API_KEY="d96849845ead4a92833dac7093b9499c"

# Use curl to fetch sessions, filtering for sessions that are currently playing
# We only want the first active session if multiple things are playing
curl -s -H "X-MediaBrowser-Token: $JF_API_KEY" "$JF_URL/Sessions" | \
jq -r '
  .[] | 
  select(.NowPlayingItem != null) | 
  (
    "User: " + .UserName + 
    " - Title: " + .NowPlayingItem.Name + 
    " - Type: " + .NowPlayingItem.Type + 
    " - Progress: " + ((.PlayState.PositionTicks / .NowPlayingItem.RunTimeTicks) * 100 | round | tostring) + "%"
  )
'
# Note: The jq query needs to be precise based on the API response structure.
