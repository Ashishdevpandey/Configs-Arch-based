#!/bin/bash

# Config file: ~/.cache/workspace_walls.conf
# Format per line: workspace_id=/path/to/image.jpg
CONF="$HOME/.cache/workspace_walls.conf"
DEFAULT_WALL="$HOME/Pictures/Archive/Women/20.jpg"

# ─── Hyprland Signature ───────────────────────────────────────────────────────
if [[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" | head -n 1)
fi

log_file="/tmp/workspace-wall.log"
echo "Script started. Sig: $HYPRLAND_INSTANCE_SIGNATURE" > "$log_file"

# ─── Get wallpaper for a workspace from config ───────────────────────────────
get_wall() {
    local ws=$1
    if [[ -f "$CONF" ]]; then
        local img
        img=$(grep "^${ws}=" "$CONF" | tail -1 | cut -d'=' -f2-)
        if [[ -n "$img" && -f "$img" ]]; then
            echo "$img"
            return
        fi
    fi
    # Fallback: last wallpaper set by picker
    local last="$HOME/.cache/wallpaper_picker/last_wallpaper.txt"
    if [[ -f "$last" ]]; then
        local lw
        lw=$(cat "$last")
        if [[ -f "$lw" ]]; then
            echo "$lw"
            return
        fi
    fi
    echo "$DEFAULT_WALL"
}

# ─── Apply wallpaper (no black flash) ────────────────────────────────────────
apply_wall() {
    local img=$1
    if [[ -f "$img" ]]; then
        echo "Applying: $img" >> "$log_file"
        swaybg -i "$img" -m fill >/dev/null 2>&1 &
        sleep 0.08
        pgrep -x swaybg | sort -n | head -n -1 | xargs -r kill 2>/dev/null || true
    fi
}

change_wallpaper() {
    local ws=$1
    local img
    img=$(get_wall "$ws")
    echo "WS=$ws → $img" >> "$log_file"
    apply_wall "$img"
}

# ─── Initial wallpaper ────────────────────────────────────────────────────────
current_ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')
change_wallpaper "$current_ws"

# ─── Listen for workspace events ─────────────────────────────────────────────
socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
echo "Listening: $socket_path" >> "$log_file"

socat -U - "UNIX-CONNECT:$socket_path" | while read -r line; do
    if [[ $line == workspace\>\>* ]]; then
        workspace_id="${line#*>>}"
        echo "Event: $line" >> "$log_file"
        change_wallpaper "$workspace_id"
    fi
done
