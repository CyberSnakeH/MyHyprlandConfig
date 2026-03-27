-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Core Autocommands — Event-driven behavior                     ║
-- ║  Author: CyberSnake                                                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── Highlight on yank ────────────────────────────────────────────
-- Brief visual feedback when copying text

augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group    = "HighlightYank",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ── Remove trailing whitespace on save ───────────────────────────
-- Keeps files clean; skips markdown where trailing spaces are meaningful

augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group   = "TrimWhitespace",
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "markdown" then return end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- ── Return to last edit position ─────────────────────────────────
-- Jump back to where you left off when reopening a file

augroup("LastPosition", { clear = true })
autocmd("BufReadPost", {
  group    = "LastPosition",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── Auto-resize splits on terminal resize ────────────────────────
-- Equalize split proportions when the terminal window changes size

augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group   = "AutoResize",
  command = "tabdo wincmd =",
})

-- ── Close certain buffers with q ─────────────────────────────────
-- Quick-close for non-editable buffer types

augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group   = "QuickClose",
  pattern = { "help", "man", "qf", "checkhealth", "lspinfo", "notify" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = event.buf,
      silent = true,
      desc   = "Close buffer with q",
    })
  end,
})

-- ── Check for file changes on focus ──────────────────────────────
-- Detect external modifications when returning to Neovim

augroup("FocusCheck", { clear = true })
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group   = "FocusCheck",
  command = "checktime",
})
