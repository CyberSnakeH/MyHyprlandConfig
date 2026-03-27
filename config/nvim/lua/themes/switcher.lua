-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Theme Switcher — Multi-style colorscheme picker               ║
-- ║  Author: CyberSnake                                                  ║
-- ║                                                                ║
-- ║  Styles:                                                       ║
-- ║    default — balanced, versatile palettes                      ║
-- ║    lofi    — warm, muted, low-contrast tones                   ║
-- ║    cyber   — neon, high-contrast, futuristic hacker aesthetic  ║
-- ║                                                                ║
-- ║  Usage:                                                        ║
-- ║    require("themes.switcher").pick()    — interactive picker    ║
-- ║    require("themes.switcher").apply(x)  — apply directly       ║
-- ║    require("themes.switcher").by_style(s) — filter by style    ║
-- ╚══════════════════════════════════════════════════════════════════╝

local M = {}

-- ── Theme Registry ───────────────────────────────────────────────
-- Each entry: display name, vim colorscheme command, style category

M.themes = {
  -- Default style — balanced, versatile
  { name = "Tokyo Night",    cmd = "tokyonight-night",  style = "default" },
  { name = "Tokyo Storm",    cmd = "tokyonight-storm",  style = "default" },
  { name = "Tokyo Moon",     cmd = "tokyonight-moon",   style = "default" },
  { name = "Nord",           cmd = "nord",              style = "default" },
  { name = "Dracula",        cmd = "dracula",           style = "default" },

  -- Lofi style — warm, muted, low-contrast
  { name = "Catppuccin",     cmd = "catppuccin-mocha",  style = "lofi" },
  { name = "Rose Pine",      cmd = "rose-pine-main",    style = "lofi" },
  { name = "Kanagawa Wave",  cmd = "kanagawa-wave",     style = "lofi" },
  { name = "Kanagawa Dragon",cmd = "kanagawa-dragon",   style = "lofi" },
  { name = "Gruvbox",        cmd = "gruvbox",           style = "lofi" },

  -- Cyber style — neon, high-contrast, futuristic
  { name = "Cyberdream",     cmd = "cyberdream",        style = "cyber" },
  { name = "Oxocarbon",      cmd = "oxocarbon",         style = "cyber" },
  { name = "Fluoromachine",  cmd = "fluoromachine",     style = "cyber" },
}

-- Style icons for the picker display
local style_icons = {
  default = "",
  lofi    = "󰝚",
  cyber   = "",
}

-- ── Cache file for persistence across sessions ──────────────────

local cache_dir  = vim.fn.stdpath("cache")
local cache_file = cache_dir .. "/nvim_theme"

--- Save the current theme name to disk
---@param colorscheme string
local function save_theme(colorscheme)
  local f = io.open(cache_file, "w")
  if f then
    f:write(colorscheme)
    f:close()
  end
end

--- Load the last-used theme from disk
---@return string|nil
local function load_cached_theme()
  local f = io.open(cache_file, "r")
  if f then
    local theme = f:read("*l")
    f:close()
    return theme
  end
  return nil
end

-- ── Core Functions ───────────────────────────────────────────────

--- Apply a colorscheme by its vim command name
---@param colorscheme string The vim colorscheme name (e.g., "tokyonight-night")
function M.apply(colorscheme)
  -- Try cached theme on first load (when called with default)
  if colorscheme == "tokyonight-night" then
    local cached = load_cached_theme()
    if cached then
      colorscheme = cached
    end
  end

  local ok, err = pcall(vim.cmd.colorscheme, colorscheme)
  if ok then
    save_theme(colorscheme)
  else
    vim.notify(
      "Colorscheme '" .. colorscheme .. "' not found: " .. tostring(err),
      vim.log.levels.WARN
    )
    -- Fallback to a built-in theme
    vim.cmd.colorscheme("habamax")
  end
end

--- Format a theme entry for display in the picker
---@param theme table Theme entry from M.themes
---@return string
local function format_entry(theme)
  local icon = style_icons[theme.style] or ""
  return string.format("  %s  %-20s [%s]", icon, theme.name, theme.style)
end

--- Open the interactive theme picker
--- Uses vim.ui.select (enhanced by dressing.nvim with Telescope backend)
function M.pick()
  local items   = {}
  local lookup  = {}

  for _, t in ipairs(M.themes) do
    local label = format_entry(t)
    table.insert(items, label)
    lookup[label] = t
  end

  vim.ui.select(items, {
    prompt = "  Select Theme:",
    format_item = function(item) return item end,
  }, function(choice)
    if not choice then return end
    local theme = lookup[choice]
    if theme then
      M.apply(theme.cmd)
      vim.notify(
        string.format(" Theme: %s  [%s]", theme.name, theme.style),
        vim.log.levels.INFO
      )
    end
  end)
end

--- Open a picker filtered by style category
---@param style string One of "default", "lofi", "cyber"
function M.by_style(style)
  local items  = {}
  local lookup = {}

  for _, t in ipairs(M.themes) do
    if t.style == style then
      local label = format_entry(t)
      table.insert(items, label)
      lookup[label] = t
    end
  end

  if #items == 0 then
    vim.notify("No themes found for style: " .. style, vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = string.format("  %s Themes:", style:sub(1, 1):upper() .. style:sub(2)),
  }, function(choice)
    if not choice then return end
    local theme = lookup[choice]
    if theme then
      M.apply(theme.cmd)
      vim.notify(
        string.format(" Theme: %s  [%s]", theme.name, theme.style),
        vim.log.levels.INFO
      )
    end
  end)
end

--- Cycle through all themes (useful for quick preview)
--- Press <leader>tt again to confirm, or wait for timeout
function M.cycle()
  local idx = 1

  -- Find current theme index
  local current = vim.g.colors_name or ""
  for i, t in ipairs(M.themes) do
    if t.cmd == current then
      idx = i
      break
    end
  end

  -- Move to next
  idx = (idx % #M.themes) + 1
  local theme = M.themes[idx]

  M.apply(theme.cmd)
  vim.notify(
    string.format(" [%d/%d] %s  [%s]", idx, #M.themes, theme.name, theme.style),
    vim.log.levels.INFO
  )
end

return M
