-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║   WINDOW & LAYER RULES                                              ║
-- ║   Tokyo Night Rice — Hyprland                                       ║
-- ║   Author: CyberSnake                                                      ║
-- ║   Date:   2026-03-26                                                ║
-- ║                                                                      ║
-- ║   Float rules, opacity overrides, workspace assignments,           ║
-- ║   scratchpads, and layer-shell rules.                               ║
-- ║                                                                      ║
-- ║   Syntax: Hyprland Lua (hl.window_rule / hl.layer_rule).            ║
-- ╚══════════════════════════════════════════════════════════════════════╝


-- ══════════════════════════════════════════════════════════════════════
-- FLOAT RULES
-- ══════════════════════════════════════════════════════════════════════

-- System utilities
hl.window_rule({ name = "rice-rules-1", match = { class = "^(pavucontrol)$" }, float = true })
hl.window_rule({ name = "rice-rules-2", match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ name = "rice-rules-3", match = { class = "^(.blueman-manager-wrapped)$" }, float = true })
hl.window_rule({ name = "rice-rules-4", match = { class = "^(blueman-manager)$" }, float = true })
hl.window_rule({ name = "rice-rules-5", match = { class = "^(file-roller)$" }, float = true })

-- Media viewers
hl.window_rule({ name = "rice-rules-6", match = { class = "^(imv)$" }, float = true })
hl.window_rule({ name = "rice-rules-7", match = { class = "^(mpv)$" }, float = true })

-- Hyprland tools
hl.window_rule({ name = "rice-rules-8", match = { class = "^(hyprpicker)$" }, float = true })

-- Session management
hl.window_rule({ name = "rice-rules-9", match = { class = "^(wlogout)$" }, float = true })

-- Generic dialog/preferences windows
hl.window_rule({ name = "rice-rules-10", match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ name = "rice-rules-11", match = { title = "^(Preferences)$" }, float = true })
hl.window_rule({ name = "rice-rules-12", match = { title = "(Param)" }, float = true })


-- ══════════════════════════════════════════════════════════════════════
-- FLOAT SIZE & POSITION
-- ══════════════════════════════════════════════════════════════════════

-- pavucontrol — centered, comfortable size
hl.window_rule({ name = "rice-rules-13", match = { class = "^(pavucontrol)$" }, size = "900 600" })
hl.window_rule({ name = "rice-rules-14", match = { class = "^(pavucontrol)$" }, center = true })

-- blueman — centered
hl.window_rule({ name = "rice-rules-15", match = { class = "^(.blueman-manager-wrapped)$" }, size = "900 650" })
hl.window_rule({ name = "rice-rules-16", match = { class = "^(.blueman-manager-wrapped)$" }, center = true })
hl.window_rule({ name = "rice-rules-17", match = { class = "^(blueman-manager)$" }, size = "900 650" })
hl.window_rule({ name = "rice-rules-18", match = { class = "^(blueman-manager)$" }, center = true })

-- mpv — large centered window
hl.window_rule({ name = "rice-rules-19", match = { class = "^(mpv)$" }, size = "1200 800" })
hl.window_rule({ name = "rice-rules-20", match = { class = "^(mpv)$" }, center = true })


-- ══════════════════════════════════════════════════════════════════════
-- OPACITY OVERRIDES
-- ══════════════════════════════════════════════════════════════════════

-- Terminals — slight transparency for a layered look
hl.window_rule({ name = "rice-rules-21", match = { class = "^(kitty)$" }, opacity = "0.90 0.85" })

-- File manager — nearly opaque
hl.window_rule({ name = "rice-rules-22", match = { class = "^(thunar)$" }, opacity = "0.95 0.90" })

-- Code editors — minimal transparency to preserve readability
hl.window_rule({ name = "rice-rules-23", match = { class = "^(code)$" }, opacity = "0.96 0.92" })
hl.window_rule({ name = "rice-rules-24", match = { class = "^(codium)$" }, opacity = "0.96 0.92" })
hl.window_rule({ name = "rice-rules-25", match = { class = "^(Code)$" }, opacity = "0.96 0.92" })
hl.window_rule({ name = "rice-rules-26", match = { class = "^(VSCodium)$" }, opacity = "0.96 0.92" })


-- ══════════════════════════════════════════════════════════════════════
-- WORKSPACE ASSIGNMENTS
-- ══════════════════════════════════════════════════════════════════════

-- Browsers on workspace 2
hl.window_rule({ name = "rice-rules-27", match = { class = "^(firefox)$" }, workspace = "2" })
hl.window_rule({ name = "rice-rules-28", match = { class = "^(Firefox)$" }, workspace = "2" })

