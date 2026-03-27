-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Core Keymaps — Keyboard shortcuts and leader bindings         ║
-- ║  Author: CyberSnake                                                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

-- Set leader key to space
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────────

-- Exit insert mode with jk
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Save and quit shortcuts
map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>",  { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ── Navigation ───────────────────────────────────────────────────

-- Navigate between splits
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Navigate buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- ── Buffer management ────────────────────────────────────────────

-- Close buffer without closing window
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- ── Window management ────────────────────────────────────────────

-- Resize splits with arrow keys
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Increase height" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Decrease height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- ── File explorer ────────────────────────────────────────────────

map("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Toggle file explorer (netrw)" })

-- ── Telescope ────────────────────────────────────────────────────

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",  { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",   { desc = "Recent files" })

-- ── Terminal ────────────────────────────────────────────────────

-- Toggle terminal split at the bottom
map("n", "<leader>t", function()
  -- Find existing terminal buffer
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_win_close(win, true)
          return
        end
      end
      -- Buffer exists but no window — reopen it
      vim.cmd("botright 15split")
      vim.api.nvim_win_set_buf(0, buf)
      vim.cmd("startinsert")
      return
    end
  end
  -- No terminal buffer — create one
  vim.cmd("botright 15split | terminal")
  vim.cmd("startinsert")
end, { desc = "Toggle terminal" })

-- Exit terminal mode with Escape
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Theme switcher ───────────────────────────────────────────────

map("n", "<leader>tt", function()
  require("themes.switcher").pick()
end, { desc = "Switch colorscheme" })

-- ── Better editing ───────────────────────────────────────────────

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on half-page jumps
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })

-- Keep search results centered
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Better paste (don't overwrite register)
map("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })

-- Indent and stay in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })
