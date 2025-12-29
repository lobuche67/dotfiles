#!/bin/bash
BIN="wvkbd-mobintl"

if pgrep -x "$BIN" > /dev/null; then
    killall "$BIN"
else
    # Launch it (backgrounded)
    $BIN &
fi
