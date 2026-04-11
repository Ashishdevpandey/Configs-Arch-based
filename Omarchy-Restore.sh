#!/bin/bash
# ============================================
# OMACHRY MASTER RESTORE SCRIPT
# Created: 11 April 2026
# Contains ALL customizations done today
# ============================================

echo "╔══════════════════════════════════════════╗"
echo "║   🚀 OMACHRY MASTER RESTORE SCRIPT      ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# --------------------------------------------
# 1. ALACRITTY CONFIG
# --------------------------------------------
echo "[1/8] Restoring Alacritty config..."
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
{ key = "Insert", mods = "Control", action = "Copy" },
{ key = "Return", mods = "Shift", chars = "\u001B\r" }
]
EOF
echo "   ✅ Alacritty config restored"

# --------------------------------------------
# 2. MONITORS CONFIG (Left-Right Swap)
# --------------------------------------------
echo "[2/8] Restoring monitors config (External LEFT, Laptop RIGHT)..."
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/monitors.conf << 'EOF'
# See https://wiki.hyprland.org/Configuring/Monitors/
# List current monitors and resolutions possible: hyprctl monitors
# Format: monitor = [port], resolution, position, scale

# ------------------------------------------------------------
# SCALING EXAMPLES (commented for reference)
# ------------------------------------------------------------

# Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.
# env = GDK_SCALE,1
# monitor=,preferred,auto,auto,vrr,1

# Good compromise for 27" or 32" 4K monitors (but fractional!)
# env = GDK_SCALE,1.45
# monitor=,preferred,auto,1.25

# Straight 1x setup for low-resolution displays like 1080p or 1440p
# Or for ultrawide monitors like 34" 3440x1440 or 49" 5120x1440
# env = GDK_SCALE,1
# monitor=,preferred,auto,1

# Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°)
# monitor = DP-2, preferred, auto, 1, transform, 1

# Example for Framework 13 w/ 6K XDR Apple display
# monitor = DP-5, 6016x3384@60, auto, 2
# monitor = eDP-1, 2880x1920@120, auto, 2

# ------------------------------------------------------------
# MULTI-MONITOR POSITIONING EXAMPLES
# ------------------------------------------------------------

# External monitor on LEFT, laptop on RIGHT (current setup)
# monitor=HDMI-A-1,preferred,0x0,1.25
# monitor=eDP-1,preferred,1536x0,1.25

# Laptop on LEFT, external on RIGHT (original/default setup)
# monitor=eDP-1,preferred,0x0,1.25
# monitor=HDMI-A-1,preferred,1536x0,1.25

# External monitor ABOVE laptop (stacked vertically)
# monitor=eDP-1,preferred,0x1080,1.25
# monitor=HDMI-A-1,preferred,0x0,1.25

# External monitor BELOW laptop (stacked vertically)
# monitor=HDMI-A-1,preferred,0x1080,1.25
# monitor=eDP-1,preferred,0x0,1.25

# Different scaling per monitor example
# monitor=HDMI-A-1,preferred,0x0,1
# monitor=eDP-1,preferred,1920x0,1.25

# Mirror displays (same content on both screens)
# monitor=eDP-1,preferred,0x0,1.25,mirror,HDMI-A-1
# monitor=HDMI-A-1,preferred,0x0,1.25,mirror,eDP-1

# Disable laptop screen when external connected
# monitor=eDP-1,disable
# monitor=HDMI-A-1,preferred,0x0,1.25

# ------------------------------------------------------------
# ACTIVE CONFIGURATION
# ------------------------------------------------------------

# Environment variable for GDK scaling (matches both monitors)
env = GDK_SCALE,1.25

# External monitor (HDMI) - positioned on the LEFT
monitor=HDMI-A-1,preferred,0x0,1.25

# Laptop screen (eDP-1) - positioned on the RIGHT
monitor=eDP-1,preferred,1536x0,1.25
EOF
echo "   ✅ Monitors config restored"

