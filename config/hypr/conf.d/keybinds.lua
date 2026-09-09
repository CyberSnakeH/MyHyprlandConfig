-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║   KEYBINDINGS                                                       ║
-- ║   Tokyo Night Rice — Hyprland                                       ║
-- ║   Author: CyberSnake                                                      ║
-- ║   Date:   2026-03-26                                                ║
-- ║                                                                      ║
-- ║   $mainMod = SUPER. AZERTY-aware layout.                           ║
-- ║   Launcher: Rofi · Clipboard: cliphist + Rofi                      ║
-- ╚══════════════════════════════════════════════════════════════════════╝


-- ─── Mod Key ─────────────────────────────────────────────────────────

-- ─── Program Shortcuts ──────────────────────────────────────────────


-- ══════════════════════════════════════════════════════════════════════
-- APPLICATION LAUNCHES
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -show drun -theme ~/.config/rofi/themes/tokyo-night.rasi"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper.sh"))
hl.bind("SUPER + period", hl.dsp.exec_cmd("rofi -show emoji -theme ~/.config/rofi/themes/tokyo-night.rasi"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/theme-switch.sh menu"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper-picker.sh"))
hl.bind("SUPER + O", hl.dsp.exec_cmd("~/.config/hypr/scripts/opacity.sh"))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/terminal-style.sh"))


-- ══════════════════════════════════════════════════════════════════════
-- CLIPBOARD — cliphist + Rofi
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p \"Clipboard\" -theme ~/.config/rofi/themes/tokyo-night.rasi | cliphist decode | wl-copy"))


-- ══════════════════════════════════════════════════════════════════════
-- WINDOW MANAGEMENT
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exit())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + S", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + Tab", hl.dsp.group.next())
hl.bind("SUPER + SHIFT + Tab", hl.dsp.group.prev())
hl.bind("SUPER + C", hl.dsp.window.center())


-- ══════════════════════════════════════════════════════════════════════
-- ALT+TAB — Windows-style window switching
-- ══════════════════════════════════════════════════════════════════════

hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ next = true }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind("ALT + Tab", hl.dsp.window.alter_zorder({ mode = "top" }))


-- ══════════════════════════════════════════════════════════════════════
-- FOCUS — Vim-style + Arrow keys
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))


-- ══════════════════════════════════════════════════════════════════════
-- MOVE WINDOWS — Vim-style + Arrow keys
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))


-- ══════════════════════════════════════════════════════════════════════
-- RESIZE WINDOWS
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

