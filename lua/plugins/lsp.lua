local langs = require("config.languages")

return {
  {
    "mason-org/mason.nvim",
    event    = { "BufReadPre", "BufNewFile" },
    priority = 1000,
    build    = ":MasonUpdate",
    cmd      = { "Mason", "MasonInstall" },
    config   = function() require("mason").setup() end,
  },

  {
    "neovim/nvim-lspconfig",
    event  = { "BufReadPre", "BufNewFile" },
    config = function() require "plugins.configs.lspconfig" end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup {
        automatic_enable = false,
        ensure_installed = langs.mason_ensure_installed(),
      }
    end,
  },

  {
    "folke/lazydev.nvim",
    ft   = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  { "Bilal2453/luvit-meta", lazy = true },

  -- ── Completion ───────────────────────────────────────────────────────────
  -- Replaces: nvim-cmp + all sources. Faster (Rust fuzzy), ghost text, cmdline.

  {
    "saghen/blink.cmp",
    version      = "*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",
    },
    opts = {
      enabled = function()
        return vim.bo[0].filetype ~= "snacks_picker_input"
      end,

      snippets = { preset = "luasnip" },

      sources = {
        default   = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name         = "LazyDev",
            module       = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      keymap = { preset = "enter" },
      completion = {
        accept        = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text    = { enabled = true },
      },
      signature = { enabled = true },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
      require("nvim-autopairs").setup()
    end,
  },

  -- ── Formatting + Linting ─────────────────────────────────────────────────

  {
    "stevearc/conform.nvim",
    lazy   = true,
    config = function() require "plugins.configs.conform" end,
  },

  {
    "mfussenegger/nvim-lint",
    config = function() require "plugins.configs.lint" end,
  },
}