# --------------------------------------------
# 3. GAPS CONFIG (No outer gaps)
# --------------------------------------------
echo "[3/8] Restoring gaps config (gaps_out=0, gaps_in=4)..."
cat > ~/.config/hypr/looknfeel.conf << 'EOF'
# Change the default Omarchy look'n'feel

# https://wiki.hyprland.org/Configuring/Variables/#general
general {
    # No gaps at screen edges (removes gap between bar and windows)
    gaps_out = 0
    # Keep inner gaps between windows (change to 0 if you want none)
    gaps_in = 4
    # border_size = 0

    # Change to niri-like side-scrolling layout
    # layout = scrolling
}

# https://wiki.hyprland.org/Configuring/Variables/#decoration
decoration {
    # Use round window corners
    # rounding = 8

    # Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed)
    # dim_inactive = true
    # dim_strength = 0.15
}

# https://wiki.hyprland.org/Configuring/Variables/#animations
animations {
    # Disable all animations
    # enabled = no
}

# https://wiki.hypr.land/Configuring/Variables/#layout
layout {
    # Avoid overly wide single-window layouts on wide screens
    # single_window_aspect_ratio = 1 1
}
EOF
echo "   ✅ Gaps config restored"

# --------------------------------------------
# 4. BINDINGS CONFIG (All Shortcuts)
# --------------------------------------------
echo "[4/8] Restoring keyboard bindings..."
cat > ~/.config/hypr/bindings.conf << 'EOF'
# Application bindings
bindd = SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"
bindd = SUPER SHIFT, RETURN, Browser, exec, omarchy-launch-browser
bindd = SUPER SHIFT, F, File manager, exec, uwsm-app -- nautilus --new-window
bindd = SUPER ALT SHIFT, F, File manager (cwd), exec, uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"
bindd = SUPER SHIFT, B, Browser, exec, omarchy-launch-browser
bindd = SUPER SHIFT ALT, B, Browser (private), exec, omarchy-launch-browser --private
bindd = SUPER SHIFT, N, Editor, exec, omarchy-launch-editor

# Add extra bindings
# bindd = SUPER SHIFT, A, ChatGPT, exec, omarchy-launch-webapp "https://chatgpt.com"
# bindd = SUPER SHIFT, R, exec, alacritty -e ssh your-server

# Overwrite existing bindings, like putting Omarchy Menu on Super + Space
unbind = SUPER, SPACE
bindd = SUPER, SPACE, Omarchy menu, exec, omarchy-menu

# Window Management
bindd = SUPER, Q, Kill window, killactive
bindd = SUPER, M, Fullscreen, fullscreen
bindd = SUPER, T, Toggle split, togglesplit
bindd = SUPER, S, Swap windows, exec, hyprctl dispatch swapnext

# App Launcher
bindd = SUPER, D, App launcher, exec, omarchy-launch-walker

# Move focus to other monitor
bindd = SUPER, period, Focus next monitor, exec, hyprctl dispatch focusmonitor +1
bindd = SUPER, comma, Focus previous monitor, exec, hyprctl dispatch focusmonitor -1

# Move window to other monitor
bindd = SUPER SHIFT, period, Move window to next monitor, movewindow, mon:+
bindd = SUPER SHIFT, comma, Move window to previous monitor, movewindow, mon:-

# Screenshots
bindd = , Print, Screenshot area (copy), exec, grimblast --notify copy area
bindd = SHIFT, Print, Screenshot area (save), exec, grimblast save area
bindd = SUPER, Print, Screenshot screen, exec, grimblast copy output
bindd = SUPER SHIFT, S, Screenshot area, exec, grimblast --notify copy area

# System
bindd = SUPER SHIFT, Q, Exit Hyprland, exec, hyprctl dispatch exit
bindd = SUPER SHIFT, R, Reload config, exec, hyprctl reload
bindd = SUPER, L, Lock screen, exec, loginctl lock-session

