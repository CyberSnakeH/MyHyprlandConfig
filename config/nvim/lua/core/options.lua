-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Core Options — Editor behavior and appearance                 ║
-- ║  Author: CyberSnake                                                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

local opt = vim.opt

-- ── Line numbers ─────────────────────────────────────────────────
opt.number         = true
opt.relativenumber = true
opt.numberwidth    = 4
opt.signcolumn     = "yes"

-- ── Indentation ──────────────────────────────────────────────────
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.softtabstop = 4
opt.expandtab   = true
opt.smartindent = true
opt.breakindent = true

-- ── Search ───────────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase  = true
opt.hlsearch   = true
opt.incsearch  = true

-- ── Appearance ───────────────────────────────────────────────────
opt.termguicolors = true
opt.background    = "dark"
opt.cursorline    = true
opt.showmode      = false         -- lualine handles mode display
opt.pumheight     = 12            -- popup menu height
opt.cmdheight     = 1
opt.laststatus    = 3             -- global statusline
opt.fillchars     = { eob = " " } -- hide ~ on empty lines
opt.shortmess:append("sI")       -- reduce intro messages

-- ── Windows and splits ──────────────────────────────────────────
opt.splitright  = true
opt.splitbelow  = true
opt.scrolloff   = 8
opt.sidescrolloff = 8

-- ── Clipboard ────────────────────────────────────────────────────
opt.clipboard = "unnamedplus"

-- ── Files and persistence ────────────────────────────────────────
opt.undofile   = true
opt.swapfile   = false
opt.backup     = false
opt.writebackup = false

-- ── Completion ───────────────────────────────────────────────────
opt.completeopt = { "menu", "menuone", "noselect" }
opt.updatetime  = 250
opt.timeoutlen  = 400

-- ── Mouse ────────────────────────────────────────────────────────
opt.mouse = "a"

-- ── Wrapping ─────────────────────────────────────────────────────
opt.wrap       = false
opt.linebreak  = true

-- ── Grep program (use ripgrep if available) ──────────────────────
if vim.fn.executable("rg") == 1 then
  opt.grepprg    = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end
