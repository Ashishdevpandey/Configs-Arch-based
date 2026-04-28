#!/bin/bash
# ============================================
# OMACHRY MASTER RESTORE SCRIPT
# Updated: 24 April 2026
# ============================================

echo "╔══════════════════════════════════════════╗"
echo "║   🚀 OMACHRY MASTER RESTORE SCRIPT      ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# 1. ALACRITTY
echo "[1/8] Alacritty..."
mkdir -p ~/.config/alacritty
cat > ~/.config/alacritty/alacritty.toml << 'EOF'
general.import = [ "~/.config/omarchy/current/theme/alacritty.toml" ]
[env]
TERM = "xterm-256color"
[terminal]
osc52 = "CopyPaste"
[font]
normal = { family = "iA Writer Mono S" }
bold = { family = "iA Writer Mono S" }
italic = { family = "iA Writer Mono S" }
size = 9
[window]
padding.x = 14
padding.y = 14
decorations = "None"
[keyboard]
bindings = [
{ key = "Insert", mods = "Shift", action = "Paste" },
{ key = "Insert", mods = "Control", action = "Copy" }
]
EOF

# 2. MONITORS
echo "[2/8] Monitors..."
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/monitors.conf << 'EOF'
env = GDK_SCALE,1.25
monitor=HDMI-A-1,preferred,0x0,1.25
monitor=eDP-1,preferred,1536x0,1.25
EOF

# 3. GAPS
echo "[3/8] Gaps..."
cat > ~/.config/hypr/looknfeel.conf << 'EOF'
general {
    gaps_out = 0
    gaps_in = 4
}
EOF

# 4. BINDINGS
echo "[4/8] Bindings..."
cat > ~/.config/hypr/bindings.conf << 'EOF'
bindd = SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"
bindd = SUPER SHIFT, RETURN, Browser, exec, flatpak run app.zen_browser.zen
bindd = SUPER SHIFT, F, File manager, exec, uwsm-app -- nautilus --new-window
bindd = SUPER SHIFT, B, Browser, exec, flatpak run app.zen_browser.zen
bindd = SUPER SHIFT ALT, B, Browser private, exec, flatpak run app.zen_browser.zen --private
bindd = SUPER SHIFT, N, Editor, exec, omarchy-launch-editor
bindd = SUPER, N, Antigravity, exec, antigravity
unbind = SUPER, SPACE
bindd = SUPER, SPACE, Omarchy menu, exec, omarchy-menu
bindd = SUPER, Q, Kill window, killactive
bindd = SUPER, M, Fullscreen, fullscreen
bindd = SUPER, T, Toggle split, togglesplit
bindd = SUPER, S, Swap windows, exec, hyprctl dispatch swapnext
bindd = SUPER, D, App launcher, exec, omarchy-launch-walker
bindd = SUPER, period, Focus next monitor, exec, hyprctl dispatch focusmonitor +1
bindd = SUPER, comma, Focus prev monitor, exec, hyprctl dispatch focusmonitor -1
bindd = SUPER SHIFT, period, Move to next monitor, movewindow, mon:+
bindd = SUPER SHIFT, comma, Move to prev monitor, movewindow, mon:-
bindd = SUPER SHIFT, P, Display switcher, exec, alacritty --class hyprmode -e hyprmode
bindd = SUPER ALT, E, Fix monitors, exec, hyprctl keyword monitor HDMI-A-1,preferred,0x0,1.25 ; hyprctl keyword monitor eDP-1,preferred,1536x0,1.25
bindd = , Print, Screenshot copy, exec, grimblast --notify copy area
bindd = SHIFT, Print, Screenshot save, exec, grimblast save area
bindd = SUPER, Print, Screenshot screen, exec, grimblast copy output
bindd = SUPER SHIFT, S, Screenshot area, exec, grimblast --notify copy area
bindd = SUPER SHIFT, Q, Exit Hyprland, exec, hyprctl dispatch exit
bindd = SUPER SHIFT, R, Reload config, exec, hyprctl reload
bindd = SUPER, L, Lock screen, exec, loginctl lock-session
bindd = SUPER, 1, Workspace 1, workspace, 1
bindd = SUPER, 2, Workspace 2, workspace, 2
bindd = SUPER, 3, Workspace 3, workspace, 3
bindd = SUPER, 4, Workspace 4, workspace, 4
bindd = SUPER, 5, Workspace 5, workspace, 5
bindd = SUPER, left, Focus left, movefocus, l
bindd = SUPER, right, Focus right, movefocus, r
bindd = SUPER, up, Focus up, movefocus, u
bindd = SUPER, down, Focus down, movefocus, d
bindd = SUPER SHIFT, left, Move window left, movewindow, l
bindd = SUPER SHIFT, right, Move window right, movewindow, r
unbind = SUPER, W
bindd = SUPER, H, Minimize window, movetoworkspacesilent, 10
unbind = SUPER SHIFT, BackSpace
bindd = SUPER SHIFT, BackSpace, True fullscreen, fullscreen
unbind = SUPER, ESCAPE
bindd = SUPER, ESCAPE, Power off, exec, systemctl poweroff

