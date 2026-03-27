#!/usr/bin/env bash
# ============================================================================
# Multi-mode Screenshot Utility for Hyprland
# Part of: Tokyo Night Hyprland Rice
# Author:  CyberSnake
# Date:    2026-03-26
#
# Supports four capture modes:
#   full   - Entire screen
#   area   - Interactive region selection -> edit with swappy
#   window - Currently focused window (via hyprctl)
#   clip   - Region selection copied to clipboard (no file saved)
#
# Usage: screenshot.sh {full|area|window|clip}
# Dependencies: grim, slurp, swappy, wl-clipboard (wl-copy), jq,
#               hyprctl, libnotify (notify-send)
# ============================================================================

set -euo pipefail

# -- Screenshot save directory --
SAVEDIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
mkdir -p "$SAVEDIR"

# -- Generate timestamped filename --
FILE="$SAVEDIR/$(date +%Y%m%d_%H%M%S).png"

# -- Handle capture modes --
case "${1:-}" in
    full)
        grim "$FILE"
        notify-send -i "$FILE" "  Screenshot" "Full screen saved"
        ;;
    area)
        GEOMETRY=$(slurp -d) || exit 0
        grim -g "$GEOMETRY" "$FILE"
        swappy -f "$FILE" -o "$FILE"
        notify-send -i "$FILE" "  Screenshot" "Area saved"
        ;;
    window)
        GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        if [[ "$GEOM" == "null,null nullxnull" ]] || [[ -z "$GEOM" ]]; then
            notify-send "  Screenshot" "No active window found"
            exit 1
        fi
        grim -g "$GEOM" "$FILE"
        notify-send -i "$FILE" "  Screenshot" "Window saved"
        ;;
    clip)
        GEOMETRY=$(slurp -d) || exit 0
        grim -g "$GEOMETRY" - | wl-copy
        notify-send "  Screenshot" "Area copied to clipboard"
        ;;
    *)
        echo "Usage: $(basename "$0") {full|area|window|clip}" >&2
        exit 1
        ;;
esac
