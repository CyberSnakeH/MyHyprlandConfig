-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Neovim Configuration — Tokyo Night Hyprland Rice              ║
-- ║  Author: CyberSnake                                                  ║
-- ║  Date: 2026-03-26                                              ║
-- ║  Requires: Neovim >= 0.10, git, a Nerd Font                   ║
-- ╚══════════════════════════════════════════════════════════════════╝

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core settings before plugins
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load plugins via lazy.nvim (auto-discovers lua/plugins/*.lua)
require("lazy").setup("plugins", {
  defaults = { lazy = false },
  install  = { colorscheme = { "tokyonight" } },
  checker  = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
})

-- Apply default theme
require("themes.switcher").apply("tokyonight-night")