# Audio Control
bindd = , XF86AudioRaiseVolume, Raise volume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
bindd = , XF86AudioLowerVolume, Lower volume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindd = , XF86AudioMute, Mute audio, exec, pamixer -t
bindd = , XF86AudioMicMute, Mute mic, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

# Media Control
bindd = , XF86AudioPlay, Play/Pause, exec, playerctl play-pause
bindd = , XF86AudioNext, Next track, exec, playerctl next
bindd = , XF86AudioPrev, Previous track, exec, playerctl previous

# Hyprexpo / Workspace Overview
bind = SUPER, TAB, hyprexpo:expo, toggle
EOF

# 5. HYPRLAND
echo "[5/8] Hyprland..."
cat > ~/.config/hypr/hyprland.conf << 'EOF'
source = ~/.local/share/omarchy/default/hypr/autostart.conf
source = ~/.local/share/omarchy/default/hypr/bindings/media.conf
source = ~/.local/share/omarchy/default/hypr/bindings/clipboard.conf
source = ~/.local/share/omarchy/default/hypr/bindings/tiling-v2.conf
source = ~/.local/share/omarchy/default/hypr/bindings/utilities.conf
source = ~/.local/share/omarchy/default/hypr/envs.conf
source = ~/.local/share/omarchy/default/hypr/looknfeel.conf
source = ~/.local/share/omarchy/default/hypr/input.conf
source = ~/.local/share/omarchy/default/hypr/windows.conf
source = ~/.config/omarchy/current/theme/hyprland.conf
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/input.conf
source = ~/.config/hypr/bindings.conf
source = ~/.config/hypr/looknfeel.conf
source = ~/.config/hypr/autostart.conf
fullscreen = 1
exec-once = mako
env = XCURSOR_THEME,Bibata-Modern-Classic
env = XCURSOR_SIZE,24
env = HYPRCURSOR_THEME,Bibata-Modern-Classic
env = HYPRCURSOR_SIZE,24
exec-once = gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
exec-once = gsettings set org.gnome.desktop.interface cursor-size 24
exec-once = hyprctl setcursor Bibata-Modern-Classic 24

# Hyprexpo Plugin
# Plugin is loaded by hyprpm or manually via absolute path if needed.
# Since we use hyprpm, we add the reload command:
exec-once = hyprpm reload -n

plugin {
    hyprexpo {
        columns = 2
        gap_size = 5
        bg_col = rgb(111111)
    }
}
EOF

# 6. BASHRC
echo "[6/8] Bashrc..."
grep -q "fastfetch" ~/.bashrc || echo "fastfetch" >> ~/.bashrc

# 7. FASTFETCH
echo "[7/8] Fastfetch..."
mkdir -p ~/.config/fastfetch
cat > ~/.config/fastfetch/config.jsonc << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": { "type": "none" },
  "modules": [
    { "type": "title", "format": "┌──────────── System Info ────────────┐" },
    { "type": "host", "key": " PC" },
    { "type": "kernel", "key": " Kernel" },
    { "type": "packages", "key": "󰏖 Packages" },
    { "type": "memory", "key": " RAM" },
    { "type": "disk", "key": "󰋊 Disk" },
    { "type": "uptime", "key": "󱫐 Uptime" },
    { "type": "command", "key": " Last Update", "text": "omarchy-version-pkgs" }
  ]
}
EOF

