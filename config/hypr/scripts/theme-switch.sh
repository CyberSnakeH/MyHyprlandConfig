#!/usr/bin/env bash
# ============================================================================
# Theme Switcher for Hyprland Rice
# Part of: Hyprland Rice Theme System
# Author:  CyberSnake
# Date:    2026-03-26
#
# Applies a complete theme across all rice components in one shot:
#   - Hyprland (live via hyprctl eval — instant, no restart)
#   - Waybar (regenerate style.css with new color variables)
#   - Rofi (regenerate theme .rasi with color variables + base selectors)
#   - Kitty (live reload via remote control)
#   - Wallpaper (random pick from theme-specific directory)
#   - SwayNC (style reload)
#
# Usage:
#   theme-switch.sh menu           Show Rofi theme picker
#   theme-switch.sh <theme.conf>   Apply a specific theme file
#   theme-switch.sh                Re-apply the last used theme (from cache)
#
# Dependencies: hyprctl, rofi, kitty, awww, swaync-client, notify-send,
#               waybar, coreutils (find, shuf, sed)
# ============================================================================

set -euo pipefail

# -- Resolve paths --
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="${HOME}/.config/hypr/themes"
CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/current_theme"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# -- Helper: convert hex #RRGGBB to individual R G B decimal values --
hex_to_rgb() {
    local hex="${1#\#}"
    printf "%d %d %d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# -- Helper: convert hex #RRGGBB + alpha (0.00-1.00) to Rofi rgba() --
hex_to_rofi_rgba() {
    local hex="${1#\#}"
    local alpha="$2"
    printf "rgba ( %d, %d, %d, %s )" \
        "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}" "$alpha"
}

# ════════════════════════════════════════════════════════════════════════
# ROFI MENU MODE
# ════════════════════════════════════════════════════════════════════════

if [[ "${1:-}" == "menu" ]]; then
    # Build the list of available theme names
    themes=""
    declare -A theme_map

    for f in "$THEMES_DIR"/*.conf; do
        [[ -f "$f" ]] || continue
        # Extract THEME_NAME without sourcing (safer for menu building)
        name=$(sed -n 's/^THEME_NAME="\(.*\)"/\1/p' "$f")
        if [[ -n "$name" ]]; then
            themes+="${name}\n"
            theme_map["$name"]="$f"
        fi
    done

    # Present Rofi picker
    selected=$(echo -e "$themes" | sed '/^$/d' | rofi -dmenu \
        -p "  Theme" \
        -theme "${CONFIG_DIR}/rofi/themes/tokyo-night.rasi" \
        -i) || exit 0

    [[ -z "$selected" ]] && exit 0

    # Find and apply the matching theme file
    target="${theme_map[$selected]:-}"
    if [[ -n "$target" ]]; then
        exec "$0" "$target"
    else
        notify-send -t 3000 "  Theme Error" "No theme file found for: ${selected}" 2>/dev/null || true
        exit 1
    fi
fi

# ════════════════════════════════════════════════════════════════════════
# APPLY THEME
# ════════════════════════════════════════════════════════════════════════

THEME_FILE="${1:-}"

# Fall back to cached theme if no argument provided
if [[ -z "$THEME_FILE" ]] && [[ -f "$CACHE_FILE" ]]; then
    THEME_FILE="$(cat "$CACHE_FILE")"
fi

if [[ ! -f "${THEME_FILE:-}" ]]; then
    echo "Usage: $(basename "$0") {menu|<theme-file.conf>}" >&2
    echo "       $(basename "$0")                          (re-apply cached theme)" >&2
    exit 1
fi

# Source the theme variables
# shellcheck source=/dev/null
source "$THEME_FILE"
echo "$THEME_FILE" > "$CACHE_FILE"

echo "[theme-switch] Applying theme: ${THEME_NAME}"

# ── 1. Hyprland — live changes via hyprctl eval ─────────────────────
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" general:col.active_border "$ACTIVE_BORDER" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" general:col.inactive_border "$INACTIVE_BORDER" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" general:gaps_in "$GAPS_IN" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" general:gaps_out "$GAPS_OUT" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" general:border_size "$BORDER_SIZE" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" decoration:rounding "$ROUNDING" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" decoration:active_opacity "$ACTIVE_OPACITY" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" decoration:inactive_opacity "$INACTIVE_OPACITY" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" decoration:blur:size "$BLUR_SIZE" 2>/dev/null || true
"$(dirname -- "${BASH_SOURCE[0]}")/hypr-option.sh" decoration:blur:passes "$BLUR_PASSES" 2>/dev/null || true

echo "[theme-switch] Hyprland updated"

# ── 2. Waybar — regenerate style.css with themed color variables ───────
WAYBAR_DIR="${CONFIG_DIR}/waybar"

if [[ -d "$WAYBAR_DIR" ]]; then
    # Convert BG hex to RGB for rgba() usage
    read -r BG_R BG_G BG_B <<< "$(hex_to_rgb "$BG")"

    cat > "${WAYBAR_DIR}/style.css" << CSSEOF
/* ================================================================
   WAYBAR — ${THEME_NAME}
   Auto-generated by theme-switch.sh — do NOT edit manually.
   Edit style-base.css for layout changes.
   ================================================================ */

@define-color bg      rgba(${BG_R}, ${BG_G}, ${BG_B}, 0.92);
@define-color bg2     ${BG_SURFACE};
@define-color border  ${BORDER};
@define-color blue    ${BLUE};
@define-color purple  ${PURPLE};
@define-color cyan    ${CYAN};
@define-color green   ${GREEN};
@define-color orange  ${ORANGE};
@define-color red     ${RED};
@define-color teal    ${TEAL};
@define-color fg      ${FG};
@define-color fg-dim  ${FG_DIM};
@define-color muted   ${MUTED};

CSSEOF

    # Append the base stylesheet (color-independent selectors)
    if [[ -f "${WAYBAR_DIR}/style-base.css" ]]; then
        cat "${WAYBAR_DIR}/style-base.css" >> "${WAYBAR_DIR}/style.css"
        echo "[theme-switch] Waybar style.css regenerated"
    else
        echo "[theme-switch] Warning: style-base.css not found, waybar may look broken" >&2
    fi
fi

# ── 3. Rofi — regenerate theme with new color variables ──────────────
ROFI_DIR="${CONFIG_DIR}/rofi/themes"
ROFI_BASE="${ROFI_DIR}/tokyo-night-base.rasi"
ROFI_OUT="${ROFI_DIR}/tokyo-night.rasi"

if [[ -d "$ROFI_DIR" ]] && [[ -f "$ROFI_BASE" ]]; then
    # Pre-compute all rgba() values Rofi needs from theme hex colors
    ROFI_BG_WINDOW="$(hex_to_rofi_rgba "$BG" 0.92)"
    ROFI_BG_INPUT="$(hex_to_rofi_rgba "$BG_SURFACE" 0.80)"
    ROFI_BG_INPUT_FOCUS="$(hex_to_rofi_rgba "$BG_SURFACE" 0.95)"
    ROFI_BG_ENTRY_HOVER="$(hex_to_rofi_rgba "$BG_HIGHLIGHT" 0.50)"
    ROFI_BG_ENTRY_SEL="$(hex_to_rofi_rgba "$BLUE" 0.12)"
    ROFI_BG_MODE_ACTIVE="$(hex_to_rofi_rgba "$BLUE" 0.22)"
    ROFI_BG_MESSAGE="$(hex_to_rofi_rgba "$BG_SURFACE" 0.50)"
    ROFI_BG_ERROR="$(hex_to_rofi_rgba "$RED" 0.08)"
    ROFI_BG_URGENT="$(hex_to_rofi_rgba "$RED" 0.06)"
    ROFI_BG_ACTIVE="$(hex_to_rofi_rgba "$GREEN" 0.06)"
    ROFI_BG_SEL_URGENT="$(hex_to_rofi_rgba "$RED" 0.12)"
    ROFI_BG_SEL_ACTIVE="$(hex_to_rofi_rgba "$GREEN" 0.12)"
    ROFI_BORDER_WINDOW="$(hex_to_rofi_rgba "$BLUE" 0.15)"
    ROFI_BORDER_INPUT="$(hex_to_rofi_rgba "$BLUE" 0.15)"
    ROFI_BORDER_INPUT_FOCUS="$(hex_to_rofi_rgba "$BLUE" 0.40)"
    ROFI_BORDER_SUBTLE="$(hex_to_rofi_rgba "$BORDER" 0.60)"
    ROFI_BORDER_ERROR="$(hex_to_rofi_rgba "$RED" 0.25)"
    ROFI_BORDER_ACTIVE="$(hex_to_rofi_rgba "$GREEN" 0.30)"
    ROFI_BORDER_MODE="$(hex_to_rofi_rgba "$BLUE" 0.25)"
    ROFI_SCROLLBAR="$(hex_to_rofi_rgba "$BLUE" 0.35)"

    # Brighten FG for "fg-bright" — simple approximation: use FG itself
    # (each theme's FG is already the brightest foreground tone)
    FG_BRIGHT="${FG}"

    cat > "$ROFI_OUT" << ROFIEOF
/* ---------------------------------------------------------------
 * Rofi Theme — ${THEME_NAME}
 * Auto-generated by theme-switch.sh — do NOT edit manually.
 * Edit tokyo-night-base.rasi for layout, theme .conf for colors.
 * --------------------------------------------------------------- */

/* == Color Variables (injected by theme-switch.sh) ============== */
* {
    /* -- Backgrounds -- */
    bg-window:          ${ROFI_BG_WINDOW};
    bg-input:           ${ROFI_BG_INPUT};
    bg-input-focus:     ${ROFI_BG_INPUT_FOCUS};
    bg-entry-hover:     ${ROFI_BG_ENTRY_HOVER};
    bg-entry-selected:  ${ROFI_BG_ENTRY_SEL};
    bg-mode-active:     ${ROFI_BG_MODE_ACTIVE};
    bg-message:         ${ROFI_BG_MESSAGE};
    bg-error:           ${ROFI_BG_ERROR};
    bg-urgent:          ${ROFI_BG_URGENT};
    bg-active:          ${ROFI_BG_ACTIVE};
    bg-selected-urgent: ${ROFI_BG_SEL_URGENT};
    bg-selected-active: ${ROFI_BG_SEL_ACTIVE};

    /* -- Foregrounds -- */
    fg:                 ${FG};
    fg-dim:             ${FG_DIM};
    fg-muted:           ${MUTED};
    fg-bright:          ${FG_BRIGHT};

    /* -- Accents -- */
    blue:               ${BLUE};
    purple:             ${PURPLE};
    cyan:               ${CYAN};
    green:              ${GREEN};
    red:                ${RED};
    yellow:             ${ORANGE};

    /* -- Borders -- */
    border-window:      ${ROFI_BORDER_WINDOW};
    border-input:       ${ROFI_BORDER_INPUT};
    border-input-focus: ${ROFI_BORDER_INPUT_FOCUS};
    border-selected:    ${BLUE};
    border-subtle:      ${ROFI_BORDER_SUBTLE};
    border-error:       ${ROFI_BORDER_ERROR};
    border-active:      ${ROFI_BORDER_ACTIVE};
    border-mode-active: ${ROFI_BORDER_MODE};
    scrollbar-handle:   ${ROFI_SCROLLBAR};

    /* -- Transparency helper -- */
    transparent:        rgba ( 0, 0, 0, 0 );

    /* -- Typography -- */
    font:               "JetBrainsMono Nerd Font 13";

    /* -- Reset defaults -- */
    background-color:   @transparent;
    text-color:         @fg;
    margin:             0;
    padding:            0;
    spacing:            0;
}

ROFIEOF

    # Append the base theme selectors (layout rules referencing @variables)
    cat "$ROFI_BASE" >> "$ROFI_OUT"
    echo "[theme-switch] Rofi theme regenerated"
else
    echo "[theme-switch] Warning: Rofi base theme not found, skipping" >&2
fi

# ── 4. Kitty — live color reload via socket ──────────────────────────────
if pgrep -x kitty > /dev/null 2>&1; then
    for sock in /tmp/kitty-socket-*; do
        [[ -S "$sock" ]] || continue
        kitty @ --to "unix:$sock" set-colors --all \
            "background=${KITTY_BG}" \
            "foreground=${KITTY_FG}" \
            "cursor=${FG}" \
            "selection_background=${BG_HIGHLIGHT}" \
            "color0=${BG_DARK}" \
            "color1=${RED}" \
            "color2=${GREEN}" \
            "color3=${ORANGE}" \
            "color4=${BLUE}" \
            "color5=${PURPLE}" \
            "color6=${CYAN}" \
            "color7=${FG_DIM}" \
            "color8=${MUTED}" \
            "color9=${RED}" \
            "color10=${GREEN}" \
            "color11=${ORANGE}" \
            "color12=${BLUE}" \
            "color13=${PURPLE}" \
            "color14=${CYAN}" \
            "color15=${FG}" \
            2>/dev/null || true
    done
    echo "[theme-switch] Kitty colors updated"
fi

# ── 5. Wallpaper — random pick from theme-specific directory ───────────
if [[ -d "${THEME_WALLPAPER_DIR:-}" ]]; then
    wallpaper=$(find "$THEME_WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) \
        2>/dev/null | shuf -n 1)

    if [[ -n "$wallpaper" ]]; then
        "${CONFIG_DIR}/hypr/scripts/wallpaper.sh" set "$wallpaper"
        echo "[theme-switch] Wallpaper set: $(basename "$wallpaper")"
    else
        echo "[theme-switch] No wallpapers in ${THEME_WALLPAPER_DIR}, skipping"
    fi
else
    echo "[theme-switch] Wallpaper directory not found, skipping"
fi

# ── 6. Waybar — restart to pick up new stylesheet ──────────────────────
if pgrep -x waybar > /dev/null 2>&1; then
    pkill waybar
    sleep 0.3
fi
waybar &disown 2>/dev/null
echo "[theme-switch] Waybar restarted"

# ── 7. SwayNC — reload notification center styles ──────────────────────
swaync-client -rs 2>/dev/null || true

# ── Done — notify the user ─────────────────────────────────────────────
notify-send -t 3000 "  Theme Applied" "${THEME_NAME}" 2>/dev/null || true
echo "[theme-switch] Done — ${THEME_NAME} is now active"
