#!/bin/bash
LAST_WALL_FILE="$HOME/.cache/wallpaper_picker/last_wallpaper.txt"
sleep 1
if [[ -f "$LAST_WALL_FILE" ]]; then
    WALLPAPER=$(cat "$LAST_WALL_FILE")
    if [[ -f "$WALLPAPER" ]]; then
        pkill -x swaybg
        swaybg -i "$WALLPAPER" -m fill >/dev/null 2>&1 &
    fi
fi