# 8. NOTIFICATION SCRIPT
echo "[8/8] Notification script..."
cat > ~/.notif.sh << 'EOF'
#!/bin/bash
echo "=== Notification History ==="
echo ""
makoctl history | awk '
/^Notification [0-9]+:/ { 
    num=$2; gsub(/:/,"",num); 
    name=substr($0, index($0,$3)); 
    printf "#%s %s", num, name 
}
/^  App name:/ { 
    gsub(/^  App name: /,""); 
    printf " [%s]\n", $0 
}
'
echo ""
echo "======================"
echo "C - Clear all history"
echo "Q - Quit"
echo ""
read -p "Enter choice (C/Q): " choice
if [ "$choice" = "C" ] || [ "$choice" = "c" ]; then
    pkill mako
    sleep 1
    mako &
    echo "History cleared!"
    sleep 1
fi
EOF
chmod +x ~/.notif.sh

# 9. MEMOS BACKUP SCRIPT & TIMER
echo "[9/11] Memos Backup..."
mkdir -p ~/scripts
cat > ~/scripts/memos_backup.sh << 'EOF'
#!/bin/bash

# Configuration
SOURCE_DB="$HOME/.memos/memos_prod.db"
BACKUP_REPO_DIR="$HOME/memos-backup-sync"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# 1. Navigate to the backup repository
cd "$BACKUP_REPO_DIR" || exit

# 2. Copy the database file
cp "$SOURCE_DB" .

# 3. Git operations
git add memos_prod.db
git commit -m "Auto-backup: $TIMESTAMP"

# Try to push up to 12 times, waiting 10 seconds between tries (2 minutes total)
MAX_RETRIES=12
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if git push origin main; then
        echo "Successfully pushed to GitHub."
        break
    else
        echo "Push failed. Waiting for network... Retrying in 10 seconds ($((RETRY_COUNT + 1))/$MAX_RETRIES)"
        sleep 10
        RETRY_COUNT=$((RETRY_COUNT + 1))
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "Failed to push to GitHub after $MAX_RETRIES attempts."
    exit 1
fi
EOF
chmod +x ~/scripts/memos_backup.sh

mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/memos-backup.service << 'EOF'
[Unit]
Description=Daily Memos Database Backup to GitHub

[Service]
Type=oneshot
ExecStart=%h/scripts/memos_backup.sh
StandardOutput=append:%h/scripts/backup.log
StandardError=append:%h/scripts/backup.log

[Install]
WantedBy=default.target
EOF

cat > ~/.config/systemd/user/memos-backup.timer << 'EOF'
[Unit]
Description=Run Memos Backup Daily at 11AM

[Timer]
OnCalendar=*-*-* 11:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now memos-backup.timer

# 10. HYPREXPO SETUP
echo "[10/11] Hyprexpo Setup..."
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo


# 11. WAYBAR CONFIG
echo "[11/11] Waybar..."
mkdir -p ~/.config/waybar/scripts

