#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║   opacity.sh — Window Opacity Selector via Rofi                    ║
# ║   Tokyo Night Rice — Hyprland                                      ║
# ║   Author: CyberSnake                                                     ║
# ║   Date:   2026-03-26                                               ║
# ║                                                                     ║
# ║   Presents a list of opacity presets in Rofi. The selected value   ║
# ║   is applied globally to all windows via hyprctl. Inactive windows ║
# ║   automatically receive 0.10 less opacity than active ones.        ║
# ║                                                                     ║
# ║   Dependencies: rofi-wayland, hyprctl, bc, libnotify              ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# -- Configuration --
ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/tokyo-night.rasi"
INACTIVE_OFFSET="0.10"

# -- Opacity presets (value + description) --
options="1.0  Opaque (no transparency)
0.95  Subtle
0.90  Light (default)
0.85  Medium
0.80  Visible
0.75  Heavy
0.70  Very transparent
0.60  Ultra transparent"

# -- Present picker in Rofi --
selected=$(echo "$options" | rofi -dmenu \
    -p "  Opacity" \
    -theme "$ROFI_THEME" \
    -i) || exit 0

[[ -z "$selected" ]] && exit 0

# -- Extract the numeric opacity value (first field) --
opacity=$(echo "$selected" | awk '{print $1}')

[[ "$opacity" =~ ^(0([.][0-9]+)?|1([.]0+)?)$ ]] || exit 1

# -- Calculate inactive opacity (clamped to minimum 0.10) --
inactive=$(echo "$opacity - $INACTIVE_OFFSET" | bc)

# Clamp: if inactive would be <= 0, set a reasonable floor
if (( $(echo "$inactive <= 0" | bc -l) )); then
    inactive="0.10"
fi

# -- Apply to Hyprland decoration settings --
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" decoration:active_opacity "$opacity" 2>/dev/null
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" decoration:inactive_opacity "$inactive" 2>/dev/null

# -- Notify the user --
notify-send -t 2000 "  Opacity" "Active: ${opacity} | Inactive: ${inactive}"
