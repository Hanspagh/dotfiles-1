#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if [ "$HOSTNAME" = ecly ]; then
    MONITOR=DVI-I-1 polybar main &
    MONITOR=HDMI-0 polybar secondary &
    MONITOR=DP-0 polybar secondary &
else 
    MONITOR=eDP1 polybar laptop &
fi