cat > ~/.config/waybar/config.jsonc << 'EOF'
{
  "reload_style_on_change": true,
  "layer": "top",
  "position": "top",
  "spacing": 0,
  "height": 26,
  "tooltip": true,
  "tooltip-delay": 0,
  "modules-left": ["custom/omarchy", "hyprland/workspaces"],
  "modules-center": ["clock", "custom/update", "custom/voxtype", "custom/screenrecording-indicator", "custom/idle-indicator", "custom/notification-silencing-indicator"],
  "modules-right": [
    "custom/cava",
    "group/tray-expander",
    "pulseaudio",
    "cpu",
    "memory",
    "network",
    "bluetooth",
    "battery"
  ],
  "hyprland/workspaces": {
    "on-click": "activate",
    "format": "{icon}",
    "format-icons": {
      "default": "",
      "1": "1",
      "2": "2",
      "3": "3",
      "4": "4",
      "5": "5",
      "6": "6",
      "7": "7",
      "8": "8",
      "9": "9",
      "10": "0",
      "active": "󱓻"
    },
    "persistent-workspaces": {
      "1": [],
      "2": [],
      "3": [],
      "4": [],
      "5": []
    },
    "tooltip": true
  },
  "custom/omarchy": {
    "format": "<span font='omarchy'>\ue900</span>",
    "on-click": "omarchy-menu",
    "on-click-right": "xdg-terminal-exec",
    "tooltip-format": "Omarchy Menu\n\nSuper + Alt + Space"
  },
  "custom/update": {
    "format": "",
    "exec": "omarchy-update-available",
    "on-click": "omarchy-launch-floating-terminal-with-presentation omarchy-update",
    "tooltip-format": "Omarchy update available",
    "signal": 7,
    "interval": 21600
  },

  "cpu": {
    "interval": 2,
    "format": "{usage}% 󰍛",
    "on-click": "omarchy-launch-or-focus-tui btop",
    "on-click-right": "alacritty",
    "tooltip": true
  },
  "memory": {
    "interval": 2,
    "format": "{}% ",
    "on-click": "omarchy-launch-or-focus-tui btop",
    "tooltip": true
  },
  "clock": {
    "interval": 1,
    "format": "{:L%A %H:%M:%S}",
    "format-alt": "{:L%d %B W%V %Y}",
    "tooltip": false,
    "tooltip-format": "",
    "on-click-right": "omarchy-launch-floating-terminal-with-presentation omarchy-tz-select"
  },
  "network": {
    "format-icons": ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
    "format": "{icon} {bandwidthDownBytes} ↓",
    "format-wifi": "{icon} {bandwidthDownBytes} ↓",
    "format-ethernet": "󰀂 {bandwidthDownBytes} ↓",
    "format-disconnected": "󰤮",
    "tooltip-format-wifi": "{essid} ({frequency} GHz)",
    "tooltip-format-ethernet": "Connected",
    "tooltip-format-disconnected": "Disconnected",
    "interval": 3,
    "spacing": 1,
    "on-click": "omarchy-launch-wifi",
    "tooltip": true
  },
  "battery": {
    "format": "{capacity}% {icon}",
    "format-discharging": "{capacity}% {icon}",
    "format-charging": "{capacity}% {icon}",
    "format-plugged": "{capacity}% ",
    "format-icons": {
      "charging": ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
      "default": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    },
    "format-full": "󰂅",
    "tooltip-format-discharging": "{power:>1.0f}W↓ {capacity}%",
    "tooltip-format-charging": "{power:>1.0f}W↑ {capacity}%",
    "interval": 5,
    "on-click": "omarchy-menu power",
    "states": {
      "warning": 20,
      "critical": 10
    },
    "tooltip": true
  },
  "bluetooth": {
    "format": "",
    "format-off": "󰂲",
    "format-disabled": "󰂲",
    "format-connected": "󰂱",
    "format-no-controller": "",
    "tooltip-format": "{controller_alias}\t{controller_address}",
    "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{device_enumerate}",
    "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}",
    "on-click": "omarchy-launch-bluetooth",
    "tooltip": true
  },
  "pulseaudio": {
    "format": "{icon} {volume}%",
    "on-click": "omarchy-launch-audio",
    "on-click-right": "pamixer -t",
    "tooltip-format": "Playing at {volume}%",
    "scroll-step": 5,
    "format-muted": "",
    "format-icons": {
      "headphone": "",
      "headset": "",
      "default": ["", "", ""]
    },
    "tooltip": true
  },
  "group/tray-expander": {
    "orientation": "inherit",
    "drawer": {
      "transition-duration": 600,
      "children-class": "tray-group-item"
    },
    "modules": ["tray", "custom/expand-icon"]
  },
  "custom/expand-icon": {
    "format": "",
    "tooltip": false,
    "on-scroll-up": "",
    "on-scroll-down": "",
    "on-scroll-left": "",
    "on-scroll-right": ""
  },
  "custom/screenrecording-indicator": {
    "on-click": "omarchy-cmd-screenrecord",
    "exec": "$OMARCHY_PATH/default/waybar/indicators/screen-recording.sh",
    "signal": 8,
    "return-type": "json"
  },
  "custom/idle-indicator": {
    "on-click": "omarchy-toggle-idle",
    "exec": "$OMARCHY_PATH/default/waybar/indicators/idle.sh",
    "signal": 9,
    "return-type": "json"
  },
  "custom/notification-silencing-indicator": {
    "on-click": "omarchy-toggle-notification-silencing",
    "exec": "$OMARCHY_PATH/default/waybar/indicators/notification-silencing.sh",
    "signal": 10,
    "return-type": "json"
  },
  "custom/voxtype": {
    "exec": "omarchy-voxtype-status",
    "return-type": "json",
    "format": "{icon}",
    "format-icons": {
      "idle": "",
      "recording": "󰍬",
      "transcribing": "󰔟"
    },
    "tooltip": true,
    "on-click-right": "omarchy-voxtype-config",
    "on-click": "omarchy-voxtype-model"
  },
  "custom/cava": {
    "exec": "/home/ashish/.config/waybar/scripts/cava.sh",
    "format": "{}",
    "return-type": "json",
    "tooltip": true,
    "on-click": "playerctl play-pause",
    "on-scroll-up": "playerctl next",
    "on-scroll-down": "playerctl previous"
  },

  "tray": {
    "icon-size": 12,
    "spacing": 17
  }
}
EOF

