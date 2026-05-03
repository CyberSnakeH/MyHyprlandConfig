<div align="center">

# Tokyo Night -- Hyprland Rice

**A polished, themeable, production-grade Hyprland desktop environment for Fedora Linux**

*9 live-switchable color themes -- 6 terminal styles -- 13 Neovim colorschemes -- Automated installer*

![Hyprland](https://img.shields.io/badge/Hyprland-blue?style=for-the-badge&logo=wayland&logoColor=white)
![Fedora](https://img.shields.io/badge/Fedora_43-294172?style=for-the-badge&logo=fedora&logoColor=white)
![Themes](https://img.shields.io/badge/9_Themes-bb9af7?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)

</div>

---

## Screenshots

> Screenshots coming soon -- contributions welcome!

<!--
![Desktop](screenshots/desktop.png)
![Waybar](screenshots/waybar.png)
![Rofi](screenshots/rofi.png)
![Lock Screen](screenshots/lockscreen.png)
![Notifications](screenshots/notifications.png)
![Neovim](screenshots/neovim.png)
-->

---

## Table of Contents

- [Features](#features)
- [Components](#components)
- [Color Themes](#color-themes)
- [Terminal Styles](#terminal-styles)
- [Neovim](#neovim)
- [Keybinds](#keybinds)
- [Color Palette](#color-palette)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Customization](#customization)
- [Dependencies](#dependencies)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)
- [Contributing](#contributing)
- [License](#license)

---

## Features

This rice is a **complete desktop environment** -- not just a compositor config. Every component is themed, every script is production-grade, and the entire system is designed to work as a cohesive whole.

### Highlights

- **9 Color Themes** switchable live with `SUPER + T` -- every component reloads instantly (Hyprland, Waybar, Rofi, SwayNC, Kitty, Hyprlock, GTK)
- **6 Terminal Styles** switchable with `SUPER + SHIFT + T` -- from clean minimalism to cyberpunk aesthetics
- **13 Neovim Colorschemes** with a Telescope-powered picker (`Space + tt`) organized by category
- **Wallpaper Picker** (`SUPER + SHIFT + W`) -- browse and apply wallpapers with animated transitions via awww
- **Wallpaper Downloader** -- script to download curated 4K wallpapers from wallhaven.cc
- **Opacity Control** (`SUPER + O`) -- 8 presets from fully opaque to ultra-transparent
- **Keybind Help** (`SUPER + H`) -- full cheat sheet displayed in a Rofi overlay
- **ALT + TAB** window switching -- familiar Windows-style window cycling
- **AZERTY keyboard** support -- workspace keys mapped to the French number row
- **EDID monitor auto-detection** with HiDPI scaling support
- **Rotating gradient borders** -- animated tri-color border gradients on active windows
- **Modular configuration** -- every aspect lives in its own file, easy to understand and modify

---

## Components

| Component | Tool | Highlights |
|-----------|------|------------|
| **Compositor** | [Hyprland](https://hyprland.org) | Modular `conf.d/`, EDID monitor detection, premium bezier animations, rotating gradient borders |
| **Status Bar** | [Waybar](https://github.com/Alexays/Waybar) | Floating pill-shaped modules, weather widget, system updates counter, MPRIS media controls |
| **Launcher** | [Rofi](https://github.com/davatorium/rofi) | Fuzzy app launcher, emoji picker, clipboard manager, theme switcher interface |
| **Notifications** | [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) | Full notification daemon with slide-out control center panel |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated, 6 switchable visual styles, ligature support |
| **Editor** | [Neovim](https://neovim.io) | lazy.nvim plugin manager, 13 colorschemes, Telescope, Treesitter, completion, terminal toggle |
| **Lock Screen** | [Hyprlock](https://github.com/hyprwm/hyprlock) | Cinematic lock screen with blur, clock, avatar, and themed greeting |
| **Idle Daemon** | [Hypridle](https://github.com/hyprwm/hypridle) | Dim at 5 min, lock at 10 min, DPMS off at 15 min, suspend at 30 min |
| **Wallpaper** | [awww](https://github.com/LGFae/swww) | Animated transitions (grow, fade, wipe) with picker and downloader scripts |
| **Shell Prompt** | [Starship](https://starship.rs) | Two-line powerline with git status, language detection, and directory fill |
| **File Manager** | [Yazi](https://yazi-rs.github.io) + [Thunar](https://docs.xfce.org/xfce/thunar/start) | TUI and GUI file management, both themed |
| **System Monitor** | [btop](https://github.com/aristocratos/btop) | Custom Tokyo Night theme with full sensor support |
| **Browser** | [Firefox](https://www.mozilla.org/firefox/) | Custom `userChrome.css` -- themed tab bar, hidden title bar |
| **GTK / Qt** | Tokyonight-Dark-BL / Kvantum | Unified theming across GTK 2/3/4 and Qt 5/6 |
| **Session Menu** | [Wlogout](https://github.com/ArtsyMacaw/wlogout) | Six-button power menu (lock, logout, suspend, hibernate, reboot, shutdown) |
| **Clipboard** | [cliphist](https://github.com/sentriz/cliphist) | Persistent clipboard history with Rofi integration |
| **Screenshots** | grim + slurp + swappy | Four modes: fullscreen, region, window, region-to-clipboard |
| **Color Picker** | [Hyprpicker](https://github.com/hyprwm/hyprpicker) | Pick any color from screen, auto-copied to clipboard |

---

## Color Themes

Switch between **9 color themes** instantly with `SUPER + T`. Every visible component updates in real time -- Hyprland borders, Waybar, Rofi, SwayNC, Kitty terminal, Hyprlock, and GTK applications.

| Theme | Description |
|-------|-------------|
| **Tokyo Night** | Cool blue-purple palette with deep storm backgrounds (default) |
| **Catppuccin Mocha** | Warm pastel tones on a rich chocolate base |
| **Rose Pine** | Muted, earthy tones with dawn and dusk accents |
| **Gruvbox** | Retro warm scheme with orange and aqua highlights |
| **Cyber** | Neon-bright cyberpunk aesthetic with electric accents |
| **Dracula** | Classic dark theme with purple and pink accents |
| **Kanagawa** | Japanese ink painting inspired -- deep indigo and gold |
| **Midnight** | Ultra-dark theme with minimal contrast for night sessions |
| **Nord** | Arctic, cool-toned palette inspired by Nordic landscapes |

Each theme is defined in a standalone file under `themes/` containing the full palette, border gradient, rounding, gaps, blur, and opacity values.

---

## Terminal Styles

Switch between **6 terminal visual styles** with `SUPER + SHIFT + T`. Each style adjusts font, opacity, background blur, padding, and cursor appearance in Kitty.

| Style | Character |
|-------|-----------|
| **Default** | Clean, balanced -- the everyday workhorse |
| **Lofi** | Soft, warm tones -- calm and focused |
| **Cyber** | Neon green on dark -- hacker aesthetic |
| **Midnight** | Ultra-dark, minimal chrome -- late night coding |
| **Retro** | Amber/green phosphor CRT feel |
| **Minimal** | Maximum content, minimum decoration |

---

## Neovim

A full Neovim configuration built with **lazy.nvim** and organized into modular Lua files.

### Plugin Categories

| Category | Plugins |
|----------|---------|
| **Colorschemes** | 13 themes: tokyonight, catppuccin, rose-pine, gruvbox, kanagawa, cyberdream, dracula, nord, nightfox, everforest, onedark, material, oxocarbon |
| **Telescope** | Fuzzy finder for files, grep, buffers, themes |
| **Treesitter** | Syntax highlighting, textobjects, incremental selection |
| **Completion** | nvim-cmp with LSP, buffer, path, and snippet sources |
| **UI** | Lualine statusline, indent guides, which-key, nvim-tree |
| **Editor** | Autopairs, comment, surround, gitsigns |

### Neovim Keybinds

| Keybind | Action |
|---------|--------|
| `Space + t` | Toggle integrated terminal |
| `Space + tt` | Theme picker (Telescope) |
| `Space + ff` | Find files |
| `Space + fg` | Live grep |
| `Space + fb` | Browse buffers |
| `Space + e` | Toggle file explorer (nvim-tree) |

Themes are organized into three categories in the picker: **default** (general purpose), **lofi** (muted, warm), and **cyber** (high contrast, vivid).

---

## Keybinds

All keybinds use **SUPER** (Windows key) as the primary modifier. Workspace keys map to the AZERTY number row (`&`, `e`, `"`, `'`, `(`, `-`, `e`, `_`, `c`, `a`).

### Applications

| Keybind | Action |
|---------|--------|
| `SUPER + Return` | Terminal (Kitty) |
| `SUPER + D` | App Launcher (Rofi) |
| `SUPER + B` | Browser (Firefox) |
| `SUPER + E` | File Manager (Thunar) |
| `SUPER + V` | Clipboard History |
| `SUPER + W` | Next Wallpaper |
| `SUPER + SHIFT + W` | Wallpaper Picker |
| `SUPER + T` | Theme Switcher (9 themes) |
| `SUPER + SHIFT + T` | Terminal Style Switcher (6 styles) |
| `SUPER + O` | Opacity Control (8 presets) |
| `SUPER + H` | Keybind Help Cheat Sheet |
| `SUPER + .` | Emoji Picker |
| `SUPER + SHIFT + C` | Color Picker (Hyprpicker) |

### Window Management

| Keybind | Action |
|---------|--------|
| `SUPER + Q` | Close active window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + SHIFT + F` | Toggle fake fullscreen |
| `SUPER + Space` | Toggle floating |
| `SUPER + P` | Toggle pseudo-tiling |
| `SUPER + S` | Toggle split direction |
| `SUPER + C` | Center floating window |
| `SUPER + G` | Toggle window group |
| `SUPER + Tab` | Next window in group |
| `ALT + Tab` | Cycle windows (forward) |
| `ALT + SHIFT + Tab` | Cycle windows (reverse) |

### Navigation

| Keybind | Action |
|---------|--------|
| `SUPER + H / J / K / L` | Focus left / down / up / right |
| `SUPER + Arrow Keys` | Focus direction (arrow keys) |
| `SUPER + SHIFT + H / J / K / L` | Move window |
| `SUPER + SHIFT + Arrow Keys` | Move window (arrow keys) |
| `SUPER + CTRL + H / J / K / L` | Resize window |
| `SUPER + CTRL + Arrow Keys` | Resize window (arrow keys) |

### Workspaces

| Keybind | Action |
|---------|--------|
| `SUPER + 1-9` (AZERTY) | Switch to workspace 1--9 |
| `SUPER + SHIFT + 1-9` | Move window to workspace 1--9 |
| `SUPER + Mouse Scroll` | Scroll through workspaces |

### Scratchpads

| Keybind | Action |
|---------|--------|
| `` SUPER + ` `` | Toggle dropdown terminal |
| `SUPER + M` | Toggle music scratchpad |

### Screenshots

| Keybind | Action |
|---------|--------|
| `Print` | Fullscreen screenshot (opens editor) |
| `SUPER + Print` | Region selection (opens editor) |
| `SUPER + SHIFT + Print` | Active window screenshot |
| `SUPER + ALT + Print` | Region selection (clipboard only) |

### Media and Hardware

| Keybind | Action |
|---------|--------|
| `Volume Up / Down` | Volume control (with OSD notification) |
| `Volume Mute` | Toggle mute |
| `Brightness Up / Down` | Screen brightness (with OSD notification) |
| `Media Play` | Play / Pause |
| `Media Next / Prev` | Next / Previous track |

### Session

| Keybind | Action |
|---------|--------|
| `SUPER + X` | Lock screen (Hyprlock) |
| `SUPER + SHIFT + X` | Power menu (Wlogout) |
| `SUPER + SHIFT + Q` | Exit Hyprland |
| `SUPER + SHIFT + R` | Reload Hyprland config |

### Mouse

| Keybind | Action |
|---------|--------|
| `SUPER + Left Click Drag` | Move window |
| `SUPER + Right Click Drag` | Resize window |

---

## Color Palette

The default palette is **Tokyo Night Storm**, applied consistently across every component.

| Role | Name | Hex | Preview |
|------|------|-----|---------|
| Background | Storm | `#1a1b26` | ![#1a1b26](https://via.placeholder.com/16/1a1b26/1a1b26.png) |
| Dark Background | Night | `#16161e` | ![#16161e](https://via.placeholder.com/16/16161e/16161e.png) |
| Surface | Float | `#1f2335` | ![#1f2335](https://via.placeholder.com/16/1f2335/1f2335.png) |
| Elevated Surface | Highlight | `#24283b` | ![#24283b](https://via.placeholder.com/16/24283b/24283b.png) |
| Border | Edge | `#292e42` | ![#292e42](https://via.placeholder.com/16/292e42/292e42.png) |
| Foreground | Text | `#c0caf5` | ![#c0caf5](https://via.placeholder.com/16/c0caf5/c0caf5.png) |
| Secondary Text | Dim | `#a9b1d6` | ![#a9b1d6](https://via.placeholder.com/16/a9b1d6/a9b1d6.png) |
| Muted | Comment | `#545c7e` | ![#545c7e](https://via.placeholder.com/16/545c7e/545c7e.png) |
| Primary Accent | Blue | `#7aa2f7` | ![#7aa2f7](https://via.placeholder.com/16/7aa2f7/7aa2f7.png) |
| Secondary Accent | Purple | `#bb9af7` | ![#bb9af7](https://via.placeholder.com/16/bb9af7/bb9af7.png) |
| Tertiary Accent | Cyan | `#7dcfff` | ![#7dcfff](https://via.placeholder.com/16/7dcfff/7dcfff.png) |
| Success | Green | `#9ece6a` | ![#9ece6a](https://via.placeholder.com/16/9ece6a/9ece6a.png) |
| Error | Red | `#f7768e` | ![#f7768e](https://via.placeholder.com/16/f7768e/f7768e.png) |
| Warning | Yellow | `#e0af68` | ![#e0af68](https://via.placeholder.com/16/e0af68/e0af68.png) |
| Accent | Orange | `#ff9e64` | ![#ff9e64](https://via.placeholder.com/16/ff9e64/ff9e64.png) |
| Highlight | Teal | `#73daca` | ![#73daca](https://via.placeholder.com/16/73daca/73daca.png) |

**Active border gradient:** `#7aa2f7` -> `#bb9af7` -> `#7dcfff` at 45 degrees.

---

## Installation

> **Requires**: Fedora 40+ with a working Wayland session. The installer handles everything else.

```bash
git clone https://github.com/YOUR_USERNAME/MyHyprlandConfig.git
cd MyHyprlandConfig
chmod +x install.sh
./install.sh
```

The installer will:

1. Back up your existing `~/.config` directories (timestamped backups)
2. Enable the [solopasha/hyprland](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/) COPR repository
3. Install all required packages via `dnf`
4. Download and install JetBrainsMono Nerd Font
5. Deploy Bibata-Modern-Classic cursor and Papirus-Dark icons
6. Symlink all config files to `~/.config/`
7. Configure GTK 2/3/4 and Qt 5/6 theming
8. Set up the default Tokyo Night theme

After installation, log out and select **Hyprland** from your display manager.

---

## Project Structure

```
MyHyprlandConfig/
|
|-- install.sh                          # Automated Fedora installer
|-- README.md
|-- LICENSE
|-- .gitignore
|
|-- themes/                             # 9 color theme definitions
|   |-- tokyo-night.conf                #   Default theme
|   |-- catppuccin-mocha.conf
|   |-- rose-pine.conf
|   |-- gruvbox.conf
|   |-- cyber.conf
|   |-- dracula.conf
|   |-- kanagawa.conf
|   |-- midnight.conf
|   '-- nord.conf
|
|-- config/
|   |-- hypr/                           # Hyprland compositor
|   |   |-- hyprland.conf               #   Main entry point (sources conf.d/)
|   |   |-- conf.d/                     #   8 modular config files
|   |   |   |-- monitors.conf           #     Monitor layout & EDID detection
|   |   |   |-- input.conf              #     Keyboard (AZERTY), touchpad, mouse
|   |   |   |-- keybinds.conf           #     All keyboard shortcuts
|   |   |   |-- decorations.conf        #     Borders, rounding, blur, shadows
|   |   |   |-- animations.conf         #     Bezier curves & transitions
|   |   |   |-- rules.conf              #     Window & layer rules
|   |   |   |-- autostart.conf          #     Startup applications
|   |   |   '-- environment.conf        #     Environment variables
|   |   '-- scripts/                    #   10 utility scripts
|   |       |-- theme-switch.sh         #     Live theme switcher (9 themes)
|   |       |-- terminal-style.sh       #     Terminal style switcher (6 styles)
|   |       |-- wallpaper.sh            #     Wallpaper cycling with awww
|   |       |-- wallpaper-picker.sh     #     Browse & pick wallpapers via Rofi
|   |       |-- opacity.sh             #     Window opacity control (8 presets)
|   |       |-- keybinds.sh             #     Keybind cheat sheet in Rofi
|   |       |-- screenshot.sh           #     Screenshot tool (4 modes)
|   |       |-- volume.sh              #     Volume control with OSD
|   |       |-- brightness.sh           #     Brightness control with OSD
|   |       '-- portal.sh              #     XDG portal restart
|   |
|   |-- waybar/                         # Status bar
|   |   |-- config.jsonc                #   Module layout, widgets
|   |   |-- style.css                   #   Floating pill design (themed)
|   |   |-- style-base.css              #   Base styles (theme-independent)
|   |   '-- scripts/
|   |       |-- weather.sh              #   Weather widget (wttr.in)
|   |       '-- updates.sh             #   Pending system updates counter
|   |
|   |-- rofi/                           # Application launcher
|   |   |-- config.rasi                 #   Main config
|   |   '-- themes/
|   |       |-- tokyo-night.rasi        #   Active theme (rewritten by switcher)
|   |       '-- tokyo-night-base.rasi   #   Base theme (theme-independent)
|   |
|   |-- swaync/                         # Notification center
|   |   |-- config.json                 #   Daemon settings
|   |   '-- style.css                   #   Themed styling
|   |
|   |-- kitty/                          # Terminal emulator
|   |   |-- kitty.conf                  #   Main config
|   |   |-- kitty-style.conf            #   Active visual style (symlinked)
|   |   '-- styles/                     #   6 terminal styles
|   |       |-- default.conf
|   |       |-- lofi.conf
|   |       |-- cyber.conf
|   |       |-- midnight.conf
|   |       |-- retro.conf
|   |       '-- minimal.conf
|   |
|   |-- nvim/                           # Neovim editor
|   |   |-- init.lua                    #   Entry point (lazy.nvim bootstrap)
|   |   '-- lua/
|   |       |-- core/
|   |       |   |-- options.lua         #     Editor settings
|   |       |   |-- keymaps.lua         #     Key mappings
|   |       |   '-- autocmds.lua        #     Autocommands
|   |       |-- plugins/
|   |       |   |-- colorschemes.lua    #     13 colorscheme plugins
|   |       |   |-- telescope.lua       #     Fuzzy finder
|   |       |   |-- completion.lua      #     nvim-cmp setup
|   |       |   |-- ui.lua              #     Lualine, indent, which-key
|   |       |   '-- editor.lua          #     Autopairs, comments, etc.
|   |       '-- themes/
|   |           '-- switcher.lua        #     Telescope theme picker
|   |
|   |-- hyprlock/hyprlock.conf          # Lock screen
|   |-- hypridle/hypridle.conf          # Idle management
|   |-- starship/starship.toml          # Shell prompt
|   |-- yazi/                           # TUI file manager
|   |   |-- yazi.toml                   #   Main config
|   |   |-- keymap.toml                 #   Custom keybinds
|   |   '-- theme.toml                  #   Themed colors
|   |-- btop/                           # System monitor
|   |   |-- btop.conf                   #   Settings
|   |   '-- themes/
|   |       '-- tokyo-night.theme       #   Custom theme
|   |-- wlogout/                        # Session / power menu
|   |   |-- layout                      #   Button layout
|   |   '-- style.css                   #   Themed styling
|   |-- firefox/chrome/
|   |   '-- userChrome.css              #   Browser chrome theming
|   |-- gtk-3.0/settings.ini            # GTK3 theming
|   |-- gtk-4.0/settings.ini            # GTK4 theming
|   |-- qt5ct/qt5ct.conf                # Qt5 theming
|   '-- qt6ct/qt6ct.conf                # Qt6 theming
|
|-- scripts/
|   '-- wallpaper-dl.sh                 # Download curated 4K wallpapers
|
'-- assets/
    '-- .gtkrc-2.0                      # GTK2 theme settings
```

---

## Customization

### Adding New Color Themes

Create a new file in `themes/` following the format of existing themes. Each theme file defines:

- Core palette (background, foreground, surface, border)
- Accent colors (blue, purple, cyan, green, red, etc.)
- Hyprland decoration values (border gradient, rounding, gaps, blur)
- Opacity settings
- Kitty terminal colors

The theme switcher script (`SUPER + T`) automatically discovers all `.conf` files in the `themes/` directory.

### Adding New Terminal Styles

Create a new `.conf` file in `config/kitty/styles/`. Each style defines font family, size, opacity, cursor shape, padding, and color overrides. The terminal style switcher (`SUPER + SHIFT + T`) automatically discovers all styles in this directory.

### Changing Keyboard Layout

Edit `config/hypr/conf.d/input.conf`:

```
input {
    kb_layout = us          # Change from "fr" to your layout
    kb_variant =            # Remove "azerty" if not needed
}
```

If switching away from AZERTY, also update the workspace keybinds in `config/hypr/conf.d/keybinds.conf` to use your layout's number row keys.

### Changing Monitor Configuration

Edit `config/hypr/conf.d/monitors.conf`. The config supports EDID-based detection for multi-monitor setups:

```
monitor = desc:LG Display 0x0000, preferred, 0x0, 1
monitor = desc:Dell Inc DELL U2720Q, preferred, 1920x0, 1.25
```

Run `hyprctl monitors` to see your available displays and their EDID descriptions.

### Weather Location

Edit `config/waybar/scripts/weather.sh` and update the city parameter:

```bash
CITY="Paris"    # Change to your city
```

### Adding Wallpapers

Place wallpaper images in `~/Pictures/Wallpapers/`. The wallpaper script (`SUPER + W`) cycles through all images in that directory with animated transitions.

You can also download curated wallpapers:

```bash
chmod +x scripts/wallpaper-dl.sh
./scripts/wallpaper-dl.sh
```

This downloads high-resolution wallpapers from wallhaven.cc into `~/Pictures/Wallpapers/`.

### Switching Animations

Edit `config/hypr/conf.d/animations.conf` to adjust bezier curves, animation speeds, and styles. Each animation type (windows, workspaces, fade, border) can be tuned independently.

---

## Dependencies

### Quick Install (Fedora)

The installer handles everything, but here is the full package list for manual installation:

```bash
# Enable COPR repository
sudo dnf copr enable -y solopasha/hyprland

# Core packages
sudo dnf install -y \
    hyprland hyprlock hypridle hyprpicker xdg-desktop-portal-hyprland \
    waybar rofi-wayland swaync libnotify \
    kitty neovim wlogout \
    wl-clipboard cliphist grim slurp swappy wf-recorder \
    pamixer playerctl pipewire pipewire-pulse wireplumber \
    brightnessctl \
    network-manager-applet blueman \
    polkit polkit-kde \
    btop ncdu fastfetch jq curl wget \
    thunar gvfs tumbler \
    qt5ct qt6ct \
    fontawesome-fonts jetbrains-mono-fonts \
    papirus-icon-theme \
    file-roller unzip
```

### Additional (manual install)

| Package | Source | Purpose |
|---------|--------|---------|
| awww | [Cargo / COPR](https://github.com/LGFae/swww) | Animated wallpaper daemon |
| Starship | [starship.rs](https://starship.rs) | Cross-shell prompt |
| Yazi | [GitHub](https://yazi-rs.github.io) | TUI file manager |
| JetBrainsMono Nerd Font | [Nerd Fonts](https://www.nerdfonts.com) | Terminal and UI font |
| Bibata-Modern-Classic | [GitHub](https://github.com/ful1e5/Bibata_Cursor) | Cursor theme |
| Tokyonight-Dark-BL (GTK) | [GitHub](https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme) | GTK theme |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Hyprland does not start | Check `journalctl --user -u hyprland` and ensure the COPR repo is enabled |
| Waybar not showing | Run `waybar` from a terminal to see errors; check `config.jsonc` syntax with `jq` |
| Rofi not launching | Ensure `rofi-wayland` is installed (not the X11 version) |
| No wallpaper | Verify `awww-daemon` is running (`awww query`); check wallpaper path exists |
| Screen will not lock | Ensure `hyprlock` is installed and `hypridle` is running |
| No sound controls | Install `pamixer` and `playerctl` |
| Fonts look wrong | Run `fc-cache -fv` after installing fonts; log out and back in |
| Portal issues | Run `~/.config/hypr/scripts/portal.sh` or restart `xdg-desktop-portal-hyprland` |
| Theme switch incomplete | Check that `awww-daemon` is running; verify theme file exists in `themes/` |
| Neovim plugins missing | Open Neovim and run `:Lazy sync` to install all plugins |
| Waybar weather empty | Edit `config/waybar/scripts/weather.sh` and set your city; check internet connection |

---

## Credits

### Color Schemes

- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) by enkia
- [Catppuccin](https://github.com/catppuccin) community
- [Rose Pine](https://github.com/rose-pine) community
- [Gruvbox](https://github.com/morhetz/gruvbox) by morhetz
- [Dracula](https://github.com/dracula/dracula-theme) community
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim) by rebelot
- [Nord](https://github.com/nordtheme) community

### Tools and Resources

- [Hyprland](https://hyprland.org) by vaxry
- [Nerd Fonts](https://www.nerdfonts.com) by Ryan L McIntyre
- [Papirus Icons](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- [Bibata Cursors](https://github.com/ful1e5/Bibata_Cursor) by Abdulkaiz Khatri

---

## Contributing

Contributions are welcome! If you would like to improve this rice:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-improvement`)
3. Commit your changes (`git commit -m 'Add some improvement'`)
4. Push to the branch (`git push origin feature/my-improvement`)
5. Open a Pull Request

When adding a new color theme, ensure it defines the full palette and that all components render correctly with it. When modifying shared components (Waybar, Rofi), verify that all 9 themes still display correctly.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

<div align="center">

**[Back to top](#tokyo-night----hyprland-rice)**

Built with care on Fedora Linux.

</div>
