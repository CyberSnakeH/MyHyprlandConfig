#!/usr/bin/env bash
# ============================================================================
# WALLPAPER DOWNLOADER -- Tokyo Night curated 4K
# Part of: Tokyo Night Hyprland Rice
# Author:  CyberSnake
# Date:    2026-03-26
# Source:  wallhaven.cc API
#
# Interactive script to download curated 4K wallpapers from wallhaven.cc
# with multiple theme presets (Tokyo Night, Nature, Space, Anime, Minimal).
# Supports custom keyword searches and optional immediate application via
# swww wallpaper manager.
#
# Dependencies: curl, jq, wget, swww (optional, for applying wallpapers)
# ============================================================================

set -uo pipefail

# -- Configuration -----------------------------------------------------------
WALL_DIR="$HOME/Pictures/Wallpapers"
COUNT=20                     # Number of wallpapers to download
RESOLUTION="atleast=2560x1440"
CATEGORIES="111"             # 1=General 1=Anime 1=People (111=all)
PURITY="100"                 # 1=SFW 0=Sketchy 0=NSFW
SORTING="toplist"
TOPRANGE="1M"                # Top of the last month

# -- Terminal colors ----------------------------------------------------------
RED='\033[0;31m';  GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m';  BOLD='\033[1m'
RESET='\033[0m'

log_step()  { echo -e "\n${BOLD}${BLUE}==>${RESET} ${BOLD}$1${RESET}"; }
log_ok()    { echo -e "  ${GREEN}[ok]${RESET} $1"; }
log_warn()  { echo -e "  ${YELLOW}[!]${RESET}  $1"; }
log_info()  { echo -e "  ${CYAN}->${RESET} $1"; }
log_error() { echo -e "  ${RED}[x]${RESET} $1"; }

# -- Dependency check ---------------------------------------------------------
for cmd in curl jq wget; do
    if ! command -v "$cmd" &>/dev/null; then
        log_error "$cmd is missing -- sudo dnf install $cmd"
        exit 1
    fi
done

# -- Banner -------------------------------------------------------------------
echo ""
echo -e "${BOLD}${CYAN}"
cat << 'EOF'
 __        ___    _     _     ____   _    ____  _____ ____
 \ \      / / \  | |   | |   |  _ \ / \  |  _ \| ____|  _ \
  \ \ /\ / / _ \ | |   | |   | |_) / _ \ | |_) |  _| | |_) |
   \ V  V / ___ \| |___| |___|  __/ ___ \|  __/| |___|  _ <
    \_/\_/_/   \_\_____|_____|_| /_/   \_\_|   |_____|_| \_\
EOF
echo -e "${RESET}"
echo -e "  ${BOLD}4K Wallpaper Downloader${RESET} -- wallhaven.cc"
echo ""

# -- Theme selection menu -----------------------------------------------------
echo -e "${BOLD}Choose a style:${RESET}"
echo ""
echo -e "  ${CYAN}1${RESET}  Tokyo Night -- dark cityscapes, neon, night vibes"
echo -e "  ${CYAN}2${RESET}  Nature -- mountains, forests, lakes, sky"
echo -e "  ${CYAN}3${RESET}  Space -- galaxies, nebulae, planets"
echo -e "  ${CYAN}4${RESET}  Anime/Lofi -- aesthetic anime landscapes"
echo -e "  ${CYAN}5${RESET}  Minimal -- clean, dark, geometric"
echo -e "  ${CYAN}6${RESET}  Mixed -- absolute top 4K"
echo -e "  ${CYAN}7${RESET}  Custom -- enter your own keyword"
echo ""
read -rp "Choice [1-7] (default: 1) : " CHOICE
CHOICE=${CHOICE:-1}

case "$CHOICE" in
    1)
        QUERY="night+city+neon+dark"
        COLOR="1a1b26"
        STYLE="Tokyo Night"
        ;;
    2)
        QUERY="nature+landscape+mountain+4k"
        COLOR=""
        STYLE="Nature"
        ;;
    3)
        QUERY="space+galaxy+nebula+stars"
        COLOR=""
        STYLE="Space"
        ;;
    4)
        QUERY="anime+landscape+aesthetic+lofi"
        COLOR=""
        CATEGORIES="010"  # Anime only
        STYLE="Anime/Lofi"
        ;;
    5)
        QUERY="minimal+dark+geometric+abstract"
        COLOR="1a1b26"
        STYLE="Minimal Dark"
        ;;
    6)
        QUERY=""
        COLOR=""
        STYLE="Top 4K"
        ;;
    7)
        read -rp "Keyword: " CUSTOM_QUERY
        QUERY="$CUSTOM_QUERY"
        COLOR=""
        STYLE="Custom: $CUSTOM_QUERY"
        ;;
    *)
        QUERY="night+city+neon+dark"
        COLOR="1a1b26"
        STYLE="Tokyo Night"
        ;;
