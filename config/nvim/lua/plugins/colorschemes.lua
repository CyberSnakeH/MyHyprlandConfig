-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Colorscheme Plugins — All theme plugins for the switcher      ║
-- ║  Author: CyberSnake                                                  ║
-- ║                                                                ║
-- ║  Styles:                                                       ║
-- ║    default — balanced, versatile palettes                      ║
-- ║    lofi    — warm, muted, low-contrast tones                   ║
-- ║    cyber   — neon, high-contrast, futuristic hacker aesthetic  ║
-- ╚══════════════════════════════════════════════════════════════════╝

return {
  -- ── Default Style ──────────────────────────────────────────────

  -- Tokyo Night — primary theme for this rice
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments  = { italic = true },
        keywords  = { italic = true },
        functions = {},
        variables = {},
        sidebars  = "transparent",
        floats    = "transparent",
      },
      on_highlights = function(hl, c)
        hl.CursorLine  = { bg = c.bg_highlight }
        hl.LineNr       = { fg = c.dark5 }
        hl.CursorLineNr = { fg = c.blue, bold = true }
      end,
    },
  },

  -- Nord — arctic, icy blues
  {
    "shaunsingh/nord.nvim",
    priority = 1000,
    config = function()
      vim.g.nord_contrast                = true
      vim.g.nord_borders                 = true
      vim.g.nord_disable_background      = true
      vim.g.nord_italic                  = true
      vim.g.nord_uniform_diff_background = true
    end,
  },

  -- Dracula — classic dark with purple accents
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    opts = {
      transparent_bg = true,
      italic_comment = true,
    },
  },

  -- ── Lofi Style ─────────────────────────────────────────────────
  -- Warm, muted, low-contrast — perfect for late-night coding

  -- Catppuccin Mocha — warm pastels on dark chocolate
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    opts = {
      flavour              = "mocha",
      transparent_background = true,
      term_colors          = true,
      styles = {
        comments    = { "italic" },
        conditionals = { "italic" },
      },
      integrations = {
        indent_blankline = { enabled = true },
        telescope        = { enabled = true },
        treesitter       = true,
      },
    },
  },

  -- Rose Pine — gentle, warm, retro-inspired palette
  {
    "rose-pine/neovim",
    name     = "rose-pine",
    priority = 1000,
    opts = {
      variant            = "main",
      disable_background = true,
      disable_float_background = true,
      styles = {
        italic = true,
        transparency = true,
      },
    },
  },

  -- Kanagawa — muted Japanese ink painting tones
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      transparent = true,
      theme       = "wave",
      colors = {
        theme = {
          all = {
            ui = { bg_gutter = "none" },
          },
        },
      },
    },
  },

  -- Gruvbox — earthy, retro, warm browns and oranges
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      transparent_mode = true,
      contrast         = "hard",
      italic = {
        strings  = false,
        comments = true,
        operators = false,
      },
    },
  },

  -- ── Cyber Style ────────────────────────────────────────────────
  -- Neon, high-contrast, futuristic — the hacker aesthetic

  -- Cyberdream — electric neon on deep void
  {
    "scottmckendry/cyberdream.nvim",
    priority = 1000,
    opts = {
      transparent    = true,
      italic_comments = true,
      borderless_telescope = true,
      theme = {
        variant = "default",
      },
    },
  },

  -- Oxocarbon — IBM carbon design, deep midnight blacks with neon pops
  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
  },

  -- Fluoromachine — synthwave / retrowave neon glow
  {
    "maxmx03/fluoromachine.nvim",
    priority = 1000,
    opts = {
      glow    = true,
      theme   = "fluoromachine",
      transparent = "full",
    },
    config = function(_, opts)
      require("fluoromachine").setup(opts)
    end,
  },
}
