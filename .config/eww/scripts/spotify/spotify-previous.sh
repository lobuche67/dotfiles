#!/bin/bash

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.ncspot /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
