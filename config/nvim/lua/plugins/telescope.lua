-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Telescope — Fuzzy finder for files, grep, buffers             ║
-- ║  Author: CyberSnake                                                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native fzf sorter for performance
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    cmd  = "Telescope",
    opts = {
      defaults = {
        prompt_prefix   = "   ",
        selection_caret = "  ",
        entry_prefix    = "  ",
        sorting_strategy = "ascending",
        layout_strategy  = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width   = 0.55,
          },
          width  = 0.87,
          height = 0.80,
        },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "%.lock",
        },
        path_display = { "truncate" },
        winblend     = 0,
        border       = true,
        borderchars  = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        set_env      = { COLORTERM = "truecolor" },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = vim.fn.executable("fd") == 1
            and { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude", ".git" }
            or nil,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob", "!.git/" }
          end,
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- Load fzf extension if compiled
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
