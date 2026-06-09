return {
  -- ASCII art library — text/neovim category used by the snacks dashboard header.
  -- nui.nvim is already pulled by noice; lazy.nvim deduplicates it.
  {
    "MaximilianLloyd/ascii.nvim",
    lazy         = true,
    dependencies = { "MunifTanjim/nui.nvim" },
  },

  {
    "akinsho/bufferline.nvim",
    event  = "BufReadPre",
    config = function()
      require("bufferline").setup {
        options = {
          themable                = true,
          separator_style         = "slant",
          indicator               = { style = "icon", icon = "▎" },
          modified_icon           = "▪",
          show_buffer_close_icons = false,
          show_close_icon         = false,
        },
      }
    end,
  },

  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup {
        set_vim_settings = false,
        content = {
          active = function()
            local M            = require("mini.statusline")
            local mode, hl     = M.section_mode({ trunc_width = 120 })
            local git          = M.section_git({ trunc_width = 75, icon = "▪" })
            local diff         = M.section_diff({ trunc_width = 75 })
            local diagnostics  = M.section_diagnostics({
              trunc_width = 75,
              signs       = { ERROR = "■", WARN = "▲", INFO = "●", HINT = "◆" },
            })
            -- vim.lsp.status() reads $/progress from all running clients
            -- (attach=false included). Non-empty only during workspace indexing.
            local indexing     = vim.lsp.status()
            local lsp          = indexing ~= "" and indexing or M.section_lsp({ trunc_width = 75 })
            local fname        = M.section_filename({ trunc_width = 140 })
            local finfo        = M.section_fileinfo({ trunc_width = 120 })
            local location     = M.section_location({ trunc_width = 75 })
            local search       = M.section_searchcount({ trunc_width = 75 })

            return M.combine_groups({
              { hl = hl,                       strings = { mode } },
              { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { fname } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { search, finfo } },
              { hl = hl,                       strings = { location } },
            })
          end,
        },
      }
    end,
  },

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

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      icons = {
        breadcrumb = "●",
        separator  = "▪",
        group      = "▸ ",
      },
      -- Suppress diffview's internal keymaps from the popup.
      -- diffview tags them diffview_ignore deliberately; g? is its own help system.
      filter = function(mapping)
        return mapping.desc ~= "diffview_ignore"
      end,
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy     = false,
    ---@type snacks.Config
    opts = {
      bigfile      = { enabled = true },
      dashboard = {
        enabled  = true,
        -- sections is a function so ascii.nvim is required at render time
        -- (not at plugin-spec evaluation time), giving a random art on every open.
        sections = function()
          local ok, art = pcall(require, "ascii")
          local header  = ok
            and table.concat(art.art.text.neovim.dos_rebel, "\n")
            or  "N E O V I M"
          return {
            { text = { header, hl = "SnacksDashboardHeader" }, align = "center", padding = { 2, 0 } },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          }
        end,
        preset = {
          keys = {
            { icon = "▪", key = "f", desc = "Find File",  action = ":lua Snacks.picker.files()"  },
            { icon = "●", key = "r", desc = "Recent",     action = ":lua Snacks.picker.recent()" },
            { icon = "◆", key = "g", desc = "Grep",       action = ":lua Snacks.picker.grep()"   },
            { icon = "■", key = "n", desc = "New File",   action = ":enew"                       },
            { icon = "▦", key = "q", desc = "Quit",       action = ":qa"                         },
          },
        },
      },
      explorer     = { enabled = true },
      indent       = { enabled = true },
      input        = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          -- ivy = full-width bottom strip; description column no longer truncated
          -- preview = false: preview panel was eating ~50% of width, truncating descriptions.
          -- ivy layout uses full terminal width for the list.
          keymaps = { preview = false, layout = { preset = "ivy" } },

          -- Stacked vertical: list on top (full terminal width → paths never clip),
          -- preview on bottom. Mirrors the user story: type a substring, scan
          -- the full qualified path, preview the definition site.
          lsp_workspace_symbols = {
            -- Outer table = layout config object (matches the shape presets use).
            -- Inner table = the actual root box definition; without this wrapping
            -- Snacks' resolver cannot find layout.layout[1] and asserts "no root box found".
            layout = {
              layout = {
                box       = "vertical",
                backdrop  = false,
                width     = 0,
                height    = 0.65,
                row       = -1,
                border    = "top",
                title     = " {title} {live} {flags}",
                title_pos = "left",
                { win = "input",   height = 1,   border = "bottom" },
                { win = "list",    border = "none" },
                { win = "preview", title = "{preview}", height = 0.45, border = "top" },
              },
            },
          },
        },
      },
      notifier     = { enabled = true },
      quickfile    = { enabled = true },
      scope        = { enabled = true },
      scroll       = { enabled = true },
      statuscolumn = { enabled = true },
      lazygit      = { enabled = true },
      terminal     = { enabled = true },
      words        = { enabled = true },
    },
  },
}