cat > ~/.config/waybar/style.css << 'EOF'
@import "../omarchy/current/theme/waybar.css";

#waybar {
  background-color: #2d353b;
}

* {
  background-color: transparent;
  color: @foreground;
  border: none;
  border-radius: 0;
  min-height: 0;
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 11px;
}

.modules-left {
  margin-left: 8px;
  min-height: 26px;
}

.modules-center {
  min-height: 26px;
}

.modules-right {
  margin-right: 8px;
  min-height: 26px;
}

#workspaces button {
  padding: 0 6px;
  margin: 0 1.5px;
  min-width: 9px;
  color: @foreground;
}

#workspaces button.empty {
  opacity: 0.5;
}

#custom-omarchy,
#custom-update {
  min-width: 12px;
  margin: 0 7.5px;
}

#tray {
  margin-right: 16px;
}

#network,
#pulseaudio,
#cpu,
#memory,
#bluetooth,
#battery,


#custom-cava.playing,
#custom-cava.paused {
  margin-right: 13px;
  border: 1px solid @foreground;
  padding: 0 8px;
  border-radius: 4px;
  background-color: rgba(255, 255, 255, 0.1);
}

#custom-cava.hidden {
  border: none;
  background-color: transparent;
  padding: 0;
  margin: 0;
}

#clock {
  margin-left: 8.75px;
}

#custom-cava {
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 16px;
  color: @foreground;
  padding: 0 10px;
  margin-right: 15px;
  min-width: 60px;
}

#custom-expand-icon {
  margin-right: 18px;
}

tooltip,
#tooltip {
  all: unset;
  background-color: #2d353b;
  color: #d3c6aa;
  border: 2px solid #d3c6aa;
  border-radius: 8px;
  padding: 12px;
  margin-top: 15px;
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 12px;
}

#workspaces button:hover,
#network:hover,
#pulseaudio:hover,
#cpu:hover,
#memory:hover,
#battery:hover,
#bluetooth:hover,
#custom-cava:hover,
#custom-omarchy:hover,
#custom-update:hover,
#custom-cava.playing:hover,
#custom-cava.paused:hover {
  color: #ffffff;
  text-shadow: 0 0 8px rgba(255, 255, 255, 0.8);
  background-color: rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

#custom-update {
  font-size: 10px;
}

#clock {
  margin-left: 8.75px;
}

#clock:hover {
  background-color: transparent;
  text-shadow: none;
  color: @foreground;
}

.hidden {
  opacity: 0;
}

#custom-screenrecording-indicator,
#custom-idle-indicator,
#custom-notification-silencing-indicator {
  min-width: 12px;
  margin-left: 5px;
  margin-right: 0;
  font-size: 10px;
  padding-bottom: 1px;
}

#custom-screenrecording-indicator.active {
  color: #a55555;
}

#custom-idle-indicator.active,
#custom-notification-silencing-indicator.active {
  color: #a55555;
}

#custom-voxtype {
  min-width: 12px;
  margin: 0 0 0 7.5px;
}

#custom-voxtype.recording {
  color: #a55555;
}
EOF

cat > ~/.config/waybar/scripts/cava.sh << 'EOF'
#!/bin/bash

# Prevent multiple instances
for pid in $(pgrep -f "bash $HOME/.config/waybar/scripts/cava.sh"); do
    if [ "$pid" != "$$" ]; then
        kill "$pid" 2>/dev/null
    fi
done

trap "kill 0" EXIT

# Configuration
BARS=8
CONFIG_FILE="/tmp/waybar_cava_config_$(id -u)"

# Create cava config
cat <<EOF > "$CONFIG_FILE"
[general]
bars = $BARS
sensitivity = 100
[input]
method = pulse
source = auto
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Characters for the visualizer
dict=(" " "▂" "▃" "▄" "▅" "▆" "▇" "█")

