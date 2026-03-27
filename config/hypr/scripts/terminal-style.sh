#!/usr/bin/env bash
# ============================================================================
# Terminal Style Switcher -- apply visual presets to Kitty
# Swaps kitty-style.conf with the selected style file and reloads.
# Also adjusts Hyprland opacity rules for the terminal.
#
# Dependencies: rofi-wayland, hyprctl, libnotify, kitty
# Author: CyberSnake
# Date: 2026-03-26
# ============================================================================

set -euo pipefail

ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/tokyo-night.rasi"
STYLES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty/styles"
ACTIVE_STYLE="${XDG_CONFIG_HOME:-$HOME/.config}/kitty/kitty-style.conf"

# Verify styles directory exists
if [[ ! -d "$STYLES_DIR" ]]; then
    notify-send -u critical -t 3000 "  Terminal" "Styles directory not found: $STYLES_DIR"
    exit 1
fi

# Build menu from available style files
entries=""
declare -A style_files
for f in "$STYLES_DIR"/*.conf; do
    [[ ! -f "$f" ]] && continue
    name=$(basename "$f" .conf)
    # Read the first comment line for description
    desc=$(head -1 "$f" | sed 's/^# Style: //')
    display="${name^}"
    entries+="${display}  ${desc}\n"
    style_files["${display}"]="$f"
done

if [[ -z "$entries" ]]; then
    notify-send -u critical -t 3000 "  Terminal" "No style files found in $STYLES_DIR"
    exit 1
fi

selected=$(echo -e "$entries" | rofi -dmenu \
    -p "  Terminal Style" \
    -theme "$ROFI_THEME" \
    -i) || exit 0

[[ -z "$selected" ]] && exit 0

# Extract style name (first word)
key=$(echo "$selected" | awk '{print $1}')

src="${style_files[$key]:-}"
if [[ -z "$src" ]]; then
    notify-send -u critical -t 3000 "  Terminal" "Style not found: $key"
    exit 1
fi

# Apply: copy style and reload ALL running Kitty instances
cp "$src" "$ACTIVE_STYLE"
for sock in /tmp/kitty-socket-*; do
    [[ -S "$sock" ]] && kitty @ --to "unix:$sock" load-config 2>/dev/null || true
done

# Adjust Hyprland opacity based on style
case "${key,,}" in
    transparent) hyprctl keyword "windowrulev2 opacity 0.75 0.70,class:^(kitty)$" 2>/dev/null ;;
    opaque)      hyprctl keyword "windowrulev2 opacity 1.0 1.0,class:^(kitty)$" 2>/dev/null ;;
    *)           hyprctl keyword "windowrulev2 opacity 0.90 0.85,class:^(kitty)$" 2>/dev/null ;;
esac

notify-send -t 2000 "  Terminal" "Style: $key"