esac

read -rp "How many wallpapers? (default: $COUNT) : " CUSTOM_COUNT
COUNT=${CUSTOM_COUNT:-$COUNT}

# -- Create wallpaper directory -----------------------------------------------
mkdir -p "$WALL_DIR"

# -- Build API URL ------------------------------------------------------------
log_step "Searching wallpapers -- $STYLE"

API_URL="https://wallhaven.cc/api/v1/search?"
API_URL+="sorting=${SORTING}"
API_URL+="&topRange=${TOPRANGE}"
API_URL+="&${RESOLUTION}"
API_URL+="&categories=${CATEGORIES}"
API_URL+="&purity=${PURITY}"
API_URL+="&ratios=16x9,21x9"

[[ -n "$QUERY" ]] && API_URL+="&q=${QUERY}"
[[ -n "${COLOR:-}" ]] && API_URL+="&colors=${COLOR}"

log_info "Style : ${BOLD}$STYLE${RESET}"
log_info "Resolution : >= 2560x1440"
log_info "Count : $COUNT"

# -- Fetch wallpaper URLs from API --------------------------------------------
PAGES=$(( (COUNT + 23) / 24 ))  # wallhaven returns 24 per page
ALL_URLS=""

for (( page=1; page<=PAGES; page++ )); do
    log_info "API request page $page/$PAGES..."
    RESPONSE=$(curl -sf "${API_URL}&page=${page}" 2>/dev/null || true)

    if [[ -z "$RESPONSE" ]]; then
        log_error "wallhaven API unreachable (page $page)"
        continue
    fi

    PAGE_URLS=$(echo "$RESPONSE" | jq -r '.data[].path' 2>/dev/null || true)

    if [[ -z "$PAGE_URLS" ]]; then
        log_warn "No results on page $page"
        break
    fi

    ALL_URLS+="$PAGE_URLS"$'\n'
done

# -- Deduplicate and limit ----------------------------------------------------
URLS=$(echo "$ALL_URLS" | grep -v '^$' | head -n "$COUNT")
TOTAL=$(echo "$URLS" | grep -c . || true)

if [[ "$TOTAL" -eq 0 ]]; then
    log_error "No wallpapers found. Try another style or keyword."
    exit 1
fi

log_ok "$TOTAL wallpapers found"

# -- Download wallpapers ------------------------------------------------------
log_step "Downloading to $WALL_DIR"

DOWNLOADED=0
SKIPPED=0

while IFS= read -r url; do
    [[ -z "$url" ]] && continue
    FILENAME=$(basename "$url")
    DEST="$WALL_DIR/$FILENAME"

    if [[ -f "$DEST" ]]; then
        (( SKIPPED++ )) || true
        continue
    fi

    wget -q --show-progress -O "$DEST" "$url" 2>&1
    if [[ -f "$DEST" ]] && [[ -s "$DEST" ]]; then
        (( DOWNLOADED++ )) || true
    else
        rm -f "$DEST"
        log_warn "Failed: $FILENAME"
    fi
done <<< "$URLS"

# -- Summary ------------------------------------------------------------------
echo ""
log_step "Done"
log_ok "$DOWNLOADED wallpapers downloaded"
[[ $SKIPPED -gt 0 ]] && log_info "$SKIPPED already present (skipped)"
log_info "Directory: ${BOLD}$WALL_DIR${RESET}"

# -- Optionally apply a random wallpaper -------------------------------------
echo ""
read -rp "Apply a random wallpaper now? [y/N] " APPLY
if [[ "$APPLY" =~ ^[yY]$ ]]; then
    RANDOM_WALL=$(find "$WALL_DIR" -type f \
        \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) \
        ! -name "wallpaper.png" | shuf -n1)

    if [[ -n "$RANDOM_WALL" ]]; then
        # Use swww if available, otherwise create a static symlink
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        WALLPAPER_SCRIPT="${SCRIPT_DIR}/../config/hypr/scripts/wallpaper.sh"

        if [[ -x "$WALLPAPER_SCRIPT" ]]; then
            "$WALLPAPER_SCRIPT" set "$RANDOM_WALL"
        elif command -v swww &>/dev/null; then
            swww img "$RANDOM_WALL" \
                --transition-type grow \
                --transition-duration 2 \
                --transition-fps 60
            ln -sf "$RANDOM_WALL" "$WALL_DIR/wallpaper.png"
        else
            ln -sf "$RANDOM_WALL" "$WALL_DIR/wallpaper.png"
        fi

        log_ok "Wallpaper applied: $(basename "$RANDOM_WALL")"
    fi
fi

echo ""
echo -e "${BOLD}${GREEN}Enjoy your rice!${RESET}"
echo ""