# Auto-restart loop to prevent "stuck" or "closed" bars
while true; do
    if ! command -v cava >/dev/null; then
        echo '{"text": "cava not found", "class": "error"}'
        sleep 10
        continue
    fi

    counter=0
    status="Playing"
    tooltip="Loading..."

    cava -p "$CONFIG_FILE" | while read -r line; do
        if [ $counter -eq 0 ]; then
            # Check player status globally, prioritizing browser
            status=$(playerctl -p firefox,chromium,vlc,mpv,spotify status 2>/dev/null | grep -m 1 "Playing" || playerctl status 2>/dev/null | grep -m 1 "Playing" || playerctl status 2>/dev/null | head -n 1)
            
            if [ -z "$status" ]; then
                status="Stopped"
                tooltip="No music player found"
            else
                # Fetch song info, prioritizing browser
                tooltip=$(playerctl -p firefox,chromium,vlc,mpv,spotify --status=playing metadata --format "[{{ playerName }}] {{ artist }} - {{ title }}" 2>/dev/null)
                [ -z "$tooltip" ] && tooltip=$(playerctl -p firefox,chromium,vlc,mpv,spotify metadata --format "[{{ playerName }}] {{ artist }} - {{ title }}" 2>/dev/null)
                [ -z "$tooltip" ] && tooltip=$(playerctl metadata --format "[{{ playerName }}] {{ artist }} - {{ title }}" 2>/dev/null || echo "Nothing playing")
            fi
        fi
        
        # update counter
        counter=$(( (counter + 1) % 30 ))
        
        if [ "$status" = "Stopped" ]; then
            echo '{"text": "", "class": "hidden", "tooltip": "No music player found"}'
            continue
        fi

        # Process the semicolon-separated output from cava
        # We use sed to remove the trailing semicolon to avoid an empty element
        clean_line=$(echo "$line" | sed 's/;$//')
        IFS=';' read -ra ADDR <<< "$clean_line"
        
        text=""
        for i in "${ADDR[@]}"; do
            if [ -n "$i" ] && [ "$i" -ge 0 ] && [ "$i" -lt ${#dict[@]} ]; then
                text+="${dict[$i]}"
            else
                text+=" "
            fi
        done
        
        # Use jq to generate safe JSON
        class=$(echo "$status" | tr '[:upper:]' '[:lower:]')
        jq -n --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" '{text: $text, tooltip: $tooltip, class: $class}' -c
    done
    sleep 1
done
EOF
chmod +x ~/.config/waybar/scripts/cava.sh

cat > ~/.config/waybar/scripts/player_status.sh << 'EOF'
#!/bin/bash

# Get the most relevant player (prioritize Playing)
player=$(playerctl -l 2>/dev/null | while read -r p; do
    status=$(playerctl -p "$p" status 2>/dev/null)
    if [ "$status" = "Playing" ]; then
        echo "$p"
        exit 0
    fi
done | head -n 1)

# Fallback to the first available player if none are playing
if [ -z "$player" ]; then
    player=$(playerctl -l 2>/dev/null | head -n 1)
fi

if [ -z "$player" ]; then
    echo '{"text": "", "class": "hidden"}'
    exit 0
fi

status=$(playerctl -p "$player" status 2>/dev/null)
title=$(playerctl -p "$player" metadata --format "{{title}}" 2>/dev/null | cut -c1-30)
artist=$(playerctl -p "$player" metadata --format "{{artist}}" 2>/dev/null)

if [ "$status" = "Playing" ]; then
    echo "{\"text\": \"$title\", \"tooltip\": \"$artist - $title ($player)\", \"class\": \"playing\"}"
elif [ "$status" = "Paused" ]; then
    echo "{\"text\": \"$title\", \"tooltip\": \"$artist - $title ($player)\", \"class\": \"paused\"}"
else
    echo '{"text": "", "class": "hidden"}'
fi
EOF
chmod +x ~/.config/waybar/scripts/player_status.sh

# INSTALL PACKAGES
echo ""
echo "Installing packages..."
sudo pacman -S --noconfirm alacritty grimblast fastfetch waybar hyprland hyprmode mako 2>/dev/null

# RELOAD
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   ✅ RESTORE COMPLETE!                   ║"
echo "╚══════════════════════════════════════════╝"
hyprctl reload 2>/dev/null && echo "✅ Hyprland reloaded!" || echo "⚠️ Run: hyprctl reload"
