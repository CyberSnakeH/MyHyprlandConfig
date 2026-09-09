local root = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = root .. "?.lua;" .. root .. "conf.d/?.lua;" .. package.path
-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║   HYPRLAND CONFIGURATION — TOKYO NIGHT RICE                        ║
-- ║   Fedora · Wayland compositor                                       ║
-- ║   Author: CyberSnake                                                      ║
-- ║   Date:   2026-03-26                                                ║
-- ║                                                                      ║
-- ║   Main entry point — sources modular config files from conf.d/      ║
-- ║   Edit individual files in conf.d/ rather than this file.           ║
-- ╚══════════════════════════════════════════════════════════════════════╝

-- ─── Environment & Core Settings ─────────────────────────────────────
require("environment")

-- ─── Monitor Layout ──────────────────────────────────────────────────
require("monitors")

-- ─── Input Devices ───────────────────────────────────────────────────
require("input")

-- ─── Visual Decorations ─────────────────────────────────────────────
require("decorations")

-- ─── Animations & Bezier Curves ─────────────────────────────────────
require("animations")

-- ─── Window & Layer Rules ────────────────────────────────────────────
require("rules")

-- ─── Keybindings ─────────────────────────────────────────────────────
require("keybinds")

-- ─── Autostart Programs ─────────────────────────────────────────────
require("autostart")
