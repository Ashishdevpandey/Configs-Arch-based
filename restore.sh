#!/bin/bash
# ==============================================================================
# Script: restore.sh / Omarchy-Restore.sh
# Description: One-shot automated restoration script for Omarchy Linux configuration.
#              Re-installs packages, restores user configs, setups SDDM/Plymouth,
#              configures Limine bootloader, and enables the Hyprexpo plugin.
# ==============================================================================

set -e

# ANSI Color Codes for beautiful output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}      🚀 OMACHRY COMPLETE SYSTEM RESTORE SCRIPT      ${NC}"
echo -e "${BLUE}====================================================${NC}"
echo ""

# 1. Install System Dependencies
echo -e "${YELLOW}[1/8] Installing system dependencies...${NC}"
DEPENDENCIES=(
    alacritty
    grimblast-git
    fastfetch
    waybar
    hyprland
    hyprmode
    mako
    swaybg
    swaync
    swayosd-git
    playerctl
    imagemagick
    plymouth
    python-pillow
    rsync
    cava
)

# Detect package manager and install (Omarchy is Arch-based, so pacman/yay)
if command -v yay &>/dev/null; then
    echo "Installing packages via yay..."
    yay -S --noconfirm "${DEPENDENCIES[@]}" || true
elif command -v pacman &>/dev/null; then
    echo "Installing packages via pacman..."
    sudo pacman -S --noconfirm "${DEPENDENCIES[@]}" || true
else
    echo -e "${RED}Error: Neither pacman nor yay found! Please install packages manually.${NC}"
fi

# 2. Recreate System Directories
echo -e "${YELLOW}[2/8] Creating directory structure...${NC}"
mkdir -p ~/.config/hypr
mkdir -p ~/.config/omarchy
mkdir -p ~/scripts
mkdir -p ~/Pictures/Archive/centered
mkdir -p ~/Pictures/Archive/Women

# 3. Restore Wallpaper Files and Fix Symlinks
echo -e "${YELLOW}[3/8] Restoring wallpapers & active background assets...${NC}"
if [ -d wallpapers ]; then
    echo "Restoring wallpaper image files to target directories..."
    cp wallpapers/active_wallpaper.jpg ~/Pictures/Archive/centered/a_woman_with_long_hair_and_a_nose_ring.jpg || true
    cp wallpapers/HDMI-A-1 ~/Pictures/Archive/Women/1.jpg || true
    cp wallpapers/eDP-1 ~/Pictures/Archive/Women/1.jpg || true
else
    echo "No wallpapers directory found in repo. Skipping wallpaper restoration."
fi

# 4. Copy Configurations to Destination
echo -e "${YELLOW}[4/8] Copying user configurations...${NC}"
if [ -d hypr ]; then
    echo "Restoring Hyprland configurations..."
    rsync -av --exclude='*.so' --exclude='*.so.bak' hypr/ ~/.config/hypr/
fi

if [ -d scripts ]; then
    echo "Restoring custom user scripts..."
    rsync -av scripts/ ~/scripts/
    chmod +x ~/scripts/* || true
fi

if [ -d omarchy ]; then
    echo "Restoring Omarchy configurations, themes, and branding..."
    rsync -av --exclude='repo-clone' omarchy/ ~/.config/omarchy/
fi

# 5. SDDM Theme Restoration
echo -e "${YELLOW}[5/8] Configuring SDDM Login Theme...${NC}"
if [ -f sddm/sddm.conf ]; then
    echo "Restoring /etc/sddm.conf..."
    sudo cp sddm/sddm.conf /etc/sddm.conf
fi

# Make sure SDDM theme assets are sync'd
if [ -f ~/.config/omarchy/branding/plymouth_logo.png ] && [ -d /usr/share/sddm/themes/omarchy ]; then
    echo "Syncing SDDM logo.png..."
    sudo cp ~/.config/omarchy/branding/plymouth_logo.png /usr/share/sddm/themes/omarchy/logo.png || true
fi

# 6. Plymouth Theme Restoration
echo -e "${YELLOW}[6/8] Configuring Plymouth Boot Theme...${NC}"
if [ -f plymouth/plymouthd.conf ]; then
    echo "Restoring /etc/plymouth/plymouthd.conf..."
    sudo cp plymouth/plymouthd.conf /etc/plymouth/plymouthd.conf
fi

# Apply Plymouth logo and color configurations
PLYMOUTH_SET_SCRIPT="/home/ashish/.local/share/omarchy/bin/omarchy-plymouth-set"
if [ -f "$PLYMOUTH_SET_SCRIPT" ]; then
    echo "Applying Plymouth configurations using omarchy-plymouth-set..."
    # Background: Black (#000000), Accent: Tokyo Night Green (#9ece6a)
    sudo "$PLYMOUTH_SET_SCRIPT" "#000000" "#9ece6a" ~/.config/omarchy/branding/plymouth_logo.png || true
else
    echo "omarchy-plymouth-set utility not found. Rebuilding initramfs directly..."
    if command -v limine-mkinitcpio &>/dev/null; then
        sudo limine-mkinitcpio || true
    else
        sudo mkinitcpio -P || true
    fi
fi

# 7. Limine Bootloader Restoration
echo -e "${YELLOW}[7/8] Configuring Limine Bootloader...${NC}"
if [ -f boot/limine.conf ] && [ -d /boot ]; then
    echo "Restoring /boot/limine.conf..."
    sudo cp boot/limine.conf /boot/limine.conf
    if command -v limine-update &>/dev/null; then
        sudo limine-update || true
    fi
fi

# 8. Post-Restore System Triggers (Hyprexpo & Bashrc)
echo -e "${YELLOW}[8/8] Running post-restore triggers...${NC}"
# Add fastfetch to bashrc if not present
grep -q "fastfetch" ~/.bashrc || echo "fastfetch" >> ~/.bashrc

# Compile and enable Hyprexpo plugin
if [ -f ~/scripts/setup_hyprexpo.sh ]; then
    echo "Compiling and loading Hyprexpo workspace overview plugin..."
    bash ~/scripts/setup_hyprexpo.sh || true
fi

echo ""
echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}      ✅ OMACHRY RESTORATION COMPLETE!              ${NC}"
echo -e "${GREEN}      Please restart your system to apply changes.  ${NC}"
echo -e "${BLUE}====================================================${NC}"

# Reload Hyprland config if running
if pgrep -x Hyprland &>/dev/null; then
    hyprctl reload || true
fi
