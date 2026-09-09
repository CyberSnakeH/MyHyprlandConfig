#!/usr/bin/env bash
# Session actions work before and after switching from Hyprlang to Lua.
set -euo pipefail

fail() {
    printf '%s\n' "$1" >&2
    notify-send -u critical 'Session' "$1" 2>/dev/null || true
    exit 1
}

case "${1:-}" in
    lock)
        command -v hyprlock >/dev/null || fail 'Hyprlock est absent. Installe-le avec : sudo dnf install hyprlock'
        pgrep -u "$(id -u)" -x hyprlock >/dev/null && exit 0
        exec hyprlock --config "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprlock.conf"
        ;;
    logout)
        # The current manager, not the presence of a .lua file, decides syntax.
        status=0
        probe=$(hyprctl eval 'return 1' 2>&1) || status=$?
        if [[ "$probe" == *'eval is only supported with the lua config manager'* ]]; then
            exec hyprctl dispatch exit
        elif (( status == 0 )); then
            exec hyprctl dispatch 'hl.dsp.exit()'
        else
            fail "Impossible de contacter Hyprland : $probe"
        fi
        ;;
    *) printf 'Usage: %s {lock|logout}\n' "$0" >&2; exit 2 ;;
esac
