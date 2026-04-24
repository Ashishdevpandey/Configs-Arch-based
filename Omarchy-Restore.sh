cat > ~/fix-everything.sh << 'SCRIPT_END'
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
bindd = SUPER, ESCAPE, Power off, exec, systemctl poweroff
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
SCRIPT_END

chmod +x ~/fix-everything.sh