# Workspace Navigation
bindd = SUPER, 1, Workspace 1, workspace, 1
bindd = SUPER, 2, Workspace 2, workspace, 2
bindd = SUPER, 3, Workspace 3, workspace, 3
bindd = SUPER, 4, Workspace 4, workspace, 4
bindd = SUPER, 5, Workspace 5, workspace, 5
bindd = SUPER, 6, Workspace 6, workspace, 6
bindd = SUPER, 7, Workspace 7, workspace, 7
bindd = SUPER, 8, Workspace 8, workspace, 8
bindd = SUPER, 9, Workspace 9, workspace, 9
bindd = SUPER, 0, Workspace 10, workspace, 10

# Move windows to workspaces
bindd = SUPER SHIFT, 1, Move to workspace 1, movetoworkspace, 1
bindd = SUPER SHIFT, 2, Move to workspace 2, movetoworkspace, 2
bindd = SUPER SHIFT, 3, Move to workspace 3, movetoworkspace, 3
bindd = SUPER SHIFT, 4, Move to workspace 4, movetoworkspace, 4
bindd = SUPER SHIFT, 5, Move to workspace 5, movetoworkspace, 5
bindd = SUPER SHIFT, 6, Move to workspace 6, movetoworkspace, 6
bindd = SUPER SHIFT, 7, Move to workspace 7, movetoworkspace, 7
bindd = SUPER SHIFT, 8, Move to workspace 8, movetoworkspace, 8
bindd = SUPER SHIFT, 9, Move to workspace 9, movetoworkspace, 9
bindd = SUPER SHIFT, 0, Move to workspace 10, movetoworkspace, 10

# Focus with arrow keys
bindd = SUPER, left, Focus left, movefocus, l
bindd = SUPER, right, Focus right, movefocus, r
bindd = SUPER, up, Focus up, movefocus, u
bindd = SUPER, down, Focus down, movefocus, d

# Move windows with arrow keys
bindd = SUPER SHIFT, left, Move window left, movewindow, l
bindd = SUPER SHIFT, right, Move window right, movewindow, r
bindd = SUPER SHIFT, up, Move window up, movewindow, u
bindd = SUPER SHIFT, down, Move window down, movewindow, d

# Unbind Super+W
unbind = SUPER, W

# Minimize to workspace 10
bindd = SUPER, H, Minimize window, movetoworkspacesilent, 10
bindd = SUPER SHIFT, H, Restore window, exec, ~/.config/hypr/scripts/restore-window.sh

# True fullscreen
unbind = SUPER SHIFT, BackSpace
bindd = SUPER SHIFT, BackSpace, True fullscreen, fullscreen
EOF
echo "   ✅ Bindings restored"

# --------------------------------------------
# 5. HYPRLAND MAIN CONFIG (Fullscreen)
# --------------------------------------------
echo "[5/8] Adding fullscreen=1 to hyprland.conf..."
if ! grep -q "fullscreen = 1" ~/.config/hypr/hyprland.conf 2>/dev/null; then
    echo "" >> ~/.config/hypr/hyprland.conf
    echo "# True fullscreen - window takes entire screen" >> ~/.config/hypr/hyprland.conf
    echo "fullscreen = 1" >> ~/.config/hypr/hyprland.conf
fi
echo "   ✅ Fullscreen config added"

# --------------------------------------------
# 6. BASHRC (Fastfetch on terminal open)
# --------------------------------------------
echo "[6/8] Restoring .bashrc..."
if ! grep -q "fastfetch" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# Run fastfetch on terminal open" >> ~/.bashrc
    echo "fastfetch" >> ~/.bashrc
fi
echo "   ✅ Bashrc restored"

