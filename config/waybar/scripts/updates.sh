#!/usr/bin/env bash
# =============================================================================
# Package Update Checker for Waybar — Tokyo Night Rice
# Counts available dnf updates and outputs Waybar-compatible JSON
# Author: CyberSnakeLinux
# Date: 2026-03-26
# License: MIT
#
# Dependencies: dnf
# Output: JSON { "text", "tooltip", "class" } for Waybar custom module
# Signal: SIGRTMIN+8 (waybar signal 8) to force refresh
# =============================================================================
set -euo pipefail

check_updates() {
    local updates_list count icon tooltip css_class

    # Fetch available updates — suppress errors (e.g., no network)
    updates_list=$(dnf check-update --quiet 2>/dev/null | grep -cE '^\S+\s+\S+\s+\S+' || true)
    count="${updates_list:-0}"

    # Select icon based on update count
    if [[ "$count" -eq 0 ]]; then
        icon="󰄬"
        tooltip="System is up to date"
        css_class="up-to-date"
    elif [[ "$count" -lt 10 ]]; then
        icon="󰏔"
        tooltip="$count update(s) available"
        css_class="few-updates"
    else
        icon="󰏗"
        tooltip="$count update(s) available — consider updating soon"
        css_class="many-updates"
    fi

    # Format display text — hide count when zero for cleaner bar
    local text
    if [[ "$count" -eq 0 ]]; then
        text="$icon"
    else
        text="$icon $count"
    fi

    # Build detailed tooltip with package list (first 15)
    if [[ "$count" -gt 0 ]]; then
        local pkg_list
        pkg_list=$(dnf check-update --quiet 2>/dev/null \
            | grep -E '^\S+\s+\S+\s+\S+' \
            | head -15 \
            | awk '{printf "  %s  →  %s\n", $1, $2}')

        tooltip=$(printf "%s\n\n%s" "$tooltip" "$pkg_list")

        if [[ "$count" -gt 15 ]]; then
            tooltip=$(printf "%s\n  ... and %d more" "$tooltip" $((count - 15)))
        fi
    fi

    # Escape newlines and quotes for JSON safety
    tooltip="${tooltip//\\/\\\\}"
    tooltip="${tooltip//\"/\\\"}"
    tooltip="${tooltip//$'\n'/\\n}"

    printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' \
        "$text" "$tooltip" "$css_class"
}

check_updates
