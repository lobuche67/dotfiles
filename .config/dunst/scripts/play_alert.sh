#!/bin/bash

# Play the sound file using paplay
# paplay ~/scripts/mixkit-software-interface-back-2575.wav &
pw-play --volume=0.1 ~/.local/share/sounds/mixkit-software-interface-back-2575.wav &

# The '&' is crucial: it runs paplay in the background so it doesn't block dunst.
