#!/bin/bash

# ====================================================================
# Configuration
# ====================================================================

# 1. Your NAS SSH Username
# Replace 'guestuser' with the actual username you use to log into your NAS.
NAS_USER="lobuche"

# 2. Your NAS IP Address or Hostname
# Replace with the local IP (e.g., 192.168.1.50) or hostname (e.g., mynas.local)
NAS_HOST="192.168.0.4"

# 3. Your Preferred Terminal Emulator
# Replace 'alacritty' with your Hyprland terminal choice: kitty, foot, wezterm, etc.
TERMINAL="rio"

# ====================================================================
# Execution
# ====================================================================

# The command structure is:
# [Terminal Emulator] -e ssh [Username]@[Host]

# -e is the common flag used by most terminals to execute a command
# and keep the terminal open until that command finishes.
# "$TERMINAL" -e kitten ssh -p 6789 "$NAS_USER"@"$NAS_HOST"
"$TERMINAL" -e ssh -p 6789 "$NAS_USER"@"$NAS_HOST"

# Note: The Eww button handler already runs this script in the background
# (using `...open_nas_ssh.sh &`), which ensures Eww doesn't wait for the terminal to close.
