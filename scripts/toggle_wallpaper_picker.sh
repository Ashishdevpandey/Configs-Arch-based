#!/bin/bash
if pgrep -f "wallpaper_picker.py" > /dev/null; then
    pkill -f "wallpaper_picker.py"
else
    python3 /home/ashish/scripts/wallpaper_picker.py
fi