# --------------------------------------------
# 7. FASTFETCH CONFIG (Horizontal Layout)
# --------------------------------------------
echo "[7/8] Restoring fastfetch config..."
mkdir -p ~/.config/fastfetch
cat > ~/.config/fastfetch/config.jsonc << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "none",
    "source": "/home/ashish/Pictures/Terminal/pngegg.png",
    "color": { "1": "green" },
    "padding": {
      "top": 2,
      "right": 6,
      "left": 2
    }
  },
  "modules": [
    "break",
    {
      "type": "custom",
      "format": "\u001b[90m┌──────────────────────Hardware──────────────────────┐"
    },
    {
      "type": "host",
      "key": " PC",
      "keyColor": "green"
    },
    {
      "type": "cpu",
      "key": "│ ├",
      "showPeCoreCount": true,
      "keyColor": "green"
    },
    {
      "type": "gpu",
      "key": "│ ├",
      "detectionMethod": "pci",
      "keyColor": "green"
    },
    {
      "type": "display",
      "key": "│ ├󱄄",
      "keyColor": "green"
    },
    {
      "type": "disk",
      "key": "│ ├󰋊",
      "keyColor": "green"
    },
    {
      "type": "memory",
      "key": "│ ├",
      "keyColor": "green"
    },
    {
      "type": "swap",
      "key": "└ └󰓡 ",
      "keyColor": "green"
    },
    {
      "type": "custom",
      "format": "\u001b[90m└────────────────────────────────────────────────────┘"
    },
    "break",
    {
      "type": "custom",
      "format": "\u001b[90m┌──────────────────────Software──────────────────────┐"
    },
    {
      "type": "command",
      "key": "\ue900 OS",
      "keyColor": "blue",
      "text": "version=$(omarchy-version); echo \"Omarchy $version\""
    },
    {
      "type": "command",
      "key": "│ ├󰘬",
      "keyColor": "blue",
      "text": "branch=$(omarchy-version-branch); echo \"$branch\""
    },
    {
      "type": "command",
      "key": "│ ├󰔫",
      "keyColor": "blue",
      "text": "channel=$(omarchy-version-channel); echo \"$channel\""
    },
    {
      "type": "kernel",
      "key": "│ ├",
      "keyColor": "blue"
    },
    {
      "type": "wm",
      "key": "│ ├",
      "keyColor": "blue"
    },
    {
      "type": "de",
      "key": " DE",
      "keyColor": "blue"
    },
    {
      "type": "terminal",
      "key": "│ ├",
      "keyColor": "blue"
    },
    {
      "type": "packages",
      "key": "│ ├󰏖",
      "keyColor": "blue"
    },
    {
      "type": "wmtheme",
      "key": "│ ├󰉼",
      "keyColor": "blue"
    },
    {
      "type": "command",
      "key": "│ ├󰸌",
      "keyColor": "blue",
      "text": "theme=$(omarchy-theme-current); echo -e \"$theme \\e[38m●\\e[37m●\\e[36m●\\e[35m●\\e[34m●\\e[33m●\\e[32m●\\e[31m●\""
    },
    {
      "type": "terminalfont",
      "key": "└ └",
      "keyColor": "blue"
    },
    {
      "type": "custom",
      "format": "\u001b[90m└────────────────────────────────────────────────────┘"
    },
    "break",
    {
      "type": "custom",
      "format": "\u001b[90m┌────────────────Age / Uptime / Update───────────────┐"
    },
    {
      "type": "command",
      "key": "󱦟 OS Age",
      "keyColor": "magenta",
      "text": "echo $(( ($(date +%s) - $(stat -c %W /)) / 86400 )) days"
    },
    {
      "type": "uptime",
      "key": "󱫐 Uptime",
      "keyColor": "magenta"
    },
    {
      "type": "command",
      "key": " Update",
      "keyColor": "magenta",
      "text": "updated=$(omarchy-version-pkgs); echo \"$updated\""
    },
    {
      "type": "custom",
      "format": "\u001b[90m└────────────────────────────────────────────────────┘"
    },
    "break"
  ]
}
EOF
echo "   ✅ Fastfetch config restored"

# --------------------------------------------
# 8. INSTALL REQUIRED PACKAGES
# --------------------------------------------
echo "[8/8] Installing required packages..."
sudo pacman -S --noconfirm alacritty grimblast fastfetch waybar hyprland 2>/dev/null
echo "   ✅ Packages installed"

# --------------------------------------------
# RELOAD HYPRLAND
# --------------------------------------------
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   ✅ RESTORE COMPLETE!                   ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Now run: hyprctl reload"
echo "Or press: SUPER + SHIFT + R"
echo ""
hyprctl reload 2>/dev/null && echo "✅ Hyprland reloaded!" || echo "⚠️  Run 'hyprctl reload' manually"
