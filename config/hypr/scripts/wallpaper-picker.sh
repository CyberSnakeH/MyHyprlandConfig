#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║   wallpaper-picker.sh — Browse & apply wallpapers via Rofi + swww  ║
# ║   Tokyo Night Rice — Hyprland                                      ║
# ║   Author: CyberSnake                                                     ║
# ║   Date:   2026-03-26                                               ║
# ║                                                                     ║
# ║   Recursively scans ~/Pictures/Wallpapers/ for images, presents    ║
# ║   them in a Rofi menu with folder context, and applies the         ║
# ║   selected wallpaper via the wallpaper.sh set command.             ║
# ║                                                                     ║
# ║   Dependencies: rofi-wayland, swww, libnotify, coreutils (find)   ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# -- Configuration --
WALL_DIR="${HOME}/Pictures/Wallpapers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-thumbs"
ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/tokyo-night.rasi"
WALLPAPER_SCRIPT="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/wallpaper.sh"

mkdir -p "$CACHE_DIR"

# -- Discover all wallpaper images recursively --
mapfile -t walls < <(find "$WALL_DIR" -type f \
    \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) \
    ! -name "wallpaper.png" \
    | sort)

if [[ ${#walls[@]} -eq 0 ]]; then
    notify-send -u normal "Wallpaper Picker" "No wallpapers found in $WALL_DIR"
    exit 1
fi

# -- Build Rofi menu entries with folder context --
entries=""
for wall in "${walls[@]}"; do
    parent=$(basename "$(dirname "$wall")")
    name=$(basename "$wall")

    # Show [subfolder] prefix only for images in subdirectories
    if [[ "$parent" == "Wallpapers" ]]; then
        entries+="${name}\0icon\x1f${wall}\n"
    else
        entries+="[${parent}] ${name}\0icon\x1f${wall}\n"
    fi
done

# -- Present picker in Rofi --
selected=$(echo -e "$entries" | rofi -dmenu \
    -p "  Wallpaper" \
    -theme "$ROFI_THEME" \
    -i \
    -show-icons \
    -selected-row 0) || exit 0

[[ -z "$selected" ]] && exit 0

# -- Extract clean filename (strip [folder] prefix if present) --
clean_name="${selected#\[*\] }"

# -- Locate and apply the matching wallpaper --
for wall in "${walls[@]}"; do
    if [[ "$(basename "$wall")" == "$clean_name" ]]; then
        "$WALLPAPER_SCRIPT" set "$wall"
        notify-send -t 2000 "  Wallpaper" "Applied: $(basename "$wall")"
        exit 0
    fi
done

# If we reach here, no match was found (should not happen)
notify-send -u critical "Wallpaper Picker" "Could not find file: $clean_name"
exit 1
