#!/usr/bin/env bash
# ============================================================================
# Volume Control with Notification Overlay
# Part of: Tokyo Night Hyprland Rice
# Author:  CyberSnake
# Date:    2026-03-26
#
# Provides volume up/down/mute actions with visual notification feedback
# via dunst/mako. Uses synchronous hints so notifications replace in-place.
#
# Usage: volume.sh {up|down|mute}
# Dependencies: pamixer, libnotify (notify-send)
# ============================================================================

set -euo pipefail

# -- Validate dependencies --
for cmd in pamixer notify-send; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is not installed" >&2
        exit 1
    fi
done

# -- Handle volume actions --
case "${1:-}" in
    up)
        pamixer -i 5
        VOL=$(pamixer --get-volume)
        notify-send -h string:x-canonical-private-synchronous:volume \
            -h "int:value:$VOL" -t 800 \
            "  Volume" "$VOL%"
        ;;
    down)
        pamixer -d 5
        VOL=$(pamixer --get-volume)
        notify-send -h string:x-canonical-private-synchronous:volume \
            -h "int:value:$VOL" -t 800 \
            "  Volume" "$VOL%"
        ;;
    mute)
        pamixer -t
        MUTED=$(pamixer --get-mute)
        if [[ "$MUTED" == "true" ]]; then
            notify-send -h string:x-canonical-private-synchronous:volume \
                -t 1200 "  Muted" "Audio muted"
        else
            VOL=$(pamixer --get-volume)
            notify-send -h string:x-canonical-private-synchronous:volume \
                -h "int:value:$VOL" -t 800 "  Volume" "$VOL%"
        fi
        ;;
    *)
        echo "Usage: $(basename "$0") {up|down|mute}" >&2
        exit 1
        ;;
esac
