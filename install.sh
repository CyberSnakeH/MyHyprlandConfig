#!/usr/bin/env bash
# =====================================================================
#  Tokyo Night -- Hyprland Rice Installer
#  Fedora  |  r/unixporn ready  |  by CyberSnake
#
#  Lightweight orchestrator: configs are pre-built in config/
#  and deployed (copied) to ~/.config/ by this script.
#
#  Installs and configures:
#    Hyprland  Waybar  Rofi  Kitty  SwayNC  Hyprlock  Hypridle
#    Starship  Yazi  btop  Firefox userChrome
#    GTK/Qt Tokyo Night  Bibata Cursor  Papirus Icons
#    awww  Wlogout  cliphist
#
#  Usage:  chmod +x install.sh && ./install.sh
# =====================================================================

set -euo pipefail

# ── Script directory (where configs live) ────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="${SCRIPT_DIR}/config"
ASSETS_SRC="${SCRIPT_DIR}/assets"

# ── Colors for logging ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

log_step()  { echo -e "\n${BOLD}${BLUE}==> ${RESET}${BOLD}$1${RESET}"; }
log_ok()    { echo -e "  ${GREEN}+${RESET} $1"; }
log_warn()  { echo -e "  ${YELLOW}!${RESET} $1"; }
log_info()  { echo -e "  ${CYAN}->${RESET} $1"; }
log_error() { echo -e "  ${RED}x${RESET} $1"; }

# =====================================================================
#  BANNER
# =====================================================================
banner() {
    echo -e "${PURPLE}"
    cat << 'BANNER'

  ████████╗ ██████╗ ██╗  ██╗██╗   ██╗ ██████╗
     ██╔══╝██╔═══██╗██║ ██╔╝╚██╗ ██╔╝██╔═══██╗
     ██║   ██║   ██║█████╔╝  ╚████╔╝ ██║   ██║
     ██║   ██║   ██║██╔═██╗   ╚██╔╝  ██║   ██║
     ██║   ╚██████╔╝██║  ██╗   ██║   ╚██████╔╝
     ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝
              ███╗   ██╗██╗ ██████╗ ██╗  ██╗████████╗
              ████╗  ██║██║██╔════╝ ██║  ██║╚══██╔══╝
              ██╔██╗ ██║██║██║  ███╗███████║   ██║
              ██║╚██╗██║██║██║   ██║██╔══██║   ██║
              ██║ ╚████║██║╚██████╔╝██║  ██║   ██║
              ╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝

BANNER
    echo -e "${RESET}"
    echo -e "  ${DIM}Hyprland Full Rice -- Fedora${RESET}"
    echo -e "  ${DIM}github.com/CyberSnakeLinux${RESET}"
    echo ""
}

# =====================================================================
#  1. PREREQUISITE CHECKS
# =====================================================================
check_fedora() {
    if [[ ! -f /etc/os-release ]]; then
        log_error "File /etc/os-release not found."
        exit 1
    fi
    if ! grep -qi "fedora" /etc/os-release; then
        log_error "This script is designed for Fedora only."
        exit 1
    fi
    local version_id
    version_id=$(grep -oP 'VERSION_ID=\K[0-9]+' /etc/os-release)
    log_ok "Fedora ${version_id} detected"
}

check_not_root() {
    if [[ "${EUID}" -eq 0 ]]; then
        log_error "Do not run as root. Use your normal user (sudo will be requested when needed)."
        exit 1
    fi
    log_ok "User: $(whoami)"
}

