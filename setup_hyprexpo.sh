#!/bin/bash

# ==============================================================================
# Script: setup_hyprexpo.sh
# Description: Automates the installation and configuration of the 
#              Hyprexpo (Workspace Overview) plugin for Hyprland.
# ==============================================================================

echo "Starting Hyprexpo setup..."

# 1. Update Hyprland Plugin Manager and Add Official Repo
echo "[1/4] Setting up hyprpm and downloading plugins..."
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo

# 2. Configure hyprland.conf
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"
echo "[2/4] Configuring $HYPR_CONF..."

if ! grep -q "hyprexpo {" "$HYPR_CONF"; then
    cat <<EOF >> "$HYPR_CONF"

# Hyprexpo Plugin Configuration
plugin {
    hyprexpo {
        columns = 2
        gap_size = 5
        bg_col = rgb(111111)
    }
}
EOF
    echo "  -> Added hyprexpo config."
else
    echo "  -> Config already exists. Skipping."
fi

# 3. Configure bindings.conf
BINDINGS_CONF="$HOME/.config/hypr/bindings.conf"
echo "[3/4] Configuring $BINDINGS_CONF..."

if ! grep -q "hyprexpo:expo" "$BINDINGS_CONF"; then
    echo -e "\n# Hyprexpo / Workspace Overview\nbind = SUPER, TAB, hyprexpo:expo, toggle" >> "$BINDINGS_CONF"
    echo "  -> Added SUPER + TAB keybind."
else
    echo "  -> Keybind already exists. Skipping."
fi

# 4. Reload Hyprland to apply changes
echo "[4/4] Reloading Hyprland..."
hyprctl reload

echo "=============================================================================="
echo "Setup Complete! Press SUPER + TAB to view your workspaces."
echo "=============================================================================="
