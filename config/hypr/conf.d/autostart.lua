-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║   AUTOSTART PROGRAMS                                                ║
-- ║   Tokyo Night Rice — Hyprland                                       ║
-- ║   Author: CyberSnake                                                      ║
-- ║   Date:   2026-03-26                                                ║
-- ║                                                                      ║
-- ║   hyprland.start hooks run at first launch only.                            ║
-- ║   hl.exec_cmd outside hooks runs on each reload.    ║
-- ╚══════════════════════════════════════════════════════════════════════╝


-- ─── XDG Desktop Portal ─────────────────────────────────────────────
-- Must start before GUI apps that depend on portals (file pickers, etc.)
hl.on("hyprland.start", function() hl.exec_cmd("~/.config/hypr/scripts/portal.sh") end)

-- ─── Status Bar ──────────────────────────────────────────────────────
hl.on("hyprland.start", function() hl.exec_cmd("waybar") end)

-- ─── Wallpaper Daemon (awww) ────────────────────────────────────────
-- awww-daemon handles smooth wallpaper transitions; initial wallpaper
-- is applied by the wallpaper script after the daemon is ready.
hl.on("hyprland.start", function() hl.exec_cmd("awww-daemon") end)
hl.on("hyprland.start", function() hl.exec_cmd("sleep 1 && ~/.config/hypr/scripts/wallpaper.sh") end)

-- ─── Notification Daemon (SwayNC) ───────────────────────────────────
hl.on("hyprland.start", function() hl.exec_cmd("swaync") end)

-- ─── Idle Manager ───────────────────────────────────────────────────
hl.on("hyprland.start", function() hl.exec_cmd("hypridle") end)

-- ─── Authentication Agent ───────────────────────────────────────────
-- Try multiple polkit agent paths (Fedora ships different versions)
hl.on("hyprland.start", function() hl.exec_cmd("/usr/libexec/polkit-gnome-authentication-agent-1 || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/lib/polkit-kde-authentication-agent-1") end)

-- ─── Clipboard Manager ──────────────────────────────────────────────
hl.on("hyprland.start", function() hl.exec_cmd("wl-paste --type text --watch cliphist store") end)
hl.on("hyprland.start", function() hl.exec_cmd("wl-paste --type image --watch cliphist store") end)

-- ─── System Tray Applets ────────────────────────────────────────────
hl.on("hyprland.start", function() hl.exec_cmd("nm-applet --indicator") end)
hl.on("hyprland.start", function() hl.exec_cmd("blueman-applet") end)
