#!/bin/bash

# Find socket path dynamically if environment variables are not loaded
if [ -z "$XDG_RUNTIME_DIR" ]; then
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    # Find the first signature folder matching the regex pattern
    SIGNATURE=$(ls -1 "$XDG_RUNTIME_DIR/hypr/" 2>/dev/null | grep -E '^[0-9a-fA-F_]+$' | head -n 1)
    if [ -n "$SIGNATURE" ]; then
        SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$SIGNATURE/.socket2.sock"
    fi
else
    SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
fi

if [ -z "$SOCKET_PATH" ] || [ ! -S "$SOCKET_PATH" ]; then
    echo "Hyprland event socket not found."
    exit 1
fi

echo "Listening to Hyprland monitor events on $SOCKET_PATH..."

# Read line by line from the socket
socat - "UNIX-CONNECT:$SOCKET_PATH" | while read -r line; do
    if [[ "$line" =~ ^monitoradded\>\> || "$line" =~ ^monitorremoved\>\> ]]; then
        echo "Monitor change detected: $line"
        sleep 1
        if command -v omarchy-restart-waybar &>/dev/null; then
            omarchy-restart-waybar
        else
            pkill waybar && waybar &
        fi
    fi
done
