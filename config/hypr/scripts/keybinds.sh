#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║   keybinds.sh — Keybind Cheat Sheet via Rofi                       ║
# ║   Tokyo Night Rice — Hyprland                                      ║
# ║   Author: CyberSnake                                                     ║
# ║                                                                     ║
# ║   Displays a categorized, read-only reference of all keybinds      ║
# ║   in a Rofi dmenu window. Triggered by SUPER + H.                  ║
# ║                                                                     ║
# ║   Dependencies: rofi-wayland, JetBrainsMono Nerd Font              ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -euo pipefail

ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/themes/tokyo-night.rasi"

keybinds=$(cat << 'EOF'
 ─── Applications ───────────────────────────
  SUPER + Return             Terminal (Kitty)
  SUPER + D                  App Launcher (Rofi)
  SUPER + B                  Browser (Firefox)
  SUPER + E                  File Manager (Thunar)
  SUPER + V                  Clipboard History
  SUPER + W                  Next Wallpaper
  SUPER + SHIFT + W          Wallpaper Picker
  SUPER + O                  Window Opacity
  SUPER + T                  Theme Switcher
  SUPER + SHIFT + T          Terminal Style
  SUPER + .                  Emoji Picker
  SUPER + SHIFT + C          Color Picker

 ─── Windows ────────────────────────────────
  SUPER + Q                  Close Window
  SUPER + SHIFT + Q          Exit Hyprland
  SUPER + F                  Fullscreen
  SUPER + SHIFT + F          Fake Fullscreen
  SUPER + Space              Toggle Float
  SUPER + P                  Pseudo-tile
  SUPER + S                  Toggle Split
  SUPER + G                  Toggle Group
  SUPER + C                  Center Window
  ALT + Tab                  Cycle Windows
  ALT + SHIFT + Tab          Cycle Reverse

 ─── Focus & Move ───────────────────────────
  SUPER + L/J/K              Focus right/down/up
  SUPER + Arrow Keys         Focus direction
  SUPER + SHIFT + Arrows     Move window
  SUPER + CTRL + Arrows      Resize window
  SUPER + Mouse Scroll       Scroll workspaces
  SUPER + LMB                Move window (drag)
  SUPER + RMB                Resize window (drag)

 ─── Workspaces (AZERTY) ───────────────────
  SUPER + & e " ' ( - e _ c a    Switch workspace 1-10
  SUPER + SHIFT + same key       Move to workspace
  SUPER + ALT + same key         Move silent

 ─── Scratchpads ────────────────────────────
  SUPER + `                  Dropdown Terminal
  SUPER + M                  Music Player

 ─── Screenshots ────────────────────────────
  Print                      Full Screen
  SUPER + Print              Area -> Editor (Swappy)
  SUPER + SHIFT + Print      Active Window
  SUPER + ALT + Print        Area -> Clipboard

 ─── Media ──────────────────────────────────
  Volume Keys                Volume Up/Down/Mute
  Brightness Keys            Brightness Up/Down
  Media Keys                 Play/Pause/Next/Prev

 ─── Session ────────────────────────────────
  SUPER + X                  Lock Screen
  SUPER + SHIFT + X          Power Menu
  SUPER + SHIFT + R          Reload Config
  SUPER + H                  This Help Menu
EOF
)

echo "$keybinds" | rofi -dmenu \
    -p "  Keybinds" \
    -theme "$ROFI_THEME" \
    -i \
    -no-custom \
    -selected-row 0 \
    -window-title "Keybind Help"

exit 0