-- Code editors on workspace 3
hl.window_rule({ name = "rice-rules-29", match = { class = "^(code)$" }, workspace = "3" })
hl.window_rule({ name = "rice-rules-30", match = { class = "^(codium)$" }, workspace = "3" })
hl.window_rule({ name = "rice-rules-31", match = { class = "^(Code)$" }, workspace = "3" })
hl.window_rule({ name = "rice-rules-32", match = { class = "^(VSCodium)$" }, workspace = "3" })

-- File manager on workspace 5
hl.window_rule({ name = "rice-rules-33", match = { class = "^(thunar)$" }, workspace = "5" })

-- Communication on workspace 8
hl.window_rule({ name = "rice-rules-34", match = { class = "^(discord)$" }, workspace = "8" })
hl.window_rule({ name = "rice-rules-35", match = { class = "^(vesktop)$" }, workspace = "8" })
hl.window_rule({ name = "rice-rules-36", match = { class = "^(WebCord)$" }, workspace = "8" })

-- Music on workspace 9
hl.window_rule({ name = "rice-rules-37", match = { class = "^(Spotify)$" }, workspace = "9" })
hl.window_rule({ name = "rice-rules-38", match = { title = "^(Spotify)$" }, workspace = "9" })


-- ══════════════════════════════════════════════════════════════════════
-- SCRATCHPAD — DROPDOWN TERMINAL
-- ══════════════════════════════════════════════════════════════════════

-- Scratchpad terminal (launched with: kitty --class kittyspecial)
hl.window_rule({ name = "rice-rules-39", match = { class = "^(kittyspecial)$" }, float = true })
hl.window_rule({ name = "rice-rules-40", match = { class = "^(kittyspecial)$" }, size = "1100 650" })
hl.window_rule({ name = "rice-rules-41", match = { class = "^(kittyspecial)$" }, center = true })
hl.window_rule({ name = "rice-rules-42", match = { class = "^(kittyspecial)$" }, opacity = "0.92 0.92" })
hl.window_rule({ name = "rice-rules-43", match = { class = "^(kittyspecial)$" }, animation = "slide" })


-- ══════════════════════════════════════════════════════════════════════
-- ROFI — OPACITY & FOCUS OVERRIDE
-- ══════════════════════════════════════════════════════════════════════

-- Rofi manages its own transparency via its theme — prevent Hyprland
-- from applying additional opacity, and lock focus to the launcher
hl.window_rule({ name = "rice-rules-44", match = { class = "^(Rofi)$" }, opacity = "1.0 override 1.0 override" })
hl.window_rule({ name = "rice-rules-45", match = { class = "^(Rofi)$" }, stay_focused = true })

-- Dim everything behind Rofi for visual hierarchy and depth
hl.window_rule({ name = "rice-rules-46", match = { class = "^(Rofi)$" }, dim_around = true })


-- ══════════════════════════════════════════════════════════════════════
-- LAYER RULES — ROFI, NOTIFICATIONS, OVERLAYS
-- ══════════════════════════════════════════════════════════════════════

-- Waybar — glassmorphic blur
hl.layer_rule({ name = "rice-rules-47", match = { namespace = "^(waybar)$" }, blur = true })
hl.layer_rule({ name = "rice-rules-48", match = { namespace = "^(waybar)$" }, blur_popups = true })
hl.layer_rule({ name = "rice-rules-49", match = { namespace = "^(waybar)$" }, ignore_alpha = 0 })

-- Rofi launcher
hl.layer_rule({ name = "rice-rules-50", match = { namespace = "^(rofi)$" }, blur = true })
hl.layer_rule({ name = "rice-rules-51", match = { namespace = "^(rofi)$" }, ignore_alpha = 0 })

-- SwayNC notification panel
hl.layer_rule({ name = "rice-rules-52", match = { namespace = "^(swaync-control-center)$" }, blur = true })
hl.layer_rule({ name = "rice-rules-53", match = { namespace = "^(swaync-notification-window)$" }, blur = true })
hl.layer_rule({ name = "rice-rules-54", match = { namespace = "^(swaync-control-center)$" }, ignore_alpha = 0 })
hl.layer_rule({ name = "rice-rules-55", match = { namespace = "^(swaync-notification-window)$" }, ignore_alpha = 0.5 })


-- ══════════════════════════════════════════════════════════════════════
-- TEARING — GAME SUPPORT
-- ══════════════════════════════════════════════════════════════════════

-- Allow tearing for Steam games (reduces input latency)
hl.window_rule({ name = "rice-rules-56", match = { class = "^(steam_app_.*)$" }, immediate = true })


-- ══════════════════════════════════════════════════════════════════════
-- SPECIAL WORKSPACES (named scratchpads)
-- ══════════════════════════════════════════════════════════════════════

-- These are toggled via keybinds in keybinds.lua:
--   SUPER + ` (grave) -> special:terminal
--   SUPER + M          -> special:music
