#!/bin/bash

if omarchy-hw-external-monitors; then
    # External monitor present, use omarchy's tool to disable internal monitor
    omarchy-hyprland-monitor-internal off
else
    # No external monitor, suspend the system
    systemctl suspend
fi
