local km = require("config.keymaps")

local plugins = {

  -- ── Foundation ───────────────────────────────────────────────────────────

  { lazy = true, "nvim-lua/plenary.nvim" },

  -- ── Colorscheme ──────────────────────────────────────────────────────────

  { "rktjmp/lush.nvim",           lazy = false, priority = 1001 },
  { dir = vim.fn.stdpath("config"), name = "akko", lazy = false, priority = 1000 },
  { "loctvl842/monokai-pro.nvim", lazy = true },

  -- ── Icons ─────────────────────────────────────────────────────────────────

  {
    "nvim-tree/nvim-web-devicons",
    config = function() require("nvim-web-devicons").setup() end,
  },

  -- ── Treesitter — syntax highlighting + semantic text objects ─────────────

  {
    "nvim-treesitter/nvim-treesitter",
    build        = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config       = function() require "plugins.configs.treesitter" end,
  },

  -- ── Buffer & tab line ─────────────────────────────────────────────────────

  {
    "akinsho/bufferline.nvim",
    event  = "BufReadPre",
    config = function() require "plugins.configs.bufferline" end,
  },

  -- ── Statusline ────────────────────────────────────────────────────────────

  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup { set_vim_settings = false }
    end,
  },

  -- ── Completion — blink.cmp ────────────────────────────────────────────────
  -- Replaces: nvim-cmp, cmp-buffer, cmp-path, cmp-nvim-lsp, cmp_luasnip, cmp-nvim-lua
  -- Faster (Rust fuzzy), built-in signature help, ghost text, cmdline completion.

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

      keymap     = { preset = "default" },
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

  -- ── LSP ───────────────────────────────────────────────────────────────────

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
        ensure_installed = {
          "gopls", "lua_ls", "ts_ls", "rust_analyzer",
          "basedpyright", "clangd", "zls", "yamlls",
        },
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

  -- ── Formatting + Linting ──────────────────────────────────────────────────

  {
    "stevearc/conform.nvim",
    lazy   = true,
    config = function() require "plugins.configs.conform" end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function() require "plugins.configs.lint" end,
  },

  -- ── File explorer ─────────────────────────────────────────────────────────

  {
    "stevearc/oil.nvim",
    opts         = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- ── Git ───────────────────────────────────────────────────────────────────

  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup {
        on_attach = function(buf)
          km.gitsigns(buf, package.loaded.gitsigns)
        end,
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd  = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = km.diffview,
  },

  -- Project-wide search + replace with human-in-the-loop preview.
  -- Pi proposes changes; human reviews every match before anything is written.
  -- Pi calls :GrugFar with prefills = { search = '...', replacement = '...' }.
  {
    "MagicDuck/grug-far.nvim",
    cmd  = { "GrugFar", "GrugFarWithin" },
    keys = km.grug_far,
    opts = {
      startInInsertMode        = false,
      resultsSeparatorLineChar = "-",
    },
  },

  -- ── UI ────────────────────────────────────────────────────────────────────

  {
    "folke/noice.nvim",
    event        = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    config       = function() require "plugins.configs.noice" end,
  },

  { "folke/zen-mode.nvim", opts = {} },

  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts  = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft   = { "markdown" },
    opts = {},
  },

  -- ── Keybinding discovery ──────────────────────────────────────────────────

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {},
  },

  -- ── Code navigation (semantic) ────────────────────────────────────────────
  -- Symbol outline — agents can call aerial.get_location() to know where they
  -- are in the code structure without raw treesitter queries.

  {
    "stevearc/aerial.nvim",
    opts         = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys         = km.aerial,
  },

  -- TODO/FIXME/HACK/NOTE highlights + search
  {
    "folke/todo-comments.nvim",
    event        = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts         = {},
    keys         = km.todo,
  },

  -- ── Snacks ────────────────────────────────────────────────────────────────
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
      terminal     = { enabled = true },
      words        = { enabled = true },
    },
  },

  -- ── Diagnostics ───────────────────────────────────────────────────────────

  {
    "folke/trouble.nvim",
    opts = {},
    cmd  = "Trouble",
    keys = km.trouble,
  },

  -- ── GitHub code review ────────────────────────────────────────────────────

  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup({
        use_local_fs = true,
        picker       = "snacks",
      })
    end,
    cmd  = { "Octo" },
    keys = km.octo,
  },

  -- ── Magit-style Git UI ────────────────────────────────────────────────────

  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config       = true,
    keys         = km.neogit,
  },

  -- ── Go development ────────────────────────────────────────────────────────

  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig", "nvim-treesitter/nvim-treesitter" },
    config       = function() require("go").setup() end,
    event        = { "CmdlineEnter" },
    ft           = { "go", "gomod" },
    build        = ':lua require("go.install").update_all_sync()',
  },

  -- ── Rust development ──────────────────────────────────────────────────────

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy    = false,
    init    = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            km.rust(bufnr)
          end,
        },
      }
    end,
  },

  -- ── Testing (neotest) ─────────────────────────────────────────────────────
  -- Rust uses rustaceanvim's built-in adapter (LSP-based discovery, no extra plugin).
  -- Go  uses neotest-go.

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go"),
          require("rustaceanvim.neotest"),
        },
      })
    end,
    keys = km.neotest,
  },

  -- ── Debug (DAP) ───────────────────────────────────────────────────────────
  -- Go:   needs delve in PATH  —  go install github.com/go-delve/delve/cmd/dlv@latest
  -- Rust: needs codelldb       —  :MasonInstall codelldb  (rustaceanvim auto-detects)

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "leoluz/nvim-dap-go",
    },
    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("dap-go").setup()

      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
    end,
    keys = km.dap,
  },

  -- ── Kubernetes / OpenShift YAML ───────────────────────────────────────────

  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local cfg = require("yaml-companion").setup({
        builtin_matchers = { kubernetes = { enabled = true } },
      })
      require("lspconfig").yamlls.setup(cfg)
    end,
    keys = km.yaml_companion,
  },

  -- ── Prose / commit wrapping ───────────────────────────────────────────────

  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup({
        create_commands             = true,
        create_keymaps              = true,
        notify_on_switch            = true,
        auto_set_mode_heuristically = true,
      })
    end,
    ft = { "markdown", "gitcommit", "text", "rst", "asciidoc" },
  },

}

require("lazy").setup(plugins, require "plugins.configs.lazy")