confirm() {
    echo -e "\n${YELLOW}This script will:${RESET}"
    echo -e "  ${CYAN}1.${RESET} Back up your existing configs to ~/rice-backup-DATE/"
    echo -e "  ${CYAN}2.${RESET} Install required packages via dnf"
    echo -e "  ${CYAN}3.${RESET} Deploy configuration files for Tokyo Night"
    echo -e "  ${CYAN}4.${RESET} Configure fonts, cursor, GTK/Qt themes"
    echo -e "  ${CYAN}5.${RESET} Auto-detect your monitors"
    echo ""
    read -rp "Continue? [y/N] " answer
    if [[ ! "${answer}" =~ ^[yY]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
}

# =====================================================================
#  2. BACKUP
# =====================================================================
do_backup() {
    log_step "Backing up existing configuration"

    local backup_dir="${HOME}/rice-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "${backup_dir}"

    local -a targets=(
        hypr waybar rofi kitty swaync wlogout btop yazi
        gtk-3.0 gtk-4.0 qt5ct qt6ct
    )

    local count=0
    for dir in "${targets[@]}"; do
        if [[ -d "${HOME}/.config/${dir}" ]]; then
            cp -r "${HOME}/.config/${dir}" "${backup_dir}/"
            log_ok "Backed up: ~/.config/${dir}"
            (( count++ )) || true
        fi
    done

    # Standalone files
    if [[ -f "${HOME}/.config/starship.toml" ]]; then
        cp "${HOME}/.config/starship.toml" "${backup_dir}/"
        log_ok "Backed up: starship.toml"
        (( count++ )) || true
    fi
    if [[ -f "${HOME}/.gtkrc-2.0" ]]; then
        cp "${HOME}/.gtkrc-2.0" "${backup_dir}/"
        log_ok "Backed up: .gtkrc-2.0"
        (( count++ )) || true
    fi

    if [[ ${count} -eq 0 ]]; then
        log_info "No existing config to back up"
    else
        log_ok "Backup saved to: ${backup_dir} (${count} items)"
    fi
}

# =====================================================================
#  3. PACKAGES
# =====================================================================
install_packages() {
    log_step "Installing Fedora packages"

    # Enable COPR for latest Hyprland builds
    log_info "Enabling COPR solopasha/hyprland..."
    sudo dnf copr enable -y solopasha/hyprland 2>/dev/null || log_warn "COPR already enabled or unavailable"

    # awww (animated wallpaper daemon, swww fork) lives in its own COPR
    log_info "Enabling COPR scottames/awww..."
    sudo dnf copr enable -y scottames/awww 2>/dev/null || log_warn "COPR already enabled or unavailable"

    # System upgrade
    log_info "Updating system..."
    sudo dnf upgrade -y --quiet 2>/dev/null || log_warn "Partial update"

    local -a pkgs=(
        # Hyprland ecosystem
        hyprland hyprlock hypridle hyprpicker
        xdg-desktop-portal-hyprland

        # Bar, launcher, notifications
        waybar rofi-wayland SwayNotificationCenter libnotify

        # Terminal
        kitty

        # Wallpaper engine (animated transitions)
        awww

        # Wayland utilities
        wl-clipboard cliphist grim slurp swappy wf-recorder

        # Audio and media
        pamixer playerctl
        pipewire pipewire-pulse pipewire-alsa wireplumber

        # Network and Bluetooth
        network-manager-applet blueman nm-connection-editor

        # Authentication agent
        polkit polkit-gnome

        # System tools
        btop ncdu fastfetch file-roller unzip jq

        # File manager
        thunar gvfs tumbler

        # Qt theming
        qt5ct qt6ct

        # Fonts
        fontawesome-fonts jetbrains-mono-fonts

        # Build tools (for manual compilations)
        git curl wget cargo golang

        # Power menu and icons
        wlogout papirus-icon-theme

        # Backlight control
        brightnessctl

        # GTK theme build dependencies
        sassc gtk-murrine-engine gnome-themes-extra
    )

    log_info "Installing packages (${#pkgs[@]} packages)..."
    # Use --skip-unavailable to handle packages not in repos gracefully
    if sudo dnf install -y --quiet --skip-unavailable "${pkgs[@]}" 2>/dev/null; then
        log_ok "Packages installed"
    else
        # Fallback: install one-by-one to identify failures
        log_warn "Some packages failed, trying individually..."
        local failed=0
        for pkg in "${pkgs[@]}"; do
            if ! rpm -q "${pkg}" &>/dev/null; then
                if ! sudo dnf install -y --quiet "${pkg}" 2>/dev/null; then
                    log_warn "Package unavailable: ${pkg}"
                    (( failed++ )) || true
                fi
            fi
        done
        if [[ ${failed} -gt 0 ]]; then
            log_warn "${failed} package(s) not installed (check manually)"
        else
            log_ok "All packages installed"
        fi
    fi
}

# =====================================================================
#  4. FONTS
# =====================================================================
install_fonts() {
    log_step "Installing fonts"

    local font_dir="${HOME}/.local/share/fonts"
    mkdir -p "${font_dir}"

    # JetBrainsMono Nerd Font
    if ! fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
        log_info "Downloading JetBrainsMono Nerd Font..."
        local tmp_font
        tmp_font=$(mktemp -d)
        if wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
                -O "${tmp_font}/JBM.zip"; then
            unzip -qo "${tmp_font}/JBM.zip" -d "${font_dir}/JetBrainsMonoNF"
            log_ok "JetBrainsMono Nerd Font installed"
        else
            log_warn "Failed to download JetBrainsMono Nerd Font"
        fi
        rm -rf "${tmp_font}"
    else
        log_ok "JetBrainsMono Nerd Font already present"
    fi

    # Rebuild font cache
    fc-cache -f 2>/dev/null
    log_ok "Font cache updated"
}

# =====================================================================
#  5. CURSOR
# =====================================================================
install_cursor() {
    log_step "Installing cursor Bibata Modern Classic"

    local cursor_dir="${HOME}/.local/share/icons"
    mkdir -p "${cursor_dir}"

    if [[ ! -d "${cursor_dir}/Bibata-Modern-Classic" ]]; then
        log_info "Downloading Bibata-Modern-Classic..."
        local tmp_cur
        tmp_cur=$(mktemp -d)
        if wget -q "https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.xz" \
                -O "${tmp_cur}/bibata.tar.xz"; then
            tar -xf "${tmp_cur}/bibata.tar.xz" -C "${cursor_dir}/"
            log_ok "Bibata cursor installed"
        else
            log_warn "Failed to download cursor"
        fi
        rm -rf "${tmp_cur}"
    else
        log_ok "Bibata cursor already present"
    fi

    # Set as default cursor via index.theme
    mkdir -p "${HOME}/.icons/default"
    cat > "${HOME}/.icons/default/index.theme" << 'EOF'
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Bibata-Modern-Classic
EOF
    log_ok "Default cursor configured"
}

# =====================================================================
#  6. GTK THEME
# =====================================================================
install_gtk_theme() {
    log_step "Installing GTK theme Tokyo Night"

    local themes_dir="${HOME}/.local/share/themes"
    mkdir -p "${themes_dir}"

    if [[ ! -d "${themes_dir}/Tokyonight-Dark" ]] && [[ ! -d "${themes_dir}/Tokyonight-Dark-BL" ]]; then
        log_info "Downloading Tokyo Night GTK theme..."
        local tmp_gtk
        tmp_gtk=$(mktemp -d)

        if git clone --quiet --depth=1 \
                https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme.git \
                "${tmp_gtk}/tokyonight"; then

            # Look for install.sh in the cloned repo
            local install_sh=""
            install_sh=$(find "${tmp_gtk}/tokyonight" -maxdepth 3 -name "install.sh" -type f | head -1)

            if [[ -n "${install_sh}" ]]; then
                log_info "install.sh found, running..."
                chmod +x "${install_sh}"
                local install_dir
                install_dir=$(dirname "${install_sh}")
                (cd "${install_dir}" && ./install.sh -d "${themes_dir}" -c dark -t default 2>&1 | tail -5)
                log_ok "Theme installed via install.sh"
            else
                # Fallback: copy directories containing gtk-3.0
                log_warn "install.sh not found -- copying themes directly..."
                while IFS= read -r -d '' gtk3_dir; do
                    local theme_dir theme_name
                    theme_dir=$(dirname "${gtk3_dir}")
                    theme_name=$(basename "${theme_dir}")
                    if [[ "${theme_name}" =~ ^(main|src|master)$ ]]; then
                        cp -r "${theme_dir}" "${themes_dir}/Tokyonight-Dark"
                        log_ok "Theme copied: ${theme_name} -> Tokyonight-Dark"
                    else
                        cp -r "${theme_dir}" "${themes_dir}/"
                        log_ok "Theme copied: ${theme_name}"
                    fi
                done < <(find "${tmp_gtk}/tokyonight" -name "gtk-3.0" -type d -print0 2>/dev/null)
            fi

            # Create Tokyonight-Dark-BL symlink if missing
            if [[ ! -d "${themes_dir}/Tokyonight-Dark-BL" ]]; then
                local first_tn
                first_tn=$(find "${themes_dir}" -maxdepth 1 -type d -iname "*tokyonight*dark*" | sort | head -1)
                if [[ -n "${first_tn}" ]]; then
                    ln -sfn "${first_tn}" "${themes_dir}/Tokyonight-Dark-BL"
                    log_ok "Symlink: Tokyonight-Dark-BL -> $(basename "${first_tn}")"
                else
                    log_warn "No Tokyo Night theme found after installation"
                fi
            fi
        else
            log_warn "Failed to clone Tokyo Night GTK repository"
        fi

        rm -rf "${tmp_gtk}"
    else
        log_ok "Tokyo Night GTK theme already present"
    fi

    # Deploy GTK / Qt settings from repo
    log_info "Deploying GTK and Qt configs..."

    mkdir -p "${HOME}/.config/gtk-3.0" \
             "${HOME}/.config/gtk-4.0" \
             "${HOME}/.config/qt5ct"   \
             "${HOME}/.config/qt6ct"

    cp "${CONFIG_SRC}/gtk-3.0/settings.ini" "${HOME}/.config/gtk-3.0/"
    cp "${CONFIG_SRC}/gtk-4.0/settings.ini" "${HOME}/.config/gtk-4.0/"
    cp "${CONFIG_SRC}/qt5ct/qt5ct.conf"     "${HOME}/.config/qt5ct/"
    cp "${CONFIG_SRC}/qt6ct/qt6ct.conf"     "${HOME}/.config/qt6ct/"
    cp "${ASSETS_SRC}/.gtkrc-2.0"           "${HOME}/"

    log_ok "GTK 2/3/4 and Qt5ct/Qt6ct configured"
}

# =====================================================================
#  7. DEPLOY CONFIGS (core function)
# =====================================================================
deploy_configs() {
    log_step "Deploying configuration files"

    # Create all target directories
    mkdir -p "${HOME}/.config/hypr/conf.d"       \
             "${HOME}/.config/hypr/scripts"       \
             "${HOME}/.config/hypr/themes"        \
             "${HOME}/.config/waybar/scripts"     \
             "${HOME}/.config/rofi/themes"        \
             "${HOME}/.config/swaync"             \
             "${HOME}/.config/kitty"              \
             "${HOME}/.config/yazi"               \
             "${HOME}/.config/btop/themes"        \
             "${HOME}/.config/wlogout"            \
             "${HOME}/Pictures/Screenshots"       \
             "${HOME}/Pictures/Wallpapers"

    # ── Hyprland core ────────────────────────────────────────────────
    cp "${CONFIG_SRC}/hypr/hyprland.conf" "${HOME}/.config/hypr/"
    log_ok "hyprland.conf"

    # Modular configs (conf.d/)
    local conf_count=0
    for conf_file in "${CONFIG_SRC}/hypr/conf.d/"*.conf; do
        [[ ! -f "${conf_file}" ]] && continue
        cp "${conf_file}" "${HOME}/.config/hypr/conf.d/"
        (( conf_count++ )) || true
    done
    log_ok "conf.d/ (${conf_count} modular files)"

    # Hyprland scripts
    for script in "${CONFIG_SRC}/hypr/scripts/"*.sh; do
        [[ ! -f "${script}" ]] && continue
        cp "${script}" "${HOME}/.config/hypr/scripts/"
    done
    chmod +x "${HOME}/.config/hypr/scripts/"*.sh 2>/dev/null || true
    log_ok "hypr/scripts/ (executables)"

    # Theme definitions
    if [[ -d "${SCRIPT_DIR}/themes" ]]; then
        cp "${SCRIPT_DIR}/themes/"*.conf "${HOME}/.config/hypr/themes/"
        log_ok "hypr/themes/ (theme definitions)"
    fi

    # Waybar style-base (for theme switcher)
    if [[ -f "${CONFIG_SRC}/waybar/style-base.css" ]]; then
        cp "${CONFIG_SRC}/waybar/style-base.css" "${HOME}/.config/waybar/"
    fi

    # ── Waybar ───────────────────────────────────────────────────────
    # Waybar expects "config" (no extension) or "config.jsonc"
    if [[ -f "${CONFIG_SRC}/waybar/config.jsonc" ]]; then
        cp "${CONFIG_SRC}/waybar/config.jsonc" "${HOME}/.config/waybar/config"
    fi
    cp "${CONFIG_SRC}/waybar/style.css" "${HOME}/.config/waybar/"
    for script in "${CONFIG_SRC}/waybar/scripts/"*.sh; do
        [[ ! -f "${script}" ]] && continue
        cp "${script}" "${HOME}/.config/waybar/scripts/"
    done
    chmod +x "${HOME}/.config/waybar/scripts/"*.sh 2>/dev/null || true
    log_ok "waybar/ (config + style + scripts)"

    # ── Rofi ─────────────────────────────────────────────────────────
    cp "${CONFIG_SRC}/rofi/config.rasi" "${HOME}/.config/rofi/"
    for theme in "${CONFIG_SRC}/rofi/themes/"*.rasi; do
        [[ ! -f "${theme}" ]] && continue
        cp "${theme}" "${HOME}/.config/rofi/themes/"
    done
    log_ok "rofi/ (config + themes)"

    # ── SwayNC ───────────────────────────────────────────────────────
    for file in "${CONFIG_SRC}/swaync/"*; do
        [[ ! -f "${file}" ]] && continue
        cp "${file}" "${HOME}/.config/swaync/"
    done
    log_ok "swaync/ (config + style)"

    # ── Hyprlock + Hypridle ──────────────────────────────────────────
    cp "${CONFIG_SRC}/hyprlock/hyprlock.conf" "${HOME}/.config/hypr/"
    cp "${CONFIG_SRC}/hypridle/hypridle.conf" "${HOME}/.config/hypr/"
    log_ok "hyprlock.conf + hypridle.conf"

    # ── Kitty + styles ─────────────────────────────────────────────────
    mkdir -p "${HOME}/.config/kitty/styles"
    cp "${CONFIG_SRC}/kitty/kitty.conf" "${HOME}/.config/kitty/"
    cp "${CONFIG_SRC}/kitty/kitty-style.conf" "${HOME}/.config/kitty/"
    for style in "${CONFIG_SRC}/kitty/styles/"*.conf; do
        [[ ! -f "${style}" ]] && continue
        cp "${style}" "${HOME}/.config/kitty/styles/"
    done
    log_ok "kitty/ (config + 6 terminal styles)"

    # ── Starship ─────────────────────────────────────────────────────
    cp "${CONFIG_SRC}/starship/starship.toml" "${HOME}/.config/starship.toml"
    log_ok "starship.toml"

    # ── Yazi ─────────────────────────────────────────────────────────
    for toml in "${CONFIG_SRC}/yazi/"*.toml; do
        [[ ! -f "${toml}" ]] && continue
        cp "${toml}" "${HOME}/.config/yazi/"
    done
    log_ok "yazi/ (config + theme + keymap)"

    # ── Neovim ──────────────────────────────────────────────────────
    if [[ -d "${CONFIG_SRC}/nvim" ]]; then
        mkdir -p "${HOME}/.config/nvim/lua/core" \
                 "${HOME}/.config/nvim/lua/plugins" \
                 "${HOME}/.config/nvim/lua/themes"
        cp "${CONFIG_SRC}/nvim/init.lua" "${HOME}/.config/nvim/"
        cp "${CONFIG_SRC}/nvim/lua/core/"*.lua "${HOME}/.config/nvim/lua/core/"
        cp "${CONFIG_SRC}/nvim/lua/plugins/"*.lua "${HOME}/.config/nvim/lua/plugins/"
        cp "${CONFIG_SRC}/nvim/lua/themes/"*.lua "${HOME}/.config/nvim/lua/themes/"
        log_ok "nvim/ (config + plugins + 13 themes)"
    fi

    # ── Fastfetch ───────────────────────────────────────────────────
    if [[ -d "${CONFIG_SRC}/fastfetch" ]]; then
        mkdir -p "${HOME}/.config/fastfetch"
        cp "${CONFIG_SRC}/fastfetch/"* "${HOME}/.config/fastfetch/"
        log_ok "fastfetch/ (config + logo)"
    fi

    # ── Cava ────────────────────────────────────────────────────────
    if [[ -d "${CONFIG_SRC}/cava" ]]; then
        mkdir -p "${HOME}/.config/cava"
        cp "${CONFIG_SRC}/cava/"* "${HOME}/.config/cava/"
        log_ok "cava/ (audio visualizer config)"
    fi

    # ── Wallpaper directories ───────────────────────────────────────
    mkdir -p "${HOME}/Pictures/Wallpapers/"{tokyo-night,catppuccin,rose-pine,gruvbox,cyber,dracula,kanagawa,midnight,nord,lofi,sexy}
    log_ok "Wallpaper directories created"

    # ── btop ─────────────────────────────────────────────────────────
    cp "${CONFIG_SRC}/btop/btop.conf" "${HOME}/.config/btop/"
    for theme in "${CONFIG_SRC}/btop/themes/"*.theme; do
        [[ ! -f "${theme}" ]] && continue
        cp "${theme}" "${HOME}/.config/btop/themes/"
    done
    log_ok "btop/ (config + tokyo-night theme)"

    # ── Wlogout ──────────────────────────────────────────────────────
    for file in "${CONFIG_SRC}/wlogout/"*; do
        [[ ! -f "${file}" ]] && continue
        cp "${file}" "${HOME}/.config/wlogout/"
    done
    log_ok "wlogout/ (layout + style)"

    log_ok "All configuration files deployed"
}

# =====================================================================
#  8. MONITOR DETECTION (EDID)
# =====================================================================

# Parse EDID binary data via Python to extract optimal (resolution, refresh)
_parse_edid_python() {
    local edid_path="$1"
    [[ ! -s "${edid_path}" ]] && return 1

    python3 - "${edid_path}" << 'PYEOF'
import sys, struct

def parse_edid(path):
    try:
        raw = open(path, 'rb').read()
    except Exception:
        return None

    if len(raw) < 128:
        return None
    # EDID magic header check
    if raw[0:8] != b'\x00\xff\xff\xff\xff\xff\xff\x00':
        return None

    modes = []

    # -- Established timings (bytes 35-37) --
    EST = [
        (720,400,70),(720,400,88),(640,480,60),(640,480,67),
        (640,480,72),(640,480,75),(800,600,56),(800,600,60),
        (800,600,72),(800,600,75),(832,624,75),(1024,768,87),
        (1024,768,60),(1024,768,70),(1024,768,75),(1280,1024,75),
    ]
    for i, (w, h, r) in enumerate(EST):
        byte_idx = 35 + i // 8
        bit_idx  = 7 - (i % 8)
        if raw[byte_idx] & (1 << bit_idx):
            modes.append((w, h, r))

    # -- Standard timings (bytes 38-53, 8 pairs) --
    AR_MAP = {0b00: (16,10), 0b01: (4,3), 0b10: (5,4), 0b11: (16,9)}
    for i in range(8):
        b1 = raw[38 + i*2]
        b2 = raw[39 + i*2]
        if b1 == 0x01 and b2 == 0x01:
            continue
        w   = (b1 + 31) * 8
        ar  = (b2 >> 6) & 0x3
        ref = (b2 & 0x3F) + 60
        ratio = AR_MAP.get(ar, (16,9))
        h = w * ratio[1] // ratio[0]
        modes.append((w, h, ref))

    # -- Detailed timing descriptors (bytes 54-125, 4 x 18 bytes) --
    for i in range(4):
        off = 54 + i * 18
        block = raw[off:off+18]
        if len(block) < 18:
            continue
        # Pixel clock = 0 means descriptor, not timing
        pclk = struct.unpack_from('<H', block, 0)[0]
        if pclk == 0:
            continue
        ha = block[2] | ((block[4] >> 4) << 8)
        va = block[5] | ((block[7] >> 4) << 8)
        if ha == 0 or va == 0:
            continue
        hbl = block[3] | ((block[4] & 0x0F) << 8)
        vbl = block[6] | ((block[7] & 0x0F) << 8)
        htotal = ha + hbl
        vtotal = va + vbl
        if htotal == 0 or vtotal == 0:
            continue
        refresh = round((pclk * 10000) / (htotal * vtotal))
        if 23 < refresh < 250 and ha > 200 and va > 200:
            modes.append((ha, va, refresh))

    if not modes:
        return None

    # Sort by resolution descending, then refresh descending
    modes.sort(key=lambda m: (m[0]*m[1], m[2]), reverse=True)

    # Deduplicate: keep highest refresh per resolution
    seen = {}
    for w, h, r in modes:
        key = (w, h)
        if key not in seen or r > seen[key]:
            seen[key] = r

    best_w, best_h = max(seen.keys(), key=lambda k: k[0]*k[1])
    best_r = seen[(best_w, best_h)]

    # Snap refresh rate to nearest standard value (within 5 Hz)
    STD_HZ = [24, 25, 30, 48, 50, 60, 75, 100, 120, 144, 165, 180, 240, 360]
    closest = min(STD_HZ, key=lambda x: abs(x - best_r))
    if abs(closest - best_r) <= 5:
        best_r = closest

    print(f"{best_w}x{best_h}@{best_r}")

result = parse_edid(sys.argv[1])
PYEOF
}

# Determine recommended HiDPI scale based on resolution
_hidpi_scale() {
    local w="$1" h="$2"
    if (( w >= 3840 || h >= 2160 )); then
        echo "2"
    else
        echo "1"
    fi
}

# Determine scale for a connector (eDP = laptop, more likely HiDPI)
_scale_for_connector() {
    local connector="$1" w="$2" h="$3"
    local scale
    scale=$(_hidpi_scale "${w}" "${h}")
    # Laptop (eDP) at 2560+ wide: bump to 1.5
    if [[ "${connector}" == eDP* ]] && (( w >= 2560 )); then
        echo "1.5"
    else
        echo "${scale}"
    fi
}

detect_monitors() {
    log_step "Auto-detecting monitors"

    local mon_conf="${HOME}/.config/hypr/conf.d/monitors.conf"
    local drm_base="/sys/class/drm"

    # ── 1. List connected connectors ─────────────────────────────────
    declare -a connected_connectors=()
    for status_file in "${drm_base}"/card*-*/status; do
        [[ ! -f "${status_file}" ]] && continue
        [[ "$(cat "${status_file}" 2>/dev/null)" != "connected" ]] && continue
        local dir connector
        dir=$(dirname "${status_file}")
        # Extract connector name: card0-DP-1 -> DP-1
        connector=$(basename "${dir}" | sed 's/^card[0-9]*-//')
        connected_connectors+=("${connector}")
        log_info "Connector detected: ${BOLD}${connector}${RESET}"
    done

    if [[ ${#connected_connectors[@]} -eq 0 ]]; then
        log_warn "No DRM connector found -- fallback auto-detection Hyprland"
        cat > "${mon_conf}" << 'EOF'
# ======================================================================
# monitors.conf -- fallback (auto-detection Hyprland)
# /sys/class/drm inaccessible or no connectors found
# ======================================================================

monitor = , preferred, auto, 1
EOF
        return
    fi

    # ── 2. Detect resolution + refresh for each connector ────────────
    declare -A mon_mode mon_w mon_h mon_scale

    for connector in "${connected_connectors[@]}"; do
        local drm_dir="" edid_file="" modes_file=""
        for d in "${drm_base}"/card*-"${connector}"; do
            [[ -d "${d}" ]] && drm_dir="${d}" && break
        done

        if [[ -z "${drm_dir}" ]]; then
            log_warn "${connector}: DRM directory not found"
            mon_mode[${connector}]="preferred"
            mon_w[${connector}]=1920
            mon_h[${connector}]=1080
            mon_scale[${connector}]=1
            continue
        fi

        edid_file="${drm_dir}/edid"
        modes_file="${drm_dir}/modes"

        # Try 1: parse EDID with Python
        local detected=""
        if [[ -s "${edid_file}" ]]; then
            detected=$(_parse_edid_python "${edid_file}" 2>/dev/null || true)
        fi

        # Try 2: read modes file (list of supported modes)
        if [[ -z "${detected}" ]] && [[ -s "${modes_file}" ]]; then
            local best_res
            best_res=$(head -1 "${modes_file}" 2>/dev/null | tr -d '[:space:]')
            if [[ -n "${best_res}" ]] && [[ "${best_res}" =~ ^[0-9]+x[0-9]+$ ]]; then
                local rw rh
                rw="${best_res%x*}"
                rh="${best_res#*x}"
                detected="${best_res}@60"
                log_warn "${connector}: EDID unreadable, modes file -> ${detected}"
            fi
        fi

        # Try 3: fallback to preferred
        if [[ -z "${detected}" ]]; then
            log_warn "${connector}: no info -- fallback 'preferred'"
            mon_mode[${connector}]="preferred"
            mon_w[${connector}]=1920
            mon_h[${connector}]=1080
            mon_scale[${connector}]=1
            continue
        fi

        # Parse WxH@RR from detected string
        local w h rr
        w=$(echo "${detected}"  | grep -oP '^\d+')
        h=$(echo "${detected}"  | grep -oP 'x\K\d+')
        rr=$(echo "${detected}" | grep -oP '@\K\d+')
        [[ -z "${w}" ]]  && w=1920
        [[ -z "${h}" ]]  && h=1080
        [[ -z "${rr}" ]] && rr=60

        local scale
        scale=$(_scale_for_connector "${connector}" "${w}" "${h}")

        mon_mode[${connector}]="${w}x${h}@${rr}"
        mon_w[${connector}]=${w}
        mon_h[${connector}]=${h}
        mon_scale[${connector}]=${scale}

        log_ok "${connector} -> ${BOLD}${w}x${h}@${rr}Hz${RESET}  scale=${scale}"
    done

    # ── 3. Calculate positions (horizontal layout, left to right) ────
    # eDP (laptop) first, then others sorted alphabetically
    declare -a sorted_connectors=()
    local -a edp_conn=() other_conn=()
    for c in "${connected_connectors[@]}"; do
        if [[ "${c}" == eDP* ]]; then
            edp_conn+=("${c}")
        else
            other_conn+=("${c}")
        fi
    done
    sorted_connectors=("${edp_conn[@]}" "${other_conn[@]}")

    declare -A mon_x mon_y
    local offset_x=0
    for c in "${sorted_connectors[@]}"; do
        mon_x[${c}]=${offset_x}
        mon_y[${c}]=0
        local eff_w
        # Effective width = physical resolution / scale
        eff_w=$(python3 -c "print(int(${mon_w[${c}]} / ${mon_scale[${c}]}))" 2>/dev/null \
                || echo "${mon_w[${c}]}")
        offset_x=$(( offset_x + eff_w ))
    done

    # ── 4. Write monitors.conf ───────────────────────────────────────
    {
        echo "# ======================================================================"
        echo "# monitors.conf -- auto-generated $(date '+%Y-%m-%d %H:%M')"
        echo "# $(uname -r) | ${#connected_connectors[@]} monitor(s) detected"
        echo "# ======================================================================"
        echo ""

        local idx=0
        for c in "${sorted_connectors[@]}"; do
            local mode="${mon_mode[${c}]}"
            local x="${mon_x[${c}]}"
            local y="${mon_y[${c}]}"
            local scale="${mon_scale[${c}]}"

            echo "# -- Monitor $((idx+1)) : ${c} --"
            echo "monitor = ${c}, ${mode}, ${x}x${y}, ${scale}"
            echo ""
            (( idx++ )) || true
        done

        # Workspace mapping
        echo "# -- Workspace mapping --"
        if [[ ${#sorted_connectors[@]} -ge 2 ]]; then
            local primary="${sorted_connectors[0]}"
            local secondary="${sorted_connectors[1]}"
            echo "# Primary (${primary}) : workspaces 1-7"
            for i in 1 2 3 4 5 6 7; do
                if [[ ${i} -eq 1 ]]; then
                    echo "workspace = ${i}, monitor:${primary}, default:true"
                else
                    echo "workspace = ${i}, monitor:${primary}"
                fi
            done
            echo ""
            echo "# Secondary (${secondary}) : workspaces 8-9"
            echo "workspace = 8, monitor:${secondary}, default:true"
            echo "workspace = 9, monitor:${secondary}"
        else
            local primary="${sorted_connectors[0]}"
            for i in 1 2 3 4 5 6 7 8 9; do
                if [[ ${i} -eq 1 ]]; then
                    echo "workspace = ${i}, monitor:${primary}, default:true"
                else
                    echo "workspace = ${i}, monitor:${primary}"
                fi
            done
        fi

        echo ""
        echo "# Fallback for any unlisted connector"
        echo "monitor = , preferred, auto, 1"

    } > "${mon_conf}"

    log_ok "monitors.conf written -> ${mon_conf}"

    # ── 5. Summary ───────────────────────────────────────────────────
    echo ""
    echo -e "  ${BOLD}Detected monitors summary:${RESET}"
    for c in "${sorted_connectors[@]}"; do
        printf "  ${CYAN}%-16s${RESET}  %s  scale=%s  position=%sx%s\n" \
            "${c}" "${mon_mode[${c}]}" "${mon_scale[${c}]}" "${mon_x[${c}]}" "${mon_y[${c}]}"
    done
    echo ""
    log_info "You can edit ~/.config/hypr/conf.d/monitors.conf to fine-tune the layout"
}

# =====================================================================
#  9. STARSHIP
# =====================================================================
install_starship() {
    log_step "Installing Starship"

    if ! command -v starship &>/dev/null; then
        log_info "Downloading and installing Starship..."
        if curl -sS https://starship.rs/install.sh | sh -s -- --yes 2>/dev/null; then
            log_ok "Starship installed"
        else
            log_warn "Starship installation failed"
            return
        fi
    else
        log_ok "Starship already installed"
    fi

    # Add init to .bashrc if not present
    local bash_line='eval "$(starship init bash)"'
    if [[ -f "${HOME}/.bashrc" ]]; then
        grep -qxF "${bash_line}" "${HOME}/.bashrc" 2>/dev/null || \
            echo "${bash_line}" >> "${HOME}/.bashrc"
        log_ok "Starship added to .bashrc"
    fi

    # Add init to .zshrc if present
    local zsh_line='eval "$(starship init zsh)"'
    if [[ -f "${HOME}/.zshrc" ]]; then
        grep -qxF "${zsh_line}" "${HOME}/.zshrc" 2>/dev/null || \
            echo "${zsh_line}" >> "${HOME}/.zshrc"
        log_ok "Starship added to .zshrc"
    fi
}

# =====================================================================
#  10. YAZI
# =====================================================================
install_yazi() {
    log_step "Installing Yazi"

    if ! command -v yazi &>/dev/null; then
        log_info "Trying installation via DNF..."
        if sudo dnf install -y --quiet yazi 2>/dev/null; then
            log_ok "Yazi installed via DNF"
        else
            log_info "DNF failed, compiling via cargo..."
            sudo dnf install -y --quiet gcc make 2>/dev/null || true
            if command -v cargo &>/dev/null; then
                rustup update stable 2>/dev/null || true
                if cargo install --locked yazi-fm 2>&1 | tail -5; then
                    log_ok "Yazi compiled and installed via cargo"
                else
                    log_warn "Compilation failed"
                    log_info "Manual installation: https://yazi-rs.github.io/docs/installation"
                fi
            else
                log_warn "cargo missing -- install Rust first or download Yazi manually"
            fi
        fi
    else
        log_ok "Yazi already installed ($(yazi --version 2>/dev/null | head -1))"
    fi

    # Add y() shell function for directory changing on exit
    local yazi_func
    read -r -d '' yazi_func << 'FUNC' || true
# Yazi: change directory on exit
function y() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd" || return
    fi
    rm -f -- "$tmp"
}
FUNC

    if [[ -f "${HOME}/.bashrc" ]]; then
        if ! grep -q "yazi-cwd" "${HOME}/.bashrc" 2>/dev/null; then
            echo "" >> "${HOME}/.bashrc"
            echo "${yazi_func}" >> "${HOME}/.bashrc"
            log_ok "y() function added to .bashrc"
        fi
    fi

    if [[ -f "${HOME}/.zshrc" ]]; then
        if ! grep -q "yazi-cwd" "${HOME}/.zshrc" 2>/dev/null; then
            echo "" >> "${HOME}/.zshrc"
            echo "${yazi_func}" >> "${HOME}/.zshrc"
            log_ok "y() function added to .zshrc"
        fi
    fi
}

# =====================================================================
#  11. FIREFOX userChrome.css
# =====================================================================
install_firefox() {
    log_step "Configuring Firefox (userChrome.css)"

    local firefox_dir="${HOME}/.mozilla/firefox"
    local profile_dir=""

    if [[ ! -d "${firefox_dir}" ]]; then
        log_warn "Firefox not installed or never launched. Launch Firefox once then re-run this script."
        return
    fi

    # Search for profile: .default-release first, then .default
    profile_dir=$(find "${firefox_dir}" -maxdepth 1 -name "*.default-release" -type d 2>/dev/null | head -1)
    if [[ -z "${profile_dir}" ]]; then
        profile_dir=$(find "${firefox_dir}" -maxdepth 1 -name "*.default" -type d 2>/dev/null | head -1)
    fi

    if [[ -z "${profile_dir}" ]]; then
        log_warn "Firefox profile not found. Launch Firefox once then re-run this script."
        log_info "userChrome.css available in: ${CONFIG_SRC}/firefox/chrome/"
        return
    fi

    log_info "Profile detected: $(basename "${profile_dir}")"

    # Enable custom stylesheets in prefs.js
    local prefs="${profile_dir}/prefs.js"
    if [[ -f "${prefs}" ]]; then
        if ! grep -q "toolkit.legacyUserProfileCustomizations.stylesheets" "${prefs}" 2>/dev/null; then
            echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "${prefs}"
            log_ok "toolkit.legacyUserProfileCustomizations.stylesheets enabled"
        else
            log_ok "Custom stylesheets already enabled"
        fi
    else
        # Create user.js as alternative
        echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' > "${profile_dir}/user.js"
        log_ok "user.js created to enable stylesheets"
    fi

    # Deploy userChrome.css from repo
    mkdir -p "${profile_dir}/chrome"
    cp "${CONFIG_SRC}/firefox/chrome/userChrome.css" "${profile_dir}/chrome/"
    log_ok "userChrome.css deployed to Firefox profile"
}

# =====================================================================
#  12. FINALIZE
# =====================================================================
finalize() {
    log_step "Finalizing"

    # Create Wayland session entry for GDM/SDDM if missing
    if [[ ! -f "/usr/share/wayland-sessions/hyprland.desktop" ]]; then
        log_info "Creating Wayland session entry for GDM..."
        sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=Dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
        log_ok "Wayland GDM session created"
    else
        log_ok "Wayland GDM session already present"
    fi

    # Ensure ~/.local/bin is in PATH
    mkdir -p "${HOME}/.local/bin"
    if [[ -f "${HOME}/.bashrc" ]]; then
        if ! grep -q '\.local/bin' "${HOME}/.bashrc" 2>/dev/null; then
            echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> "${HOME}/.bashrc"
            log_ok "~/.local/bin added to PATH (.bashrc)"
        fi
    fi

    # Enable PipeWire user services
    systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
    log_ok "PipeWire enabled"

    # Wallpaper reminder
    log_warn "Place your wallpaper in ~/Pictures/Wallpapers/wallpaper.png"
    log_info "Recommended: wallhaven.cc -> color filter #1a1b26 (dark tokyo)"
}

# =====================================================================
#  13. SUMMARY
# =====================================================================
print_summary() {
    echo ""
    echo -e "${BOLD}${GREEN}+======================================================+${RESET}"
    echo -e "${BOLD}${GREEN}|  Installation complete! Tokyo Night is ready.        |${RESET}"
    echo -e "${BOLD}${GREEN}+======================================================+${RESET}"
    echo ""
    echo -e "${BOLD}Next steps:${RESET}"
    echo ""
    echo -e "  ${CYAN}1.${RESET} Wallpaper"
    echo -e "     Place an image in ${YELLOW}~/Pictures/Wallpapers/wallpaper.png${RESET}"
    echo -e "     ${DIM}wallhaven.cc | color filter #1a1b26${RESET}"
    echo ""
    echo -e "  ${CYAN}2.${RESET} Monitors"
    echo -e "     Check ${YELLOW}~/.config/hypr/conf.d/monitors.conf${RESET} (auto-generated)"
    echo -e "     ${DIM}hyprctl monitors -- to see exact names${RESET}"
    echo ""
    echo -e "  ${CYAN}3.${RESET} Weather (Waybar)"
    echo -e "     ${YELLOW}echo 'export WEATHER_LOCATION=\"Paris\"' >> ~/.bashrc${RESET}"
    echo ""
    echo -e "  ${CYAN}4.${RESET} Launch Hyprland"
    echo -e "     From GDM: select ${YELLOW}Hyprland${RESET} in the session menu"
    echo -e "     From TTY: type ${YELLOW}Hyprland${RESET}"
    echo ""
    echo -e "${BOLD}Essential keybindings:${RESET}"
    echo ""
    echo -e "  ${PURPLE}SUPER + Return${RESET}       Terminal (Kitty)"
    echo -e "  ${PURPLE}SUPER + R${RESET}            Launcher (Rofi)"
    echo -e "  ${PURPLE}SUPER + V${RESET}            Clipboard (cliphist)"
    echo -e "  ${PURPLE}SUPER + \`${RESET}            Scratchpad terminal"
    echo -e "  ${PURPLE}SUPER + CTRL + L${RESET}     Lock screen (Hyprlock)"
    echo -e "  ${PURPLE}SUPER + SHIFT + E${RESET}    Session menu (Wlogout)"
    echo -e "  ${PURPLE}SUPER + H/J/K/L${RESET}      Focus windows (vim-style)"
    echo -e "  ${PURPLE}SUPER + 1..9${RESET}         Workspaces"
    echo -e "  ${PURPLE}Print${RESET}                Full screen screenshot"
    echo -e "  ${PURPLE}SHIFT + Print${RESET}        Area screenshot -> Swappy"
    echo -e "  ${PURPLE}SUPER + N${RESET}            Notification center"
    echo ""
    echo -e "${DIM}Config files: ~/.config/hypr/ | ~/.config/waybar/ | ~/.config/rofi/${RESET}"
    echo -e "${DIM}Backup: ~/rice-backup-*/ | Logs: re-run with 'bash -x install.sh' for debug${RESET}"
    echo ""
}

# =====================================================================
#  MAIN
# =====================================================================
main() {
    clear
    banner

    check_not_root
    check_fedora
    confirm

    do_backup
    install_packages
    install_fonts
    install_cursor
    install_gtk_theme
    deploy_configs
    detect_monitors
    install_starship
    install_yazi
    install_firefox
    finalize

    print_summary
}

main "$@"
