#!/bin/bash

# --- CONFIGURATION ---
MAGIC_WORKSPACE="magic"
STATE_FILE="/tmp/hypr_magic_restore_final.map"

# --- CORE LOGIC ---

# SCENARIO 1: RESTORE WINDOWS (State file exists)
if [ -s "$STATE_FILE" ]; then

    echo "Restoring windows from $MAGIC_WORKSPACE to original monitors..."

    while IFS=: read -r ADDRESS ORIGINAL_WORKSPACE_ID ORIGINAL_MONITOR; do

        # 1. Ensure the original workspace is on the correct monitor
        hyprctl dispatch moveworkspacetomonitor "$ORIGINAL_WORKSPACE_ID" "$ORIGINAL_MONITOR"

        # 2. Move the window back to its original workspace ID
        hyprctl dispatch movetoworkspacesilent "$ORIGINAL_WORKSPACE_ID",address:"$ADDRESS"

    done < "$STATE_FILE"

    rm "$STATE_FILE"

# SCENARIO 2: STASH WINDOWS (Active windows exist)
elif hyprctl clients -j | jq -e '.[] | select(.workspace.id != -1)' > /dev/null; then

    echo "Stashing all visible windows to $MAGIC_WORKSPACE..."

    # 1. Get the simple map of Workspace ID to Monitor Name
    # We use a filter that ensures it's operating on the objects inside the array.
    # The parentheses around (.id) and (.monitor) ensure they are processed correctly as fields.
    WORKSPACE_MONITOR_MAP=$(hyprctl workspaces -j | jq -r '.[] | (.id | tostring) + ":" + .monitor')

    # 2. Get client addresses and workspace IDs
    CLIENT_LIST=$(hyprctl clients -j | jq -r '.[] | select(.workspace.id != -1 and .workspace.name != "special:'"$MAGIC_WORKSPACE"'") | .address + ":" + (.workspace.id | tostring)')

    # 3. Iterate and process each window
    echo "$CLIENT_LIST" | while IFS=: read -r ADDRESS ORIGINAL_WORKSPACE_ID; do

        # LOOKUP: Search the workspace map for the monitor name
        MONITOR_NAME=$(echo "$WORKSPACE_MONITOR_MAP" | grep "^$ORIGINAL_WORKSPACE_ID:" | cut -d: -f2)

        # If the monitor name is found, store the state (ADDRESS:ID:MONITOR)
        if [ -n "$MONITOR_NAME" ]; then
            echo "$ADDRESS:$ORIGINAL_WORKSPACE_ID:$MONITOR_NAME" >> "$STATE_FILE"
        fi

        # Move the window to the special workspace silently
        hyprctl dispatch movetoworkspacesilent special:"$MAGIC_WORKSPACE",address:"$ADDRESS"

    done

    # Check if anything was stashed before proceeding
    if [ ! -s "$STATE_FILE" ]; then
        echo "No clients were found to stash."
        exit 0
    fi

    # Toggle the special workspace to ensure the desktop appears empty (Show Desktop effect)
    # hyprctl dispatch togglespecialworkspace $MAGIC_WORKSPACE


else
    # SCENARIO 3: NO WINDOWS TO HIDE
    echo "No visible windows to stash."
fi
