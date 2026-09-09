-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║   ANIMATIONS & BEZIER CURVES                                        ║
-- ║   Tokyo Night Rice — Hyprland 0.56.2                                ║
-- ║   Author: CyberSnake                                                      ║
-- ║   Date:   2026-03-26                                                ║
-- ║                                                                      ║
-- ║   Ultra-premium animation suite. Eight hand-tuned bezier curves      ║
-- ║   provide macOS-level fluidity across every motion type. Designed    ║
-- ║   for high-refresh displays with RTX 5070 Ti rendering overhead.    ║
-- ╚══════════════════════════════════════════════════════════════════════╝

hl.config({ animations = { enabled = true } })

-- ─── Premium Bezier Curves ──────────────────────────────────────────
-- Each curve is purpose-built for a specific motion archetype.
-- Visualize at https://cubic-bezier.com

-- Natural spring-like motion with slight overshoot — primary window slide
hl.curve("wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

-- Soft entrance with elastic feel — new windows appearing
hl.curve("winIn", { type = "bezier", points = { {0.1, 1.1}, {0.1, 1.1} } })

-- Quick exit with pull-back anticipation — windows closing
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1} } })

-- Perfect linear for continuous animations — border rotation, loops
hl.curve("liner", { type = "bezier", points = { {1, 1}, {1, 1} } })

-- Smooth deceleration (ease-out) — fades, subtle transitions
hl.curve("easeOut", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })

-- Material Design standard curve — general-purpose polish
hl.curve("material", { type = "bezier", points = { {0.4, 0}, {0.2, 1} } })

-- Gentle bounce with micro-overshoot — workspace switches, repositioning
hl.curve("gentle", { type = "bezier", points = { {0.2, 0.85}, {0.32, 1.05} } })

-- Quick snap — instant-feel interactions with smooth tail
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

-- ─── Window Animations ──────────────────────────────────────────────
-- Default window motion uses spring-like wind curve
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "wind", style = "slide" })
-- Entrances: elastic winIn gives a subtle bounce on spawn
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "winIn", style = "slide" })
-- Exits: anticipation pull-back before sliding away
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "winOut", style = "slide" })
-- Repositioning: gentle curve for drag/resize/tiling moves
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "gentle", style = "slide" })

-- ─── Border Animations ──────────────────────────────────────────────
-- Instant border color transition (no perceptible delay)
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
-- Continuous gradient rotation — speed capped at the Lua API maximum (100)
-- Combined with col.active_border gradient creates a living border
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "liner", style = "loop" })

-- ─── Fade Animations ────────────────────────────────────────────────
-- General fade uses Material curve for professional feel
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "material" })
-- Dim effect on inactive windows — subtle, not distracting
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "material" })
-- Fade-in: quick ease-out so windows feel instantly present
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "easeOut" })
-- Fade-out: matches fade-in timing for symmetry
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "easeOut" })

-- ─── Workspace Transitions ──────────────────────────────────────────
-- Workspace slide with gentle bounce — feels spatial and intentional
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "gentle", style = "slide" })
-- Special workspace (scratchpad) drops in vertically with spring
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "wind", style = "slidevert" })

-- ─── Layer Animations (Waybar, Rofi, SwayNC) ────────────────────────
-- Default layer: Material fade for overlays
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "material", style = "fade" })
-- Layer entrance: elastic slide from edge
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "winIn", style = "slide" })
-- Layer exit: quick pull-back exit
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "winOut", style = "slide" })