hl.bind("SUPER + CTRL + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })


-- ══════════════════════════════════════════════════════════════════════
-- WORKSPACES 1-10
-- ══════════════════════════════════════════════════════════════════════

-- Switch to workspace
hl.bind("SUPER + ampersand", hl.dsp.focus({ workspace = "1" }))
hl.bind("SUPER + eacute", hl.dsp.focus({ workspace = "2" }))
hl.bind("SUPER + quotedbl", hl.dsp.focus({ workspace = "3" }))
hl.bind("SUPER + apostrophe", hl.dsp.focus({ workspace = "4" }))
hl.bind("SUPER + parenleft", hl.dsp.focus({ workspace = "5" }))
hl.bind("SUPER + minus", hl.dsp.focus({ workspace = "6" }))
hl.bind("SUPER + egrave", hl.dsp.focus({ workspace = "7" }))
hl.bind("SUPER + underscore", hl.dsp.focus({ workspace = "8" }))
hl.bind("SUPER + ccedilla", hl.dsp.focus({ workspace = "9" }))
hl.bind("SUPER + agrave", hl.dsp.focus({ workspace = "10" }))

-- Move active window to workspace
hl.bind("SUPER + SHIFT + ampersand", hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + SHIFT + eacute", hl.dsp.window.move({ workspace = "2" }))
hl.bind("SUPER + SHIFT + quotedbl", hl.dsp.window.move({ workspace = "3" }))
hl.bind("SUPER + SHIFT + apostrophe", hl.dsp.window.move({ workspace = "4" }))
hl.bind("SUPER + SHIFT + parenleft", hl.dsp.window.move({ workspace = "5" }))
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.move({ workspace = "6" }))
hl.bind("SUPER + SHIFT + egrave", hl.dsp.window.move({ workspace = "7" }))
hl.bind("SUPER + SHIFT + underscore", hl.dsp.window.move({ workspace = "8" }))
hl.bind("SUPER + SHIFT + ccedilla", hl.dsp.window.move({ workspace = "9" }))
hl.bind("SUPER + SHIFT + agrave", hl.dsp.window.move({ workspace = "10" }))

-- Move active window to workspace (silent — don't follow)
hl.bind("SUPER + ALT + ampersand", hl.dsp.window.move({ workspace = "1", follow = false }))
hl.bind("SUPER + ALT + eacute", hl.dsp.window.move({ workspace = "2", follow = false }))
hl.bind("SUPER + ALT + quotedbl", hl.dsp.window.move({ workspace = "3", follow = false }))
hl.bind("SUPER + ALT + apostrophe", hl.dsp.window.move({ workspace = "4", follow = false }))
hl.bind("SUPER + ALT + parenleft", hl.dsp.window.move({ workspace = "5", follow = false }))
hl.bind("SUPER + ALT + minus", hl.dsp.window.move({ workspace = "6", follow = false }))
hl.bind("SUPER + ALT + egrave", hl.dsp.window.move({ workspace = "7", follow = false }))
hl.bind("SUPER + ALT + underscore", hl.dsp.window.move({ workspace = "8", follow = false }))
hl.bind("SUPER + ALT + ccedilla", hl.dsp.window.move({ workspace = "9", follow = false }))
hl.bind("SUPER + ALT + agrave", hl.dsp.window.move({ workspace = "10", follow = false }))

-- Scroll through workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))


-- ══════════════════════════════════════════════════════════════════════
-- SPECIAL WORKSPACES (scratchpads)
-- ══════════════════════════════════════════════════════════════════════

-- Dropdown terminal (SUPER + `)
hl.bind("SUPER + grave", hl.dsp.workspace.toggle_special("terminal"))
hl.bind("SUPER + SHIFT + grave", hl.dsp.window.move({ workspace = "special:terminal" }))

-- Music scratchpad (SUPER + M)
hl.bind("SUPER + M", hl.dsp.workspace.toggle_special("music"))
hl.bind("SUPER + SHIFT + M", hl.dsp.window.move({ workspace = "special:music" }))


-- ══════════════════════════════════════════════════════════════════════
-- MOUSE BINDS
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- ══════════════════════════════════════════════════════════════════════
-- MEDIA & HARDWARE KEYS
-- ══════════════════════════════════════════════════════════════════════

-- Volume — via volume script for OSD notifications
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh up"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh down"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t"), { locked = true })

-- Brightness — via brightness script for OSD notifications
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh up"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh down"), { repeating = true, locked = true })

-- Media playback
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })


-- ══════════════════════════════════════════════════════════════════════
-- SCREENSHOTS — grim + slurp + swappy
-- ══════════════════════════════════════════════════════════════════════

-- Full screen
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh full"))

-- Area selection -> swappy editor
hl.bind("SUPER + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh area"))

-- Active window only
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh window"))

-- Area selection -> clipboard only (quick)
hl.bind("SUPER + ALT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh clip"))


-- ══════════════════════════════════════════════════════════════════════
-- SESSION — Lock, Logout, Reload
-- ══════════════════════════════════════════════════════════════════════

-- Lock screen
hl.bind("SUPER + X", hl.dsp.exec_cmd("hyprlock"))

-- Logout / power menu
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("wlogout -b 4"))

-- Reload Hyprland config
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))


-- ══════════════════════════════════════════════════════════════════════
-- COLOR PICKER
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))


-- ══════════════════════════════════════════════════════════════════════
-- HELP — Keybind Cheat Sheet
-- ══════════════════════════════════════════════════════════════════════

hl.bind("SUPER + H", hl.dsp.exec_cmd("~/.config/hypr/scripts/keybinds.sh"))
