# Ashish's Omarchy Config Backup

Personal configuration files for **Omarchy** (Arch Linux + Hyprland) setup.

> Migrated from KDE Plasma → now fully on **Omarchy + Hyprland**

---

## What's Inside

### `hypr/`
Custom Hyprland configuration files:

| File | Purpose |
|---|---|
| `hyprland.conf` | Main config — sources all others |
| `bindings.conf` | All keybindings (Win+Tab workspace overview, Win+W wallpaper picker, Win+N Antigravity AI, scratchpad, audio, media) |
| `autostart.conf` | Custom autostart (mpd, wallpaper restore, monitor listener) |
| `monitors.conf` | Dual monitor layout — HDMI-A-1 + eDP-1 @ 1.25 scale |
| `looknfeel.conf` | Gaps, borders |
| `input.conf` | Keyboard layout, touchpad natural scroll, repeat rate |
| `windows.conf` | Window rules — hyprmode float, scratchpad, Night Light |
| `hyprlock.conf` | Lock screen — custom input field with JetBrainsMono |
| `hypridle.conf` | Screensaver after 2.5min, lock after 5min |
| `lid-switch.conf` | Auto lid close/open detection |
| `dms/` | DMS-generated layout (gaps, rounding) |
| `scripts/` | workspace wallpaper, monitor listener, lid handler |

### `scripts/`
Custom user scripts:

| File | Purpose |
|---|---|
| `wallpaper_picker.py` | Full custom wallpaper picker GUI (Win+W) — per-workspace wallpapers |
| `toggle_wallpaper_picker.sh` | Toggle script for wallpaper picker |
| `apply_last_wallpaper.sh` | Restore last wallpaper on login |

### `omarchy/`
Omarchy-specific customizations:

| File | Purpose |
|---|---|
| `config.toml` | Default browser (Zen), webapp browser (Chrome) |
| `branding/screensaver.txt` | Custom ASHISH ASCII art for screensaver |
| `branding/about.txt` | Custom ASCII logo for about screen |
| `branding/plymouth_logo.png` | Custom Plymouth boot splash logo |
| `branding/limine-katana.png` | Custom Limine bootloader background wallpaper |
| `themes/harbordark/` | Custom harbordark Omarchy theme |

### `restore/`
Restore scripts:

| File | Purpose |
|---|---|
| `fix-everything.sh` | Master restore script — reapplies all configs |
| `Omarchy-Restore.sh` | Omarchy-specific restore |

---

## Key Keybindings (Custom)

| Keys | Action |
|---|---|
| `Win + Tab` | Workspace overview (hyprexpo) |
| `Win + W` | Wallpaper picker |
| `Win + N` | Antigravity AI |
| `Win + B` | Zen Browser |
| `Win + D` | App launcher (Walker) |
| `Win + Space` | Omarchy menu |
| `Win + `` ` | Scratchpad toggle |
| `Win + H` | Minimize to workspace 10 |
| `Win + L` | Lock screen |

---

## Quick Restore

```bash
git clone git@github.com:Ashishdevpandey/Configs-Arch-based.git
cd Configs-Arch-based
bash fix-everything.sh
```
