-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  UI Plugins — Statusline, indent guides, icons                 ║
-- ║  Author: CyberSnake                                                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

return {
  -- ── Lualine — statusline ───────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "auto",
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        globalstatus         = true,
        disabled_filetypes   = {
          statusline = { "lazy" },
        },
      },
      sections = {
        lualine_a = {
          { "mode", fmt = function(str) return str:sub(1, 3) end },
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1, symbols = { modified = " ", readonly = " " } },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy" },
    },
  },

  -- ── Indent Blankline — indent guides ───────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled    = true,
        show_start = false,
        show_end   = false,
      },
      exclude = {
        filetypes = {
          "help", "lazy", "mason", "notify", "checkhealth",
        },
      },
    },
  },

  -- ── Web Devicons — file type icons ─────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      default = true,
    },
  },

  -- ── Dressing — improved vim.ui.select and vim.ui.input ─────────
  -- Makes our theme switcher look polished
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled       = true,
        default_prompt = "> ",
        border        = "rounded",
        win_options   = { winblend = 0 },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = {
          border  = "rounded",
          win_options = { winblend = 0 },
        },
      },
    },
  },
}
