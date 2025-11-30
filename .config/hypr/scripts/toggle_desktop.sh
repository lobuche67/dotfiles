#!/bin/bash

# --- CONFIGURATION ---
MAGIC_WORKSPACE="magic"
STATE_FILE="/tmp/hypr_magic_restore.map"

# --- CORE LOGIC ---

# SCENARIO 1: RESTORE WINDOWS (State file exists)
if [ -s "$STATE_FILE" ]; then

    CLEAN_STATE=$(tr -d '\r' < "$STATE_FILE")

    # Pass 1: Build commands to move windows back to their original workspaces.
    # This forces Hyprland to re-create any de-allocated workspaces.
    WINDOW_CMDS=$(echo "$CLEAN_STATE" | awk -F: '{print "dispatch movetoworkspacesilent " $2 ",address:"$1}')

    # Pass 2: Build commands to move the now-existing workspaces to their original monitors.
    WORKSPACE_CMDS=$(echo "$CLEAN_STATE" | cut -d: -f2,3 | sort -u | awk -F: '{print "dispatch moveworkspacetomonitor " $1 " " $2}')

    # Combine commands into a single batch. Window moves MUST come first.
    BATCH_CMD=$( (echo "$WINDOW_CMDS"; echo "$WORKSPACE_CMDS") | paste -sd';' )

    # Execute the entire transaction atomically.
    hyprctl --batch "$BATCH_CMD"

    # Clean up the state file.
    rm "$STATE_FILE"

# SCENARIO 2: STASH WINDOWS (Active windows exist)
elif hyprctl clients -j | jq -e '.[] | select(.workspace.id > 0)' > /dev/null; then

    # Create the state file.
    jq -r -n --argjson clients "$(hyprctl clients -j)" --argjson workspaces "$(hyprctl workspaces -j)" '
        ($workspaces | map({(.id|tostring): .monitor}) | add) as $ws_to_monitor |
        $clients | map(
            select(.workspace.id > 0 and .workspace.name != "special:'"$MAGIC_WORKSPACE"'") |
            .address + ":" + (.workspace.id|tostring) + ":" + $ws_to_monitor[(.workspace.id|tostring)]
        ) | .[]
    ' > "$STATE_FILE"

    if [ ! -s "$STATE_FILE" ]; then exit 0; fi

    # Build and execute the stash command in a single batch.
    BATCH_STASH_CMD=$(cut -d: -f1 "$STATE_FILE" | awk -v ws="special:$MAGIC_WORKSPACE" '{print "dispatch movetoworkspacesilent " ws ",address:"$1}' | paste -sd';')
    hyprctl --batch "$BATCH_STASH_CMD"

else
    # SCENARIO 3: NO WINDOWS TO HIDE, DO NOTHING.
    exit 0
fi
