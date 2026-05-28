# Ashish's Omarchy System Configurations

This repository contains the complete, reproducible backup of your personalized **Omarchy** Linux environment (Arch Linux + Hyprland), including custom scripting, bootloaders, themes, wallpapers, and Plymouth boot splash animations.

---

## 📁 Repository Structure

| Directory | Description |
|---|---|
| [`hypr/`](file:///home/ashish/.config/omarchy/repo-clone/hypr) | Full Hyprland settings, keybindings, window rules, OSDs, idle handlers, and lid switches. |
| [`scripts/`](file:///home/ashish/.config/omarchy/repo-clone/scripts) | Custom system utilities including the Python GUI Wallpaper Picker and setup scripts. |
| [`omarchy/`](file:///home/ashish/.config/omarchy/repo-clone/omarchy) | Branding text assets (ASCII arts), config parameters, and the custom `harbordark` theme. |
| [`boot/`](file:///home/ashish/.config/omarchy/repo-clone/boot) | Backup of `/boot/limine.conf` containing boot interface colors and Snapper snapshots sync. |
| [`plymouth/`](file:///home/ashish/.config/omarchy/repo-clone/plymouth) | Core Plymouth configuration settings. |
| [`sddm/`](file:///home/ashish/.config/omarchy/repo-clone/sddm) | SDDM login manager theme details. |
| [`wallpapers/`](file:///home/ashish/.config/omarchy/repo-clone/wallpapers) | Copies of the active desktop wallpapers and dual monitor backgrounds. |

---

## 🚀 Restoration Guide (How to Rebuild System)

To restore this entire configuration on a fresh installation of Omarchy Linux:

1. **Clone this repository** to your local system:
   ```bash
   git clone git@github.com:Ashishdevpandey/Configs-Arch-based.git ~/.config/omarchy/repo-clone
   ```

2. **Navigate to the repository** folder:
   ```bash
   cd ~/.config/omarchy/repo-clone
   ```

3. **Run the master restore script**:
   ```bash
   ./restore.sh
   ```
   *(Alternatively, you can run `./Omarchy-Restore.sh`)*

The script will automatically prompt for your `sudo` password to install system dependencies, copy system files to `/boot` and `/etc`, and rebuild the Plymouth initramfs boot splash.

---

## ⌨️ Primary Custom Keybindings

| Keybinding | Action |
|---|---|
| `SUPER + Enter` | Open Alacritty Terminal |
| `SUPER + Shift + Enter` | Open Zen Browser |
| `SUPER + Shift + F` | Open File Manager (Nautilus) |
| `SUPER + Space` | Open Omarchy Application/Command Menu |
| `SUPER + D` | Open App Launcher (Walker) |
| `SUPER + TAB` | Toggle Workspace Overview (Hyprexpo) |
| `SUPER + W` | Toggle Wallpaper Picker GUI |
| `SUPER + L` | Lock Screen immediately |
| `SUPER + Q` | Close active window |
| `SUPER + Escape` | Power off system |
| `Print` | Capture screenshot of an area to clipboard |
| `Shift + Print` | Capture screenshot of an area and save |
