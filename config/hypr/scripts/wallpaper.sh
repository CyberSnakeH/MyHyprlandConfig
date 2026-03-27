#!/usr/bin/env bash
# ============================================================================
# Wallpaper Management with swww
# Part of: Tokyo Night Hyprland Rice
# Author:  CyberSnake
# Date:    2026-03-26
#
# Manages wallpapers using the swww daemon with smooth animated transitions.
# Supports initialization (restore last wallpaper), cycling to a random next
# wallpaper, and setting a specific image. Also maintains a symlink for
# hyprlock background integration.
#
# Usage: wallpaper.sh [init|next|set <path>]
# Dependencies: swww, hyprctl, coreutils (find, shuf, ln)
# ============================================================================

set -euo pipefail

# -- Configuration --
WALL_DIR="${HOME}/Pictures/Wallpapers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
CACHE_FILE="${CACHE_DIR}/current_wallpaper"

# -- Ensure cache directory exists --
mkdir -p "$CACHE_DIR"

# -- Apply a wallpaper with animated transition --
apply() {
    local wallpaper="$1"

    if [[ ! -f "$wallpaper" ]]; then
        echo "Error: wallpaper not found: $wallpaper" >&2
        return 1
    fi

    # Use cursor position as transition origin for a natural feel
    local cursor_pos
    cursor_pos=$(hyprctl cursorpos 2>/dev/null || echo "960 540")

    swww img "$wallpaper" \
        --transition-type grow \
        --transition-pos "$cursor_pos" \
        --transition-duration 2 \
        --transition-fps 60

    # Persist current wallpaper path for session restore
    echo "$wallpaper" > "$CACHE_FILE"

    # Maintain symlink for hyprlock background reference
    ln -sf "$wallpaper" "${WALL_DIR}/wallpaper.png"
}

# -- Initialize: start daemon and restore last wallpaper --
init() {
    # Start swww daemon if not already running
    if ! pgrep -x swww-daemon > /dev/null; then
        swww-daemon &
        sleep 1
    fi

    # Restore the last used wallpaper, or pick a random one
    if [[ -f "$CACHE_FILE" ]] && [[ -f "$(cat "$CACHE_FILE")" ]]; then
        apply "$(cat "$CACHE_FILE")"
    else
        next
    fi
}

# -- Cycle to a random wallpaper from the collection --
next() {
    if [[ ! -d "$WALL_DIR" ]]; then
        mkdir -p "$WALL_DIR"
        echo "Error: no wallpapers found in $WALL_DIR" >&2
        return 1
    fi

    local wallpaper
    wallpaper=$(find "$WALL_DIR" -maxdepth 1 -type f \
        \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) \
        ! -name "wallpaper.png" \
        | shuf -n 1)

    if [[ -z "$wallpaper" ]]; then
        echo "Error: no wallpaper images found in $WALL_DIR" >&2
        return 1
    fi

    apply "$wallpaper"
}

# -- Main dispatch --
case "${1:-init}" in
    init) init ;;
    next) next ;;
    set)
        if [[ -z "${2:-}" ]]; then
            echo "Usage: $(basename "$0") set <path_to_image>" >&2
            exit 1
        fi
        apply "$2"
        ;;
    *)
        echo "Usage: $(basename "$0") {init|next|set <path>}" >&2
        exit 1
        ;;
esac
