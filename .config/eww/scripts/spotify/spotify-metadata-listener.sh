#!/bin/bash
# ~/.config/eww/scripts/spotify/spotify-metadata-listener.sh
# Outputs Song, Artist, Status, and Cover as a single line of JSON upon event.
# Requires: playerctl and jq

# --- Configuration ---
PLAYER_NAME="naviterm" # <-- Updated to match your specific player

# --- Dependency Check ---
if ! command -v playerctl >/dev/null || ! command -v jq >/dev/null; then
    echo '{"status": "Error", "song": "Missing Deps", "artist": "N/A", "cover": ""}'
    exit 1
fi

# Function to get and print Song, Artist, Status, and Cover as JSON
get_metadata_json() {
    # Check if the player is running
    if playerctl -p "$PLAYER_NAME" status &>/dev/null; then
        STATUS=$(playerctl -p "$PLAYER_NAME" status 2>/dev/null)
        SONG=$(playerctl -p "$PLAYER_NAME" metadata title 2>/dev/null)
        ARTIST=$(playerctl -p "$PLAYER_NAME" metadata artist 2>/dev/null)
        COVER=$(playerctl -p "$PLAYER_NAME" metadata mpris:artUrl 2>/dev/null)

        # Handle potentially empty cover URL and escape ampersands
        COVER_URL_ESCAPED="${COVER//&/\\&}"

        # Use jq -n -c for compact, single-line JSON output
        jq -n -c \
               --arg status "${STATUS:-Stopped}" \
               --arg song "${SONG:-Unknown Song}" \
               --arg artist "${ARTIST:-Unknown Artist}" \
               --arg cover "${COVER_URL_ESCAPED}" \
               '{status: $status, song: $song, artist: $artist, cover: $cover}'
    else
        # Player stopped or not found: output default JSON
        echo '{"status": "Stopped", "song": "Nothing Playing", "artist": "N/A", "cover": ""}'
    fi
}

# --- Event Listener Setup ---

# Create the FIFO pipe
FIFO_PIPE=$(mktemp -u)
mkfifo "$FIFO_PIPE"

# Variables to hold listener PIDs for cleanup
PID_METADATA=
PID_STATUS=

# Function to start the two follow processes
start_listeners() {
    # Kill existing listeners if they exist (for restart safety)
    kill $PID_METADATA $PID_STATUS 2>/dev/null

    # Start the two robust event listeners
    playerctl -p "$PLAYER_NAME" --follow metadata > "$FIFO_PIPE" &
    PID_METADATA=$!
    
    playerctl -p "$PLAYER_NAME" --follow status > "$FIFO_PIPE" &
    PID_STATUS=$!
}


# 1. Print initial status (Will be "Stopped" if player is missing)
get_metadata_json

# --- Player Polling Logic (Fixes the reboot issue) ---

# Check if the player is running. If not, wait for it.
if ! playerctl -p "$PLAYER_NAME" status &>/dev/null; then
    # Player is missing. Enter a polling loop.
    # The initial "Stopped" JSON is already printed, so Eww shows the default.
    
    while ! playerctl -p "$PLAYER_NAME" status &>/dev/null; do
        sleep 3 # Check every 3 seconds for the player to start
    done
    
    # Player found! Send an immediate update to Eww and start listeners.
    get_metadata_json
fi

# 2. Start the event listeners now that we know the player is running (or just started)
start_listeners

# --- Main Event Processing Loop (with Debouncing) ---
while read -r; do
    # Debouncing Logic: Consume subsequent rapid-fire events from the pipe
    while read -r -t 0.05 < "$FIFO_PIPE"; do
        : 
    done

    # Execute the action only once after the event burst is complete
    get_metadata_json
done < "$FIFO_PIPE"


# --- Cleanup (Rarely reached, but good practice) ---
rm -f "$FIFO_PIPE"
kill $PID_METADATA $PID_STATUS 2>/dev/null
