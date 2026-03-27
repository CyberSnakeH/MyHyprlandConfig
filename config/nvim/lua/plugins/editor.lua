-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Editor Plugins — Treesitter, autopairs, commenting, surround  ║
-- ║  Author: CyberSnake                                                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

return {
  -- ── Treesitter — syntax highlighting and text objects ───────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection    = "<C-space>",
          node_incremental  = "<C-space>",
          scope_incremental = false,
          node_decremental  = "<BS>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- ── Autopairs — automatic bracket/quote closing ────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts          = true,  -- treesitter integration
      fast_wrap         = {},
      disable_filetype  = { "TelescopePrompt" },
    },
  },

  -- ── Comment.nvim — toggle comments with gc / gcc ───────────────
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- ── nvim-surround — add/change/delete surrounding pairs ───────
  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    opts    = {},
  },

  -- ── Todo Comments — highlight TODO, FIXME, NOTE, etc. ──────────
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
    },
  },
}
