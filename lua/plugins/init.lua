local plugins = {

  -- ── Foundation ──────────────────────────────────────────────────────────

  { lazy = true, "nvim-lua/plenary.nvim" },

  -- ── Colorscheme ─────────────────────────────────────────────────────────

  { "rktjmp/lush.nvim",           lazy = false, priority = 1001 },
  { dir = vim.fn.stdpath("config"), name = "akko", lazy = false, priority = 1000 },
  { "loctvl842/monokai-pro.nvim", lazy = true },

  -- ── Icons ────────────────────────────────────────────────────────────────

  {
    "nvim-tree/nvim-web-devicons",
    config = function() require("nvim-web-devicons").setup() end,
  },

  -- ── Treesitter — syntax highlighting + semantic text objects ────────────

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  -- ── Buffer & tab line ────────────────────────────────────────────────────

  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    config = function()
      require "plugins.configs.bufferline"
    end,
  },

  -- ── Statusline ───────────────────────────────────────────────────────────

  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup { set_vim_settings = false }
    end,
  },

  -- ── Completion — blink.cmp ───────────────────────────────────────────────
  -- Replaces: nvim-cmp, cmp-buffer, cmp-path, cmp-nvim-lsp, cmp_luasnip, cmp-nvim-lua
  -- Faster (Rust fuzzy), built-in signature help, ghost text, cmdline completion.

  {
    "saghen/blink.cmp",
    version = "*",
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
      snippets = { preset = "luasnip" },

      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          -- lazydev gives Neovim API completions in Lua files
          lazydev = {
            name    = "LazyDev",
            module  = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      keymap = { preset = "default" },

      completion = {
        accept        = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text    = { enabled = true },
      },

      signature = { enabled = true },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
      -- autopairs works independently; no cmp event hook needed with blink
      require("nvim-autopairs").setup()
    end,
  },

  -- ── LSP ──────────────────────────────────────────────────────────────────

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
        automatic_enable  = false,
        ensure_installed  = { "gopls", "lua_ls", "ts_ls", "rust_analyzer" },
      }
    end,
  },

  -- Lua/Neovim API type annotations (feeds into blink lazydev source)
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

  -- ── Fuzzy finder ─────────────────────────────────────────────────────────

  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    config       = function() require "plugins.configs.telescope" end,
  },

  -- ── File explorer ────────────────────────────────────────────────────────

  {
    "stevearc/oil.nvim",
    opts         = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- ── Git ──────────────────────────────────────────────────────────────────

  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup {
        on_attach = function(buf)
          local gs = package.loaded.gitsigns
          vim.keymap.set("n", "]h", function() gs.nav_hunk "next" end, { buffer = buf, desc = "Git: next hunk" })
          vim.keymap.set("n", "[h", function() gs.nav_hunk "prev" end, { buffer = buf, desc = "Git: prev hunk" })
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = buf, desc = "Git: preview hunk" })
          vim.keymap.set("n", "<leader>hl", gs.setloclist,   { buffer = buf, desc = "Git: hunks to loclist" })
        end,
      }
    end,
  },

  -- Full-screen diff view + file history
  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Git: diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git: file history" },
    },
  },

  -- ── UI ───────────────────────────────────────────────────────────────────

  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config       = function() require "plugins.configs.noice" end,
  },

  { "folke/zen-mode.nvim", opts = {} },

  -- Color value preview (#hex, rgb()) — maintained fork of norcalli
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts  = {},
  },

  -- Markdown renderer — used by pivi history buffer (filetype=markdown)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft   = { "markdown" },
    opts = {},
  },

  -- ── Keybinding discovery ─────────────────────────────────────────────────
  -- Shows available keymaps in a popup as you type. Also queryable by agents.

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {},
  },

  -- ── Code navigation (semantic) ───────────────────────────────────────────
  -- Symbol outline — agents can call aerial.get_location() to know where they
  -- are in the code structure without raw treesitter queries.

  {
    "stevearc/aerial.nvim",
    opts         = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys         = {
      { "<leader>ao", "<cmd>AerialToggle<cr>", desc = "Aerial: symbol outline" },
    },
  },

  -- TODO/FIXME/HACK/NOTE highlights + search
  {
    "folke/todo-comments.nvim",
    event        = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
    keys         = {
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find: TODOs" },
    },
  },

  -- ── Snacks ───────────────────────────────────────────────────────────────
  -- Multi-tool: dashboard, picker, notifier, input, indent, scroll, terminal…

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy     = false,
    ---@type snacks.Config
    opts = {
      bigfile      = { enabled = true },
      dashboard    = { enabled = true },
      explorer     = { enabled = true },
      indent       = { enabled = true },
      input        = { enabled = true },
      picker       = { enabled = true },
      notifier     = { enabled = true },
      quickfile    = { enabled = true },
      scope        = { enabled = true },
      scroll       = { enabled = true },
      statuscolumn = { enabled = true },
      terminal     = { enabled = true },   -- replaces FTerm
      words        = { enabled = true },
    },
  },

  -- ── Diagnostics ──────────────────────────────────────────────────────────

  {
    "folke/trouble.nvim",
    opts = {},
    cmd  = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                       desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",          desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",               desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                           desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                            desc = "Quickfix List (Trouble)" },
    },
  },

  -- ── Pi agent ─────────────────────────────────────────────────────────────

  {
    dir    = vim.fn.expand("~/Projects/pivi"),
    name   = "pivi",
    lazy   = false,
    config = function()
      require("pivi").setup()
    end,
    keys = {
      { "<leader>pa", "<cmd>PiviAsk<cr>",          desc = "Pi: ask (buffer)" },
      { "<leader>ps", "<cmd>PiviAskSelection<cr>", desc = "Pi: ask (selection)", mode = "v" },
      { "<leader>pf", "<cmd>PiviFile<cr>",         desc = "Pi: send file" },
      { "<leader>pp", "<cmd>PiviSend<cr>",         desc = "Pi: send prompt" },
    },
  },
}

require("lazy").setup(plugins, require "plugins.configs.lazy")
