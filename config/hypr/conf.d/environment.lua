-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║   ENVIRONMENT VARIABLES & CORE SETTINGS                            ║
-- ║   Tokyo Night Rice — Hyprland                                       ║
-- ║   Author: CyberSnake                                                      ║
-- ║   Date:   2026-03-26                                                ║
-- ╚══════════════════════════════════════════════════════════════════════╝


-- ─── Wayland / XDG Session ───────────────────────────────────────────
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- ─── Cursor ──────────────────────────────────────────────────────────
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")

-- ─── Qt Toolkit ──────────────────────────────────────────────────────
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- ─── GTK Toolkit ─────────────────────────────────────────────────────
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("GTK_THEME", "Tokyonight-Dark-BL")

-- ─── Application Backends ────────────────────────────────────────────
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")


-- ══════════════════════════════════════════════════════════════════════
-- CORE LAYOUT & BEHAVIOR
-- ══════════════════════════════════════════════════════════════════════

-- ─── General ─────────────────────────────────────────────────────────
hl.config({ general = {
    gaps_in = 4,
    gaps_out = 8,
    border_size = 2,

    -- Tokyo Night rotating gradient: blue -> purple -> cyan
    -- Combined with borderangle loop animation, this creates a continuously
    -- rotating prismatic border on active windows
    ["col.active_border"] = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)", "rgba(7dcfffee)" }, angle = 45 },
    ["col.inactive_border"] = "rgba(292e4266)",

    layout = "dwindle",
    resize_on_border = true,
    allow_tearing = false,
} })

-- ─── Dwindle Layout ─────────────────────────────────────────────────
hl.config({ dwindle = {
    preserve_split = true,
    smart_split = true,
    smart_resizing = true,
} })

-- ─── Master Layout ──────────────────────────────────────────────────
hl.config({ master = {
    mfact = 0.55,
} })

-- ─── Miscellaneous ──────────────────────────────────────────────────
hl.config({ misc = {
    -- Disable default branding
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,

    -- Rendering performance (vfr removed in Hyprland 0.55 — always on now)
    vrr = 0,

    -- Smooth resize & drag animations
    animate_manual_resizes = true,
    animate_mouse_windowdragging = true,

    -- Wake from DPMS on input
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,

    -- Terminal swallowing (kitty / alacritty)
    enable_swallow = true,
    swallow_regex = "^(kitty|Alacritty)$",

    -- Prevent focus stealing from urgent windows
    focus_on_activate = false,
} })
