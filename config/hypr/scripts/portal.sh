#!/usr/bin/env bash
# ============================================================================
# XDG Desktop Portal Initialization for Hyprland
# Part of: Tokyo Night Hyprland Rice
# Author:  CyberSnake
# Date:    2026-03-26
#
# Starts the Hyprland-specific XDG desktop portal first, then the generic
# portal daemon. The sleep delays ensure proper D-Bus registration order.
#
# Dependencies: xdg-desktop-portal-hyprland, xdg-desktop-portal
# ============================================================================

set -euo pipefail

# -- Kill any existing portal instances to avoid conflicts --
killall -q xdg-desktop-portal-hyprland 2>/dev/null || true
killall -q xdg-desktop-portal 2>/dev/null || true

# -- Allow D-Bus to settle after cleanup --
sleep 1

# -- Start the Hyprland-specific portal backend --
/usr/lib/xdg-desktop-portal-hyprland &

# -- Wait for the backend to register on D-Bus before starting the frontend --
sleep 2

# -- Start the generic XDG desktop portal --
/usr/lib/xdg-desktop-portal &
