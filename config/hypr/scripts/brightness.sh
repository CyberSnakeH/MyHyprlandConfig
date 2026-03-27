#!/usr/bin/env bash
# ============================================================================
# Brightness Control with Notification Overlay
# Part of: Tokyo Night Hyprland Rice
# Author:  CyberSnake
# Date:    2026-03-26
#
# Adjusts screen brightness in 5% increments and sends a progress-bar
# notification via dunst/mako. Uses synchronous hints for in-place updates.
#
# Usage: brightness.sh {up|down}
# Dependencies: brightnessctl, libnotify (notify-send)
# ============================================================================

set -euo pipefail

# -- Validate dependencies --
for cmd in brightnessctl notify-send; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is not installed" >&2
        exit 1
    fi
done

# -- Handle brightness actions --
case "${1:-}" in
    up)   brightnessctl set 5%+ -q ;;
    down) brightnessctl set 5%- -q ;;
    *)
        echo "Usage: $(basename "$0") {up|down}" >&2
        exit 1
        ;;
esac

# -- Send notification with current brightness level --
VAL=$(brightnessctl | grep -oP '\d+(?=%)' | tail -1)
notify-send -h string:x-canonical-private-synchronous:brightness \
    -h "int:value:$VAL" -t 700 \
    "  Brightness" "${VAL}%"
